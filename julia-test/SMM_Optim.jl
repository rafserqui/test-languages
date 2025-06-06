using Distributed
addprocs(4)
cd("D:/RESEARCH/test-languages/julia-test/")

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

using BlackBoxOptim
#LBFGS(), autodiff=:forward
function MSM()
  out = bboptimize(parallel_moments; SearchRange = (0.0001, 0.5), NumDimensions = 9)
  #out = optimize(parallel_moments,priors,NelderMead())
  
  # Show result of the estimation
  println(out)
  return out
end

# Perform MSM
pars_smm = MSM()
bs = best_candidate(pars_smm)
bf = best_fitness(pars_smm)
#pars_smm = MSM()
#Optim.minimizer(pars_smm)
#Optim.x_converged(pars_smm)