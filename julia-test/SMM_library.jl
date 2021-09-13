using Distributions, Random, Plots, MSM, LaTeXStrings, DataStructures, OrderedCollections, LinearAlgebra

gr()

Random.seed!(1234)  #for replicability reasons
const T = 100000          #number of periods
const P = 2               #number of dependent variables
const beta0 = rand(P)     #choose true coefficients by drawing from a uniform distribution on [0,1]
const alpha0 = rand(1)[]  #intercept
const theta0 = 0.0        #coefficient to create serial correlation in the error terms

println("True intercept = $(alpha0)")
println("True coefficient beta0 = $(beta0)")
println("Serial correlation coefficient theta0 = $(theta0)")

function generate_data(T, P, beta0, alpha0, theta0)
    # Generation of error terms
    # row = individual dimension
    # column = time dimension 
    
    U = zeros(T)
    d = Normal()
    U[1] = rand(d, 1)[] #first error term
    # loop over time periods
    for t = 2:T
        U[t] = rand(d, 1)[] + theta0*U[t-1]
    end
    
    
    # Let's simulate the dependent variables x_t
    x = zeros(T, P)
    d = Uniform(0, 5)
    for p = 1:P  
        x[:,p] = rand(d, T)
    end
    
    # Let's calculate the resulting y_t
    y = zeros(T)
    for t=1:T
        y[t] = alpha0 + x[t,1]*beta0[1] + x[t,2]*beta0[2] + U[t]
    end

    return x, y
end

x, y = generate_data(T, P, beta0, alpha0, theta0)


p1 = scatter(x[1:100,1], y[1:100], xlabel = "x1", ylabel = "y", legend=:none, smooth=true)
p2 = scatter(x[1:100,2], y[1:100], xlabel = "x2", ylabel = "y", legend=:none, smooth=true)
p  = plot(p1, p2)


# Here we set the maximum number of function evaluations to be 10000.
# We also select a global optimizer (see BlackBoxOptim.jl) and a local minimizer (see Optim.jl)
# https://github.com/robertfeldt/BlackBoxOptim.jl
# https://julianlsolvers.github.io/Optim.jl
myProblem = MSMProblem(options = MSMOptions(maxFuncEvals=10000, globalOptimizer = :dxnes, localOptimizer = :LBFGS));

dictEmpiricalMoments = OrderedDict{String,Array{Float64,1}}()
dictEmpiricalMoments["mean"] = [mean(y)] #informative on the intercept
dictEmpiricalMoments["mean_x1y"] = [mean(x[:,1] .* y)] #informative on betas
dictEmpiricalMoments["mean_x2y"] = [mean(x[:,2] .* y)] #informative on betas
dictEmpiricalMoments["mean_x1y^2"] = [mean((x[:,1] .* y).^2)] #informative on betas
dictEmpiricalMoments["mean_x2y^2"] = [mean((x[:,2] .* y).^2)] #informative on betas
set_empirical_moments!(myProblem, dictEmpiricalMoments)

W = Matrix(1.0 .* I(length(dictEmpiricalMoments)))#initialization
#Special case: diagonal matrix
#Sum of square percentage deviations from empirical moments
#(you may choose something else)
for (indexMoment, k) in enumerate(keys(dictEmpiricalMoments))
    W[indexMoment,indexMoment] = 1.0/(dictEmpiricalMoments[k][1])^2
end

set_weight_matrix!(myProblem, W)

myProblem.empiricalMoments

myProblem.W

dictPriors = OrderedDict{String,Array{Float64,1}}()
dictPriors["alpha"] = [0.5, 0.001, 1.0]
dictPriors["beta1"] = [0.5, 0.001, 1.0]
dictPriors["beta2"] = [0.5, 0.001, 1.0]

set_priors!(myProblem, dictPriors)

function functionLinearModel(x; uniform_draws::Array{Float64,1}, simX::Array{Float64,2}, nbDraws::Int64 = length(uniform_draws), burnInPerc::Int64 = 0)
    T = nbDraws
    P = 2       #number of dependent variables

    alpha = x[1]
    beta = x[2:end]
    theta = 0.0     #coefficient to create serial correlation in the error terms

    # Creation of error terms
    # row = individual dimension
    # column = time dimension
    U = zeros(T)
    d = Normal()
    # Inverse cdf (i.e. quantile)
    gaussian_draws = quantile.(d, uniform_draws)
    U[1] = gaussian_draws[1] #first error term

    # loop over time periods
    for t = 2:T
        U[t] = gaussian_draws[t] + theta*U[t-1]
    end

    # Let's calculate the resulting y_t
    y = zeros(T)

    for t=1:T
        y[t] = alpha + simX[t,1]*beta[1] + simX[t,2]*beta[2] + U[t]
    end

    # Get rid of the burn-in phase:
    #------------------------------
    startT = max(1, Int(nbDraws * (burnInPerc / 100)))

    # Moments:
    #---------
    output = OrderedDict{String,Float64}()
    output["mean"] = mean(y[startT:nbDraws])
    output["mean_x1y"] = mean(simX[startT:nbDraws,1] .* y[startT:nbDraws])
    output["mean_x2y"] = mean(simX[startT:nbDraws,2] .* y[startT:nbDraws])
    output["mean_x1y^2"] = mean((simX[startT:nbDraws,1] .* y[startT:nbDraws]).^2)
    output["mean_x2y^2"] = mean((simX[startT:nbDraws,2] .* y[startT:nbDraws]).^2)

    return output
end

# Let's freeze the randomness during the minimization
d_Uni = Uniform(0,1)
nbDraws = T #number of draws in the simulated data
uniform_draws = rand(d_Uni, nbDraws)
simX = zeros(length(uniform_draws), 2)
d = Uniform(0, 5)
for p = 1:2
  simX[:,p] = rand(d, length(uniform_draws))
end

set_simulate_empirical_moments!(myProblem, x -> functionLinearModel(x, uniform_draws = uniform_draws, simX = simX))

# Construct the objective function using:
#* the function: parameter -> simulated moments
#* emprical moments values
#* emprical moments weights
construct_objective_function!(myProblem)

# Global optimization:
msm_optimize!(myProblem, verbose = false)

minimizer = msm_minimizer(myProblem)
minimum_val = msm_minimum(myProblem)

println("Minimum objective function = $(minimum_val)")
println("Estimated value for alpha = $(minimizer[1]). True value for beta1 = $(alpha0[1])")
println("Estimated value for beta1 = $(minimizer[2]). True value for beta1 = $(beta0[1])")
println("Estimated value for beta2 = $(minimizer[3]). True value for beta2 = $(beta0[2])")