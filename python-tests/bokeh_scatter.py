import numpy as np
from bokeh.plotting import figure, show 
from bokeh.io import output_notebook

N = 4000                                    # Number of points
x = np.random.random(size = N) * 100        # X random variable
y = np.random.random(size = N) * 100        # Y random variable
radii = np.random.random(size = N) * 1.5    # Random size for scatterplot

colors = ["#%02x%02x%02x" % (r, g, 150) for r, g in zip(np.floor(50+2*x).astype(int), np.floor(30+2*y).astype(int))]

p = figure()
p.circle(x, y, radius = radii, fill_color = colors, fill_alpha = 0.6, line_color = None)
show(p)