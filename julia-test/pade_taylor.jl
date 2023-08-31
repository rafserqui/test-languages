using Plots, LaTeXStrings

function exp_delay(x, s)
    return exp.(-s .* x)    
end

function taylor_expansion(x, s)
    Tx = 1 .- s .* x .+ (s^2 / 2) .* x.^2 .- (s^3 / 6) .* x.^3 .+ (s^4 / factorial(4)) .* x.^4
    return Tx
end

function pade_approximant(x, s)
    a0 = 1
    a1 = s / 2
    a2 = (s^2 / 2) - (3 / 2) * s^2 + (7/12) * s^2
    b1 = (3 / 2) * s
    b2 = (7 / 12) * s^2

    # Numerator and denominator of Padé approximant
    Rnum = a0 .+ a1 .* x .+ a2 .* x.^2
    Rden = 1 .+ b1 .*x .+ b2 .* x.^2

    return Rnum ./ Rden
end

s = 1.5
xg = range(0.0, 2.0, 1000)

plot(xg, exp_delay(xg, s), lw = 1.5, label = "Function")
plot!(xg, taylor_expansion(xg, s), lw = 1.5, ls = :dash, label = "Taylor")
plot!(xg, pade_approximant(xg, s), lw = 1.5, ls = :dot, label = "Padé")
plot!(title = latexstring("Taylor vs Padé Approximations for \$f(x) = e^{-s x}\$"),
    xlabel = L"x", ylabel = L"f(x)", dpi = 600)
savefig("./julia-test/taylor_vs_pade.png")
