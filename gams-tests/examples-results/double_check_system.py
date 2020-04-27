import scipy.optimize as opt
import numpy as np 

def f(variables):
    (x,y,z) = variables

    eq1 = 2*x*y + y + z - 10
    eq2 = 2*x - y**2 + 3*z 
    eq3 = x + y + z - 3

    return [eq1, eq2, eq3]

solution = opt.fsolve(f, (-0.5,-5,7))
print(solution)
