import numpy as np
import matplotlib.pyplot as plt 

x = np.linspace(0, 5*np.pi, 1000)
y = np.sin(x)
g = np.cos(x)

plt.figure()
plt.plot(x,y,'--')
plt.show()
