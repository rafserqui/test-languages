import numpy as np

def perrin(n):
    """
    Perrin numbers are defined by the recurrence relation:
    P(n) = P(n-2) + P(n-3) for n > 2
    with initial values
    P(0) = 3
    P(1) = 0
    P(2) = 2
    """
    if n == 0:
        return 3
    elif n == 1:
        return 0
    elif n == 2:
        return 2
    else:
        return perrin(n-2) + perrin(n-3)

N = 20
print('Printing first {N} {seqname} numbers'.format(N = N, seqname = 'Perrin'))
for m in range(N):
    print(perrin(m))