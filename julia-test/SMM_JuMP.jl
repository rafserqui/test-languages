using Distributed, JuMP, Ipopt

addprocs(4)
cd("/home/rafserqui/Documents/Research/test-languages/julia-test/")

# Add all functions and parameters necessary for estimation
@everywhere include("spatial_eqbm_optimization.jl")

# Compute moments in parallel
function parallel_moments(x)
    # Compute decentralized equilibrium in parallel
    moms = @distributed (hcat) for s = 1:S
        functionEqbm(x, Aas[:,s], Ams[:,s], Ass[:,s]);
    end
    avg_moms = mean(moms, dims = 2);
    err_vec = (avg_moms .- emp_moms) ./ emp_moms;
    
    W = Matrix{Float64}(I, length(emp_moms), length(emp_moms));

    QQ = (err_vec') * W * err_vec;
    return QQ[1,1]
end

# Define model
smm_model = Model(Ipopt.Optimizer)

# Define variables, starting values, and lower bounds
@variable(smm_model, pps[1:9] .>= 0, start = priors)

# Define objective function
@NLobjective(smm_model, Min, parallel_moments)

# Optimization
optimize!(smm_model)

# Why stopped and if feasible
termination_status(smm_model)
primal_status(smm_model)
dual_status(smm_model)

# Minimizer
value(pps)

