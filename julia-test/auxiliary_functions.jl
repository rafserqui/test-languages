#-----------------------------------------------
# Auxiliary functions
#-----------------------------------------------
# Function to quickly multiply vectors of matrices
function fastmultiply(out, L, R)
    for i = 1:length(L)
        @inbounds mul!(out[i], L[i], R[i])
    end
    out = hcat(out...)
    return out
end

function spatial_tfps(N,bett=-2.5)
    #------------------------------------------------
    # Generate spatially correlated noise to simulate 
    # the exogenous part of TFPs. 
    #------------------------------------------------

    # Random phase shift
    phi = rand(N,N,3)

    # Quadrant frequencies
    u = [(0:floor(N/2))' -(ceil(N/2)-1:-1:1)']'/N

    # Reproduce these frequencies
    u = repeat(u, 1, N)

    # v is the set of frequencies along the second dimension
    v = u'

    # Generate prower spectrum
    Sf = (u.^2 + v.^2).^(bett/2.0)

    # Set infinities to 0 (remember to use broadcasting)
    Sf[Sf .== Inf] .= 0

    # Inverse Fourier transform
    Aa = ifft(sqrt.(Sf) .* (cos.(2 .*π.*phi[:,:,1]) .+ im.*sin.(2 .*π.*phi[:,:,1])))
    Am = ifft(sqrt.(Sf) .* (cos.(2 .*π.*phi[:,:,2]) .+ im.*sin.(2 .*π.*phi[:,:,2])))
    As = ifft(sqrt.(Sf) .* (cos.(2 .*π.*phi[:,:,3]) .+ im.*sin.(2 .*π.*phi[:,:,3])))

    # Pick real part and exponentiate
    Aa = exp.(real(Aa))
    Am = exp.(real(Am))
    As = exp.(real(As))

    return [Aa, Am, As] # return as array to be able to mutate
end

function spatial_amenities(N,bett=-2.5)
    #------------------------------------------------
    # Generate spatially correlated noise to simulate 
    # the exogenous part of amenities. 
    #------------------------------------------------

    # Random phase shift
    phi = rand(N,N)

    # Quadrant frequencies
    u = [(0:floor(N/2))' -(ceil(N/2)-1:-1:1)']'/N

    # Reproduce these frequencies
    u = repeat(u, 1, N)

    # v is the set of frequencies along the second dimension
    v = u'

    # Generate prower spectrum
    Sf = (u.^2 + v.^2).^(bett/2.0)

    # Set infinities to 0 (remember to use broadcasting)
    Sf[Sf .== Inf] .= 0

    # Inverse Fourier transform
    nui = ifft(sqrt.(Sf) .* (cos.(2 .*π.*phi[:,:,1]) .+ im.*sin.(2 .*π.*phi[:,:,1])))
    
    # Pick real part and exponentiate
    nui = exp.(real(nui))
    
    return nui 
end

function create_map(w,h,cross_nodes = false)
    #------------------------------------------------
    # Function to create adjacency matrix
    #------------------------------------------------
    N = w*h
    
    # Struct array of nodes
    nodes = []
    delta = zeros(N,N)
    x = zeros(N,1)
    y = zeros(N,1)
    
    for n in 1:N
        neighbors = []
        
        y[n] = Int(floor((n - 1)/w) + 1)
        x[n] = Int(n - w*(y[n] - 1)+0)
        
        if x[n]<w
            neighbors = push!(neighbors,x[n]+1+w*(y[n]-1));
            delta[Int(x[n]+w*(y[n]-1)),Int(x[n]+1+w*(y[n]-1))]=1;
        end
        if x[n]>1
            neighbors = push!(neighbors,x[n]-1+w*(y[n]-1));
            delta[Int(x[n]+w*(y[n]-1)),Int(x[n]-1+w*(y[n]-1))]=1;
        end
        if y[n]<h
            neighbors = push!(neighbors,x[n]+w*(y[n]+1-1));
            delta[Int(x[n]+w*(y[n]-1)),Int(x[n]+w*(y[n]+1-1))]=1;
        end
        if y[n]>1
            neighbors = push!(neighbors,x[n]+w*(y[n]-1-1));
            delta[Int(x[n]+w*(y[n]-1)),Int(x[n]+w*(y[n]-1-1))]=1;
        end
        nodes = push!(nodes,neighbors)
    end
    
    # Construct adjacency matrix
    adjacency = zeros(N,N)
    for n in 1:N
        for m in 1:length(nodes[n][1])
            adjacency[n,Int.(nodes[n][:])] .= 1
        end
    end
    
    return adjacency
end