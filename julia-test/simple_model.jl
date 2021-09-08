using Ipopt: Threads
using Random, DataFrames, Gadfly, Distributed, CSV, JuMP, Ipopt, Statistics

Random.seed!(1234)

const N = 1000      # Number of agents
const gamma = 0.5
const tau = 0.2

# Draw income data and optimal consumption leisure
epsi = randn(N)
wage = 10 .+ randn(N)

consump = gamma*tau*wage .+ gamma*epsi
leisure = (1.0 - gamma) .+ ((1.0 - gamma) / (1.0 - tau)).*(epsi ./ wage)

# Set as a dataframe for exporting
df = DataFrame(consump = consump, leisure = leisure, wage = wage, epsi = epsi)

# Plot
plot_c = plot(df, x =:wage, y =:consump, Geom.smooth(method =:loess))

CSV.write("./julia-test/consump_leisure.csv", df)

#-----------------------------------------------------------------
# Numerical Simulation of Optimal Behavior
#-----------------------------------------------------------------

# Function for Model
function hh_constrained_opt(g,t,w,e,N)
    # Declare model, variables, constraint, and objective function
    mod = Model(Ipopt.Optimizer)
    set_optimizer_attribute(mod, "print_level", 0)
    @variable(mod, c[i=1:N] >= 0)  # Define positive consumption for each agent
    @variable(mod, 0 <= l[i=1:N] <= 1) # Define leisure between 0 and 1 as a variable of the model
    @constraint(mod, bcons,  c .== (1.0 - t).*(1.0 .- l).*w .+ e)
    @NLobjective(mod, Max, sum(g*log(c[i]) + (1 - g)*log(l[i]) for i in 1:N))
    
    optimize!(mod)
    
    c_opt = value.(c)
    l_opt = value.(l)
    
    return hcat(c_opt, l_opt)
end

# Test function
demand = hh_constrained_opt(0.8, 0.3, df[:,"wage"], df[:,"epsi"], N)

# Function to simulate moments
function sim_moments(params,N,df)
    c_epsi = randn(N)
    gg, tt = params
    c_demand = hh_constrained_opt(gg, tt, df[:,"wage"], c_epsi, N);

    # Moments
    c_moment = (mean(c_demand[:,1]) - mean(df[:,"consump"])) ./ mean(df[:,"consump"])
    l_moment = (mean(c_demand[:,2]) - mean(df[:,"leisure"])) ./ mean(df[:,"leisure"])

    return hcat(c_moment, l_moment)
end

# Test simulate moments
S = 10
res = zeros(S,2)
@time for ss in 1:S
    res[ss,:] = sim_moments([gamma, tau],N,df);
end

# Function to parallelize moments
@everywhere include("./est_smm_inner.jl")

function parallel_moments(params, NN, dff, S)
    params = exp.(params) ./ (1.0 .+ exp.(params))
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
    out = Optim.optimize(params -> parallel_moments(params, NN, dff, S), [0.1; 0.1], method = NelderMead())

    return exp.(out.minimum) ./ (1.0 .+ exp(out.minimum))
end

opt_coefs = SMM(S,N,df)