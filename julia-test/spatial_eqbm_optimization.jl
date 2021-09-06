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
const N = 25
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
rugg = ones(N,N)
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

init_eqbm = @time endog_eqbm_dispersion(mparams,infras)