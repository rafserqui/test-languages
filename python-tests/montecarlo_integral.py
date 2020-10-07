import matplotlib.pyplot as plt
import numpy as np 
from scipy import random 

a = 0.0
b = np.pi
N = 5000

areas = []

for k in range(500):
    afx = 0.0
    x = random.uniform(a, b, N)

    for r in range(N):
       afx += np.sin(x[r])
    areas.append(((b-a)/float(N))*afx)

plt.hist(areas, bins = 30, ec = 'black')
plt.title("Monte Carlo Integration")
plt.show()

