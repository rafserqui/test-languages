import numpy as np

X = np.random.uniform(0, 1, size=(3, 10000))
C = np.matrix([[1., .3, .05],
               [.3, 1., .3],
               [.05, .3, 1.]])

U = np.linalg.cholesky(C)
Y = U*X

print(np.corrcoef(Y[0, :], Y[1, :])[1, 0])
print(np.corrcoef(Y[0, :], Y[2, :])[1, 0])
print(np.corrcoef(Y[1, :], Y[2, :])[1, 0])

