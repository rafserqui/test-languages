using Random, LinearAlgebra, Statistics, FFTW, Plots, FastMarching, LightGraphs, SimpleWeightedGraphs

# User-defined inputs
cd("/home/rafserqui/Documents/Research/test-languages/julia-test/")
include("auxiliary_functions.jl")
include("custom_structs.jl")
include("model_objects.jl")
include("eqbm_functions.jl")

# Set global random stream
Random.seed!(1234)

# Geography
const N = 8
const NN = N^2

# Spatial TFPs
Aam, Amm, Asm = spatial_tfps(N,-2.6)

pa = heatmap(Aam)
pm = heatmap(Amm)
ps = heatmap(Asm)

pplot = plot!(pa,pm,ps,layout =(1, 3), size = (1300, 300))

# Reshape TFPs
Aa = reshape(Aam,NN,1)
Am = reshape(Amm,NN,1)
As = reshape(Asm,NN,1)

cAmat = hcat(Aa, Am, As)
size(cAmat)

# Fundamental parameters
# Elasticities of substitution
crho  = 1.0      # Across sectors
csigm = 5.0      # Across varieties
cbbi  = -0.3     # Amenities parameter
cnu   = 0.97     # 1 - nu = exp in electricity

# Utility weights
coma = 0.177
comm = 0.325
coms = 1 - coma - comm

# From Perez-Sebastian, Steinbuks, Feres, and Trotter (2019)    Table 5
ba = 0.509
bm = 0.335
bs = 0.644

cbetas = [ba, bm, bs]

# Spillovers
calphT = [0.11, 0.09, 0.05]
ciotT = [0.11, 0.09, 0.05]
cmuT = [0.01, 0.05, 0.05]

# Elasticity of transport costs to infrastructure
cgamm = 0.84

# Elasticity of quality of electricity to investment
cphi = 0.28

# Randomness on ruggedness of terrain
rugg = randn(N,N)
rugg = exp.(rugg) ./ exp.(1.0 .+ exp.(rugg))
rugg = N.*ones(size(rugg))./rugg
rugg = 10.0 ./ rugg

# Distance through terrain
delT = zeros(NN,NN)
index = CartesianIndices(ones(N,N))
rows = map(i -> i[1], index)
cols = map(i -> i[2], index)
rows = rows[:]
cols = cols[:]
for z in 1:NN
    strt = [float(rows[z]); float(cols[z])] # The starting point has to be a column vector
    temp = FastMarching.msfm(rugg, strt, true, true) # Use second derivatives and cross derivatives
    delT[z,:] = reshape(temp,1,NN) .* 10.0
end

delT[diagind(delT)] .= 1.0
delT = delT.^(1/4)

# Make sure it is symmetric
delT = (delT + delT') ./ 2.0
delT[delT .< 1.0] .= 1.0

# Parameters for the quality of electricity
cdelG = reshape(rugg.^(1/3),NN,1);

A = create_map(N,N)
index = findall(x -> x == 1, A)
rows = map(i -> i[1], index)
cols = map(i -> i[2], index)
rows = rows[:]
cols = cols[:]
edges = [rows cols];

adj = SimpleGraph(NN)

for (r, c) in zip(edges[:,1],edges[:,2])
    add_edge!(adj, Int(r), Int(c))
end
# Budget
Z = 2.5*ne(adj)

# Allocate investment equally
I0 = (Z/(2.001*ne(adj)))*A
index = findall(x -> x == 0, I0)
I0[index] .= 1e-2
I0 = I0.*A
I0 = (I0 + I0') / 2.0;

# Transport cost
cT, cTnet = transport_cost(delT,I0,cgamm,N);
heatmap!(pplot, reshape(cT[1,:],N,N))

# Electricity inputs
shares = ones(NN,1) .* (1/NN)
gwh = 100.0
cEi = (gwh.*shares).*ones(NN,1)

cL = 100; # Total population

# Generate amenities
cnui = reshape(spatial_amenities(N),NN,1);

# Initialize parameters
const mparams = model_params(crho,csigm,cbbi,cnu,coma,comm,coms,cgamm,cphi,cL,NN,cbetas,calphT,ciotT,cmuT,cT,cdelG,cTnet,cEi,cnui,cAmat);

Vi0 = Z/(2.001*NN).*ones(NN,1);
infras = infrastructure(I0,Vi0);

using DelimitedFiles

writedlm("sim_tfps.csv", cAmat, ',')
writedlm("sim_nuis.csv", cnui, ',')
writedlm("sim_tcst.csv", cT, ',')

teq = endog_eqbm_dispersion(mparams,infras)
const Gi = electricity_quality(mparams.delG,infras.Vi,mparams.phi)
Ai, Ri = tfp_spill(mparams.Amat,teq.Li,Gi,infras.In,mparams.G,mparams.alphT,mparams.iotT,mparams.muT,mparams.gamm)
#-------------------------------------
# SMM
#-------------------------------------
emp_moms = zeros(14,1)

# Thresholds for moments
thresh = zeros(5,3)
thresh[1,:] = [0.25.*mean(teq.Li./sum(teq.Li)) mean(teq.Li./sum(teq.Li)) 0.85.*maximum(teq.Li./sum(teq.Li))];
thresh[2,:] = [0.25.*maximum(Gi) 0.5.*maximum(Gi) 0.85*maximum(Gi)];
thresh[3,:] = [0.25.*maximum(Ri) 0.5.*maximum(Ri) 0.85*maximum(Ri)];
thresh[4,:] = [0.0 0.35 0.0];
thresh[5,:] = [0.0 0.25 0.0];

# Labor
emp_moms[1] =
        sum(teq.Li./cL .< thresh[1,1]) ./ NN;
emp_moms[2] =
        sum((teq.Li./cL .>= thresh[1,1]) .* (teq.Li./cL .< thresh[1,2])) ./ NN;
emp_moms[3] =
        sum((teq.Li./cL .>= thresh[1,2]) .* (teq.Li./cL .< thresh[1,3])) ./ NN;
emp_moms[4] =
        sum(teq.Li./cL .>= thresh[1,3]) ./ NN;

# Quality of Electricity
emp_moms[5] = sum(Gi .< thresh[2,1]) ./ NN;
emp_moms[6] = sum((Gi .>= thresh[2,1]) .* (Gi .< thresh[2,2])) ./ NN;
emp_moms[7] = sum((Gi .>= thresh[2,2]) .* (Gi .< thresh[2,3])) ./ NN;
emp_moms[8] = sum(Gi .>= thresh[2,3]) ./ NN;

# Quality of Roads
emp_moms[9] = sum(Ri .< thresh[3,1]) ./ NN;
emp_moms[10] = (sum((Ri .>= thresh[3,1]) .* (Ri .< thresh[3,2]))) ./ NN;
emp_moms[11] = (sum((Ri .>= thresh[3,2]) .* (Ri .< thresh[3,3]))) ./ NN;
emp_moms[12] = sum(Ri .>= thresh[3,3]) ./ NN;

# Employment Shares
emp_moms[13] = sum(teq.Ldn[:,1] .>= thresh[4,2]) ./ NN;
emp_moms[14] = sum(teq.Ldn[:,2] .>= thresh[5,2]) ./ NN;

# Initial guess for parameters
priors = zeros(9,1);
priors[1] = 0.13;
priors[2] = 0.08;
priors[3] = 0.02;

priors[4] = 0.13;
priors[5] = 0.08;
priors[6] = 0.02;

priors[7] = 0.05;
priors[8] = 0.01;
priors[9] = 0.01;

function functionEqbm(x, Aas::Array{Float64, 1}, Ams::Array{Float64, 1}, Ass::Array{Float64, 1})
    # Parameters to simulate eqbm with random TFPs
    alp_est = x[1:3]
    iot_est = x[4:6]
    mu_est  = x[7:9]

    # Construct parameter struct
    mestp = model_params(crho,csigm,cbbi,cnu,coma,comm,coms,cgamm,cphi,cL,NN,
                        cbetas,alp_est,iot_est,mu_est,cT,cdelG,cTnet,cEi,cnui,
                        hcat(Aas, Ams, Ass));

    # Solve the model
    seq = endog_eqbm_dispersion(mestp,infras);   
    
    # Compute model objects
    Gisim = electricity_quality(mestp.delG,infras.Vi,mestp.phi);

    Ai, Risim = tfp_spill(mestp.Amat,seq.Li,Gi,infras.In,mestp.G,mestp.alphT,mestp.iotT,mestp.muT,mestp.gamm);

    #--------------------------------------------
    # Moments
    #--------------------------------------------
    output = zeros(14,1);

    # Labor
    output[1] =
            sum(seq.Li./cL .< thresh[1,1]) ./ NN;
    output[2] =
            sum((seq.Li./cL .>= thresh[1,1]) .* (seq.Li./cL .< thresh[1,2])) ./ NN;
    output[3] =
            sum((seq.Li./cL .>= thresh[1,2]) .* (seq.Li./cL .< thresh[1,3])) ./ NN;
    output[4] =
            sum(seq.Li./cL .>= thresh[1,3]) ./ NN;
    
    # Quality of Electricity
    output[5] = sum(Gisim .< thresh[2,1]) ./ NN;
    output[6] = sum((Gisim .>= thresh[2,1]) .* (Gisim .< thresh[2,2])) ./ NN;
    output[7] = sum((Gisim .>= thresh[2,2]) .* (Gisim .< thresh[2,3])) ./ NN;
    output[8] = sum(Gisim .>= thresh[2,3]) ./ NN;
    
    # Quality of Roads
    output[9] = sum(Risim .< thresh[3,1]) ./ NN;
    output[10] = sum((Risim .>= thresh[3,1]) .* (Risim .< thresh[3,2])) ./ NN;
    output[11] = sum((Risim .>= thresh[3,2]) .* (Risim .< thresh[3,3])) ./ NN;
    output[12] = sum(Risim .>= thresh[3,3]) ./ NN;
    
    # Employment Shares
    output[13] = sum(seq.Ldn[:,1] .>= thresh[4,2]) ./ NN;
    output[14] = sum(seq.Ldn[:,2] .>= thresh[5,2]) ./ NN;

    return output
end

# Draw shocks for TFPs
S = 5
Aas = zeros(NN,S);
Ams = zeros(NN,S);
Ass = zeros(NN,S);
for s=1:S
    Aasim, Amsim, Assim = spatial_tfps(N,-2.6);
    Aas[:,s] = reshape(Aasim,NN,1);
    Ams[:,s] = reshape(Assim,NN,1);
    Ass[:,s] = reshape(Amsim,NN,1);
end