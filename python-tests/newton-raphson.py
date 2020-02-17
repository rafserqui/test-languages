# Newton-Raphson Method

import numpy as np 
import matplotlib.pyplot as plt 
import time

def f(x):
    return x**x - 100

def fprime(x):
    return (x**x)*(np.log(x) + 1)

xplot = np.linspace(0, 7.5, 1000)
fig, ax = plt.subplots()
ax.plot(xplot, f(xplot)+100, '--', linewidth=1.2)

def newton(x0, tol=1e-9, maxiter=1e3):
    x = x0
    iter = 1
    error = 1e8
    while (iter < maxiter):
        print('Iter = {:1d} x = {:2.5f} Error = {:2.3e}'.format(iter,x,error))

        # Newton-Raphson Step
        x1 = x - f(x)/fprime(x)

        # Compute error and check convergence
        error = np.abs(x1-x)
        if error < tol:
            print('Solution reached with success!')
            print('The solution is x = {:2.8f}'.format(x1))
            return x1
        # Keep iterating
        x = x1
        iter = iter+1

        # Plot steps animated
        ax.plot(x, f(x)+100, 'ro')
        plt.xlim((0, 7.5))
        if x > 5:
            plt.xlim((0, 7.5))
        elif x > 4 and x < 5:
            plt.xlim((0, 5))
            plt.ylim((-0.5, 2000))
        else:
            plt.xlim((2, 4.1))
            plt.ylim((-0.5, 400))
        plt.draw()
        plt.pause(.5)

x = newton(2.5)
plt.show()
