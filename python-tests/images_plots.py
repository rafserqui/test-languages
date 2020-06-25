import numpy as np
import matplotlib.pyplot as plt 
from scipy.stats.mstats import gmean


N = 30
NN = N**2

np.random.seed(0)
shocks = np.random.normal(0, .1, size = (NN,3))

x = np.arange(1, N+1, 1)
y = np.arange(1, N+1, 1)

xx, yy = np.meshgrid(x, y, sparse = True)

Aa = (np.sin(xx*(np.pi/150) + yy*(np.pi/150)) + 1)*np.exp(shocks[:, 0].reshape(N,N))
Aa = Aa/np.mean(Aa)
Am = (np.sin(-xx*(np.pi/150) + yy*(np.pi/150)) + 1)*np.exp(shocks[:, 1].reshape(N,N))
Am = Am/np.mean(Am)
As = (np.sin(xx*(np.pi/150) - yy*(np.pi/150)) + 1)*np.exp(shocks[:, 2].reshape(N,N))
As = As/np.mean(As)

fig, (ax1, ax2, ax3) = plt.subplots(figsize=(13, 3), ncols=3)

Aaim = ax1.imshow(Aa)
ax1.set_title('Agriculture')
fig.colorbar(Aaim, ax = ax1)

Amim = ax2.imshow(Am)
ax2.set_title('Manufacturing')
fig.colorbar(Amim, ax = ax2)

Asim = ax3.imshow(As)
ax3.set_title('Services')
fig.colorbar(Asim, ax = ax3)

plt.show()

