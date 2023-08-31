using Plots

function cheb_nodes(n)
    x_k = zeros(n, 1)
    for k = 1:n 
        x_k[k] = cos(((2k - 1)/2n)π)
    end
    return x_k
end

function cheb_polys(n, x)
    if n == 0
        T = x./x;
    elseif n == 1
        T = x;
    else
        T = 2 .* x .* cheb_polys(n-1,x) .- cheb_polys(n-2, x);
    end
    return T;
end

function monomials(n, x)
    return x.^n;
end

function plot_function(basis_function, x, n)
    for r = 1:n-1
        f_data = basis_function(r, x)

        if r == 1 
            plot(x, f_data, xlabel = "x", label = "$r")
        else
            plot!(x, f_data, label = "$r")
        end
    end
    f_data = basis_function(n, x)
    plot!(x, f_data, label = "$n")
end

xg = -1:0.01:1;
plot_function(cheb_polys, xg, 5)
plot_function(monomials, xg, 5)
