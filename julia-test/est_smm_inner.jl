function sim_moments(params,NN,dff)
    c_epsi = randn(NN)
    gg, tt = params
    c_demand = hh_constrained_opt(gg, tt, dff[:,"wage"], c_epsi, NN);

    # Moments
    c_moment = (mean(c_demand[:,1]) - mean(dff[:,"consump"])) ./ mean(dff[:,"consump"])
    l_moment = (mean(c_demand[:,2]) - mean(dff[:,"leisure"])) ./ mean(dff[:,"leisure"])

    return hcat(c_moment, l_moment)
end

function hh_constrained_opt(g,t,w,e,NN)
    # Declare model, variables, constraint, and objective function
    mod = Model(Ipopt.Optimizer)
    set_optimizer_attribute(mod, "print_level", 0)
    @variable(mod, c[i=1:NN] >= 0)  # Define positive consumption for each agent
    @variable(mod, 0 <= l[i=1:NN] <= 1) # Define leisure between 0 and 1 as a variable of the model
    @constraint(mod, bcons,  c .== (1.0 - t).*(1.0 .- l).*w .+ e)
    @NLobjective(mod, Max, sum(g*log(c[i]) + (1 - g)*log(l[i]) for i in 1:NN))
    
    optimize!(mod)
    
    c_opt = value.(c)
    l_opt = value.(l)
    
    return hcat(c_opt, l_opt)
end