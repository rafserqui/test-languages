# Functions to compute objects from the model
function transport_cost(delT,In,gamm,N,synth = true)
    #------------------------------------------------
    # Compute transport costs w Dijkstra
    #------------------------------------------------
    if synth == true
        NN = N^2
    else
        NN = N
    end
       
    # Adjacency matrix
    Adj = zeros(NN,NN)
    idx = findall(x -> x > 0, In)
    Adj[idx] .= 1
    
    # Weights of the graph (in matrix form)
    W = (Adj .* delT) ./ (In.^(gamm))
    idnan = isnan.(W)
    W[idnan] .= 0
    W = W.*Adj
    
    # Weighted Graph
    G = SimpleWeightedGraph(NN)
    index = findall(x -> x == 1, Adj)
    rows = map(i -> i[1], index)
    cols = map(i -> i[2], index)
    rows = rows[:]
    cols = cols[:]
    edges = [rows cols]
    
    for (r, c) in zip(edges[:,1],edges[:,2])
        add_edge!(G, Int(r), Int(c), W[r,c])
    end
    
    # Compute shortest paths
    T = zeros(NN,NN)
    for ii in 1:NN
        tau = dijkstra_shortest_paths(G, ii)
        T[ii,:] = tau.dists
    end
    
    T[diagind(T)] .= 1
    T .= max.(1, T)
    T = (T + T') ./ 2.0
    
    return (T, G)
end

function electricity_quality(params,Vi)
    #------------------------------------------------
    # Compute quality of electricity
    #------------------------------------------------
    @unpack delG, phi = params
    Gi = delG.*(Vi.^(phi))
    return Gi
end

function tfp_spill(params,Li,Gi,In)
    @unpack Amat, Tnet, alphT, iotT, muT = params
    
    #------------------------------------------------
    # Compute composite TFP
    #------------------------------------------------
    ala = alphT[1]
    alm = alphT[2]
    als = alphT[3]

    iotaa = iotT[1]
    iotam = iotT[2]
    iotas = iotT[3]

    mua = muT[1]
    mum = muT[2]
    mus = muT[3]

    # Compute centrality
    GIjk = Tnet
    GIjk.weights = In
    Ri = eigenvector_centrality(GIjk)
    Ri = Ri ./ sum(Ri)

    # Composite TFPs
    Aa = Amat[:,1] .* (Li.^(ala)).*(Gi.^(iotaa)).*(Ri.^(mua))
    Am = Amat[:,2] .* (Li.^(alm)).*(Gi.^(iotam)).*(Ri.^(mum))
    As = Amat[:,3] .* (Li.^(als)).*(Gi.^(iotas)).*(Ri.^(mus))

    Ai = hcat(Aa,Am,As)

    return Ai, Ri
end

function trade_shares(params,Ai,wi,bi)
    #------------------------------------------------
    # Compute matrices of trade shares
    #------------------------------------------------
    betas = params.betas
    sigm  = params.sigm
    NN    = params.NN
    T     = params.T

    # Function of betas
    theta = ((1 ./ betas).^(betas)).*((1 ./ (1 .- betas)).^(1 .- betas))   
    
    num_pia = zeros(NN,NN)
    num_pim = zeros(NN,NN)
    num_pis = zeros(NN,NN)
        
    # Compute trade shares
    npia = ((theta[1].*(wi.^(betas[1])).*(bi.^(1 .- betas[1])))./(Ai[:,1])).^(1-sigm)
    npim = ((theta[2].*(wi.^(betas[2])).*(bi.^(1 .- betas[2])))./(Ai[:,2])).^(1-sigm)
    npis = ((theta[3].*(wi.^(betas[3])).*(bi.^(1 .- betas[3])))./(Ai[:,3])).^(1-sigm)
    
    NNones = ones(1,NN)
    num_pia = npia * NNones
    num_pim = npim * NNones
    num_pis = npis * NNones
    
    Tsig = T.^(1 - sigm)

    num_pia = num_pia.*Tsig
    num_pim = num_pim.*Tsig
    num_pis = num_pis.*Tsig
    
    # num_pid(i,j) = price of producing in i and consuming in j
    # Sum_i num_pid(i,j) = (1 x N^2) => premult by ones(N^2,1) to repeat

    # Since it is consumption, we need to sum each row for each column.
    # First column would denote consumption of location 1 from all other locations
    dpi_a = similar(num_pia)
    dpi_m = similar(num_pia)
    dpi_s = similar(num_pia)
    dpi_a = (NNones') * (sum(num_pia, dims = 1))
    dpi_m = (NNones') * (sum(num_pim, dims = 1))
    dpi_s = (NNones') * (sum(num_pis, dims = 1))

    # dnom_pi_d is an (N^2 x N^2) matrix with the same number in all rows for each column

    # Import shares
    # pi_d(i,j) = proportion of imports of j that come from i
    pia = num_pia./(dpi_a)
    pim = num_pim./(dpi_m)
    pis = num_pis./(dpi_s)

    return pia, pim, pis
end


function inner_price_index(params,Ai,wi,bi)
    #------------------------------------------------
    # Compute matrix of sectoral price indices (N x D)
    #------------------------------------------------
    # Parameters
    betas = params.betas
    sigm  = params.sigm
    NN    = params.NN
    T     = params.T

    wi = repeat(wi,1,3)
    bi = repeat(bi,1,3)

    # Function of betas
    theta = ((1 ./ betas).^(betas)).*((1 ./ (1 .- betas)).^(1 .- betas)) 
    Tpow = (T.^(1-sigm))

    # Compute price at origin
    Pdn_temp = (((theta').*(wi.^(betas')).*(bi.^(1 .- betas')))./Ai).^(1 - sigm)
        
    # Add transport cost to each other location
    Pdn = similar(Pdn_temp)
    Pdn  = Tpow * Pdn_temp
    
    # Pan (N^2 x N^2).
    # Pan(i,j) = price produced in i and taken to j
    # Sum_i Pan(i,j) = Pan
    Pdn = Pdn.^(1 / (1 - sigm))
    
    return Pdn
end

function aggregate_price_index_cobbdouglas(params,Pdn)
    omd = [params.oma, params.omm, params.oms]
    Pn = prod((Pdn./omd').^(omd'), dims = 2)
end

function sectoral_employment_shares_disp(params,Ai,Li,wi,bi)
    # Compute trade shares
    pi_a, pi_m, pi_s = trade_shares(params,Ai,wi,bi)

    # Compute price index
    Pdn = inner_price_index(params,Ai,wi,bi)

    # Consumption shares are obtained using eqn (19)
    omd = [params.oma, params.omm, params.oms]
    numX = (omd'.^(params.rho)).*(Pdn.^(1 - params.rho))

    # Note I transpose to have column vectors
    Xd = numX./(sum(numX, dims = 2))

    # Income in each location
    tinc = wi.*Li + bi.*params.Ei
        
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
    Lai = (params.betas[1].*params.nu.*XIpia)./wi
    Lmi = (params.betas[2].*params.nu.*XIpim)./wi
    Lsi = (params.betas[3].*params.nu.*XIpis)./wi
        
    # Ensure these add up to total population
    totemp = Lai + Lmi + Lsi
    Lai = (Lai./(totemp)).*Li
    Lmi = (Lmi./(totemp)).*Li
    Lsi = (Lsi./(totemp)).*Li

    return hcat(Lai, Lmi, Lsi)
end