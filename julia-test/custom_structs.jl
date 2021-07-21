mutable struct model_params{tt1 <: Real, tt2 <: Real, tt3 <: AbstractArray{<:Real}, tt4 <: AbstractArray{<:Real}, tt5, tt6 <: AbstractArray{<: Real}, tt7 <: AbstractArray{<: Real}}
    rho  :: tt1
    sigm :: tt1
    bbi  :: tt1
    nu   :: tt1
    oma  :: tt1
    omm  :: tt1
    oms  :: tt1
    gamm :: tt1
    phi  :: tt1
    L    :: tt2
    NN   :: tt2
    betas:: tt3
    alphT:: tt3
    iotT :: tt3
    muT  :: tt3
    T    :: tt4
    delG :: tt4
    G    :: tt5
    Ei   :: tt6
    nui  :: tt6
    Amat :: tt7
end

# Infrastructure struct
mutable struct infrastructure{tt1 <: AbstractArray{<: Real}, tt2 <: AbstractArray{<: Real}}
    In :: tt1
    Vi :: tt2
end

# Algorithm parameters
mutable struct algo_params{tt1 <: Real, tt2 <: Real}
    tol_epsi  :: tt1          # Convergence criterion    
    difference:: tt1          # Initial difference
    maxit     :: tt2          # Max number of iterations
    it        :: tt2          # Iteration counter
    ucoeff    :: tt1          # Updating coefficient
end

# Guesses
mutable struct guess{tt1 <: AbstractArray{<:Real}}
    Li0 :: tt1
    wi0 :: tt1
    bi0 :: tt1
end

# Equilibirum
mutable struct eqbm_output{tt1 <: AbstractArray{<:Real}, tt3 <: AbstractArray{<:Real}}
    Li  :: tt1
    Pi  :: tt1
    Ub  :: tt1
    wi  :: tt1
    bi  :: tt1
    Ai  :: tt3
    Ldn :: tt3
    Pdn :: tt3
end
