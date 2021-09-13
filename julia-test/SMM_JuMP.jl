using Distributed
addprocs(4)

using JuMP, Ipopt

cd("/home/rafserqui/Documents/Research/test-languages/julia-test/")

# Add all functions and parameters necessary for estimation
@everywhere include("spatial_eqbm_optimization.jl")

# Compute moments in parallel
@everywhere function parallel_moments(x...)
    # Compute decentralized equilibrium in parallel
    moms = @distributed (hcat) for s = 1:S
        functionEqbm(x, hcat(Aas[:,s], Ams[:,s], Ass[:,s]));
    end
    avg_moms = mean(moms, dims = 2);
    err_vec = (avg_moms .- emp_moms) ./ emp_moms;
    
    W = Matrix{Float64}(I, length(emp_moms), length(emp_moms));

    # Weighting matrix
    W = Matrix(1.0 .* I(length(emp_moms)))
    for (id, k) in enumerate(emp_moms)
        W[id,id] = 1.0/(emp_moms[id,1])
    end

    QQ = (err_vec') * W * err_vec;
    return QQ[1,1]
end

# Define model
using Ipopt
smm_model = Model(Ipopt.Optimizer; bridge_constraints = false)

# Register function
register(smm_model, :parallel_moments_f, 9, parallel_moments; autodiff = true)

# Define variables, starting values, and lower bounds
@variables(smm_model, begin
    pps[s = 1:9] >= 0.0001, (start = priors[s])
end)    

# Define objective function
@NLobjective(smm_model, Min, parallel_moments_f(pps[1],pps[2],pps[3],
                                            pps[4],pps[5],pps[6],
                                            pps[7],pps[8],pps[9]))

# Optimization
optimize!(smm_model)

# Why stopped and if feasible
termination_status(smm_model)
primal_status(smm_model)
dual_status(smm_model)

# Minimizer
value.(pps)

@unpack alphT, muT, iotT = mparams

hcat(alphT,muT,iotT)
hcat(value.(pps[1:3]),value.(pps[4:6]),value.(pps[7:9]))