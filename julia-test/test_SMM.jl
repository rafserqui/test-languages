using Distributed
addprocs(3)

@everywhere using Random, DataFrames, Gadfly, CSV, JuMP, Ipopt, Statistics

Random.seed!(1234)

const N     = 1000      # Number of agents
const gamma = 0.5
const tau   = 0.2
const S     = 10

df = DataFrame(CSV.File("./julia-test/consump_leisure.csv"))

# Function to parallelize moments
@everywhere include("est_smm_inner.jl")

function parallel_moments(params, NN, dff, S)
    results = zeros(2, S)
    Threads.@threads for i = 1:S
        vrs = sim_moments(params, NN, dff)
        results[:,i] = vrs'
    end

    avg_c_mom = mean(results[1,:])
    avg_l_mom = mean(results[2,:])

    SSR = avg_c_mom^2 + avg_l_mom^2

    return SSR
end

using Optim

function SMM(S, NN, dff)
    lb = [0.0; 0.0]
    x0 = [0.5; 0.5]
    ub = [1.0; 1.0]
    out = Optim.optimize(params -> parallel_moments(params, NN, dff, S), lb, ub, x0, Fminbox())

    return out
end

opt_coefs = SMM(S,N,df)