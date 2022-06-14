# %%
from tkinter import Y

import numpy as np
import csv

import matplotlib.pyplot as plt

# %%
loc = 'data/new/1304/hp-n.csv'

with open(loc, newline='') as c_file:
    reader = csv.reader(c_file, delimiter=',')
    reader.__next__()

    x, y = [], []
    for row in reader:
        x.append(float(row[0]))
        y.append(float(row[1]))

y_inverse = y

# 1) Find Lowest on Sides
llow, rlow = min(y_inverse[:10]), min(y_inverse[-10:])
avg_low = (llow + rlow) / 2

# 2) Reset Null-Point
y_i_new_null = []
for val in y_inverse:
    if val-avg_low >= 0:    # New null-point
        y_i_new_null.append(val - avg_low)
    else:
        y_i_new_null.append(0)

plt.plot(y_i_new_null)
plt.title(loc)


integral = sum(y_i_new_null)
integral_hz_norm = integral / len(y_i_new_null)
print(f'Integral: {integral}, Integral hz norm: {integral_hz_norm:.3f}')
# %%

# %%
