# %%
import numpy as np
import pylab as pyl

# %% 
# DELTA IMAGE

deltas = np.zeros((2048, 2048))
deltas[8::16, 8::16] = 1
# %%
pyl.imshow(deltas[0:32, 0:32])
pyl.show()

# %%
x, y = np.meshgrid(np.linspace(-2, 2, 15), np.linspace(-2, 2, 15))
dst = np.sqrt(x*x + y*y)
sigma = 1
muu = 0.000
gauss = np.exp(-((dst-muu)**2/(2.0 * sigma**2)))
pyl.imshow(gauss)
pyl.show()
# %%
from scipy.signal import convolve2d as convolve2d_cpu

convolved_image_using_CPU = convolve2d_cpu(deltas, gauss)
pyl.imshow(convolved_image_using_CPU[0:32, 0:32])
pyl.show()
%timeit -n 1 -r 1 convolve2d_cpu(deltas, gauss)
# %%
import cupy as cp

deltas_gpu = cp.asarray(deltas)
gauss_gpu = cp.asarray(gauss)
# %%
