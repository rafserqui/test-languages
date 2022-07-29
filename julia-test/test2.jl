using Plots


x = range(0, 3π, 1000)
y = sin.(x)

plot(x, y)

