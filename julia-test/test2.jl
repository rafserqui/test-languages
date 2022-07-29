using Plots


x = range(0, 3π, 1000)
y = sin.(2 * x .- 1)

plot(x, [y, 3y])

