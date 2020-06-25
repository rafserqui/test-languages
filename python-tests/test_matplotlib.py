import numpy as np
import matplotlib.pyplot as plt 

x = np.linspace(0, 5*np.pi, 1000)
y = np.sin(x)
g = np.cos(x)

plt.figure()
plt.plot(x,y,'--')
plt.show()

# Parameters for errors
obs = 1000
mu = 4
sigma = 5

# True parameters
a = 20
b1 = 0.55
b2 = -2.8
b3 = 3.75

# Simulation
x = np.random.normal(mu, sigma, obs)
y = a + b1*x + b2*x**2 + b3*x**3 + np.random.uniform(obs)

# Fit polynomial
pfit1 = np.polyfit(x, y, 1)
pfit2 = np.polyfit(x, y, 2)
pfit3 = np.polyfit(x, y, 3)

# Evaluate polynomials
xp = np.linspace(-30, 30, obs)
yhat1 = np.polyval(pfit1, xp)
yhat2 = np.polyval(pfit2, xp)
yhat3 = np.polyval(pfit3, xp)


plt.plot(xp, y, '.', label="Data")
plt.plot(xp, yhat1, '-', label="1st Degree")
plt.plot(xp, yhat2, '-.', label="2nd Degree")
plt.plot(xp, yhat3, '--', label="3rd Degree")
plt.legend(ncol=2, loc='best')
plt.show()
