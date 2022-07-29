# Load packages
using Random
using StatsPlots
using Distributions

# Set the seed
Random.seed!(42)

# Create a distribution
D = Beta(0.2, 0.6);

# Random samples from previous distribution
random_numbers = rand(D, 10000);

# Plot 
histogram(random_numbers;
    fill = (0, 0.2),
    lab = "A 10 Thousand Random Numbers Draw in Julia",
    frame = :box,
    legend = false,
)

