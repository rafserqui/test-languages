# Equilibrium functions
function factor_prices_disp(x0,params,Ai,Li,tol)
    #------------------------------------------------
    #   This function computes the equilibrium factor 
    #   prices {wi,bi} for given exogenous parameters 
    #   and a guess for the labor distribution in 
    #   each location.
    #------------------------------------------------
    #   Inputs
    #------------------------------------------------
    #   1.- x: two (N^2 x 2) vectors of factor prices
    #      denoting the initial guess
    #   2.- params: a (5 x 1) vector of parameters of
    #       preferences.
    #   3.- betas: an (N^2 x D) matrix of labor 
    #       intensities
    #   4.- Ai: an (N^2 x D) matrix of composite TFPs
    #   5.- T: an (N^2 x N^2) matrix of transport
    #       costs
    #   6.- Ei: an (N^2 x 1) vector of electricity
    #       supply at the location level
    #   7.- Li: an (N^2 x 1) vector of labor allocations
    #   8.- N: a scalar denoting the number of
    #       locations (N^2)
    #   9.- tol: a tolerance level to stop function
    #------------------------------------------------
    #   Outputs
    #------------------------------------------------
    #   1.- x: an (N^2 x 2) matrix of solved factor 
    #       prices {wi,bi}.
    #   
    # Start function
    #------------------------------------------------
    wi = x0[:,1]
    bi = x0[:,2]

    # Tolerance and algorithm parameters
    maxit  = 1e5       # Max iterations
    it = 1             # Initialize iterations
    maxdev = Inf       # Initial deviation
    upcoeff = 0.25     # Updating coefficient

    # Constant parameters
    @unpack oma, omm, oms, rho, Ei, betas, nu, NN = params
    omd = [oma, omm, oms]

    while it < maxit && maxdev > tol
        # Trade shares (what each location consumes from each other)
        pi_a, pi_m, pi_s = trade_shares(params,Ai,wi,bi)

        # Sectoral Consumption Shares (need price AT DESTINATION)
        Pdn = inner_price_index(params,Ai,wi,bi)

        # Consumption shares are obtained using eqn (19)
        numX = (omd'.^(rho)).*(Pdn.^(1 - rho))

        # Note I transpose to have column vectors
        Xd = numX./(sum(numX, dims = 2))

        # Income in each location
        tinc = wi.*Li + bi.*Ei
        
        # Share of income devoted to D-Sector
        XI = Xd.*tinc

        # Share of income devoted to D-sector imported from other locations
        XIpia = similar(XI[:,1])
        XIpim = similar(XI[:,1])
        XIpis = similar(XI[:,1])
        XIpia = pi_a * XI[:,1]
        XIpim = pi_m * XI[:,2]
        XIpis = pi_s * XI[:,3]

        #  Compute sectoral-employment levels
        Lai = (betas[1].*nu.*XIpia)./wi
        Lmi = (betas[2].*nu.*XIpim)./wi
        Lsi = (betas[3].*nu.*XIpis)./wi
        
        # Ensure these add up to total population
        totemp = Lai + Lmi + Lsi
        Lai = (Lai./(totemp)).*Li
        Lmi = (Lmi./(totemp)).*Li
        Lsi = (Lsi./(totemp)).*Li

        # Eqn (22) in model-beta-locations.pdf
        wi_e = (1 ./ Li).*(betas[1].*nu.*XIpia + betas[2].*nu.*XIpim + betas[3].*nu.*XIpis)
        wi_e = (wi_e./sum(wi_e, dims = 1)).*NN

        bi_e = ((wi_e.*Li)./(nu.*Ei)).*(1 - nu .+ ((1-betas[1])./betas[1]).*(Lai./Li) .+ ((1-betas[2])./betas[2]).*(Lmi./Li) .+ ((1-betas[3])./betas[3]).*(Lsi./Li))
        bi_e[bi_e .== NaN] .= 0
    
        # Compute deviations
        wi_dev = norm(wi_e .- wi)
        
        # Max deviations        
        maxdev = wi_dev

        # Update guess
        wi = upcoeff.*wi_e .+ (1-upcoeff).*wi
        bi = upcoeff.*bi_e .+ (1-upcoeff).*bi
        it += 1

        # Relax tolerance if too long. Necessary in earlier iterations
        if it > 1000
            tol = 1e-8;
        end
    end

    x = hcat(wi, bi)

    return x
end

function labor_update_guess_disp(wi,bi,Pi,L,Li0,params)
    # Unpack parameters
    @unpack nu, nui, bbi = params 
    
    # Initial guess
    Li1 = similar(Li0)
    num = similar(Li0)
    den = 0
    nutt = ((1-nu)./nu).^(1-nu)

    # Convergence parameters
    difference = Inf
    tol        = 1e-13
    maxiter    = 1e8
    it         = 1

    dd = ((Pi.^(nu)).*(bi.^(1 - nu)))

    while difference > tol && it <= maxiter
        num = (nutt.*(nui).*wi.*(Li0.^(1 + bbi))) ./ dd
        den = sum(num)

        Li1 = (num ./ den) .* L

        # Check difference
        difference = norm(Li1 .- Li0)
        Li0 = Li1
        it += 1
    end
    Li = Li1
    Ubar = (den/L)
    Ub = num./Li

    return Li, Ubar, Ub
end

function endog_eqbm_dispersion(params,infrastructure)
    # Parse parameters
    @unpack L, delG, phi, Amat, alphT, iotT, muT, gamm, Tnet = params
    
    # L     = params.L
    # delG  = params.delG
    # phi   = params.phi
    # Amat  = params.Amat
    # alphT = params.alphT
    # iotT  = params.iotT
    # muT   = params.muT
    # gamm  = params.gamm
    # Tnet  = params.G
    I     = infrastructure.In
    Vi    = infrastructure.Vi

    Gi = electricity_quality(params,Vi)
    
    # Algorithm parameters
    tol_epsi = 1e-7     # Convergence criterion    
    difference = Inf    # Initial difference
    maxit = 1e7         # Max number of iterations
    it = 1              # Iteration counter
    ucoeff = 0.25       # Updating coefficient
    converged = 0

    # For display
    out_iter = 150
    show_output = true

    # Initial guesses
    Li0 = ones(NN,1).*(L/NN)
    wi0 = ones(NN,1)
    bi0 = ones(NN,1)

    x0 = hcat(wi0,bi0)

    Li = similar(Li0)
    wi = similar(wi0)
    bi = similar(bi0)
    Ub = similar(Li0)
    Ubar = 0
    while (it <= maxit) && (difference > tol_epsi)
        # Compute TFP composite only if not solved for
        Ai, Ri = tfp_spill(params,Li0,Gi,I)
        
        # Solve {wi,bi} such that (36) and (37) hold in model
        fp = factor_prices_disp(x0,params,Ai,Li0,tol_epsi)

        wi = fp[:,1]
        bi = fp[:,2]

        # Update guess for solver in next iteration
        x0 = fp

        # Compute Pi using (17)
        Pdn = inner_price_index(params,Ai,wi,bi)
        Pi = aggregate_price_index_cobbdouglas(params,Pdn)
            
        # Compute new guess for {wi} using (25)
        Li1, Ubar, Ub = labor_update_guess_disp(wi,bi,Pi,L,Li0,params)
        Li1[Li1 .< 0] .= 0
    
        difference = norm(Li1 .- Li0)
        it += 1
    
        # Update guess
        Li0 = ucoeff.*Li1 .+ (1-ucoeff).*Li0

        # Inform every 10 iterations
        if mod(it,out_iter) == 0 && show_output == true
            println("Iteration: $it")
            println("Max diff: $difference")
            println("-------------------------------------------")
        end

        # Dummy for convergence
        if it == maxit && difference > tol_epsi
            converged = 0
        elseif it < maxit && difference < tol_epsi
            converged = 1
        else
            converged = 2
        end
    end # End while loop

    Li = Li0
    Ai, Ri = tfp_spill(params,Li,Gi,I)

    # Sector-location employment shares 
    Ldn = sectoral_employment_shares_disp(params,Ai,Li,wi,bi)

    # Aggregate Sectoral Shares
    Pdn = inner_price_index(params,Ai,wi,bi)
    Pi  = aggregate_price_index_cobbdouglas(params,Pdn)

    # Export as a struct file
    Li = vec(Li)
    Pi = vec(Pi)
    Ub = vec(Ub)
    wi = vec(wi)
    bi = vec(bi)
    init_eqbm = (Li = Li,
                Pi = Pi,
                Ub = Ub,
                wi = wi,
                bi = bi,
                Ai = Ai,
                Ldn = Ldn,
                Pdn = Pdn)

    #init_eqbm.Amat = Amat
    #init_eqbm.Gi   = Gi
    #init_eqbm.Ri   = Ri
    return init_eqbm
end
