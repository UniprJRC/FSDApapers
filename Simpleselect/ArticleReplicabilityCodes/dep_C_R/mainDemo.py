# This Python script illustrates an easy way to call
# quickselectFS.c from Python, passing a Numpy array
# as the first argument.
#
# The .c source file should be compiled as follows:
#
# gcc -fPIC -shared -o simpleselect.so simpleselect.c 
#
# The C-compatible data types are built by the
# foreign Python function library ctypes. 

import ctypes
from numpy.ctypeslib import ndpointer
import numpy as np

lib = ctypes.cdll.LoadLibrary("simpleselect.so")
quickselectFS = lib.quickselectFS

quickselectFS.restype = ctypes.c_double
quickselectFS.argtypes = [ndpointer(ctypes.c_double, flags="C_CONTIGUOUS"),
                ctypes.c_int,
                ctypes.c_int]

A = np.arange(-5.0, 6.0, 1, dtype = float)
print(A)
np.random.shuffle(A)

# quickselectFS works in-place, so we have to create a copy of vector A if we want to retain the original A.

aux = A.copy()

k = 7
k_th_ord_stat = quickselectFS(aux, len(aux), k)

print(k_th_ord_stat)

del aux
