# %% IMPORTS
import numpy as np
import matplotlib.pyplot as plt


# %% BARPLOT
data = [
    [1.215566714, 1.084985836, 1.293562018, 1.623817474],
    [1.288402326, 1.350364964, 2.477941176, 1.135230179]
]

langs = ['C4', 'C5', 'WT', 'HP']

X = np.arange(4)
fig= plt.figure()
ax = fig.add_axes([0,0,1,1])

ax.bar(X + 0, data[0], color = 'tab:blue', width = 0.25)
ax.bar(X + 0.25, data[1], color = 'tab:olive', width = 0.25)
ax.legend(['- R1881', '+ R1881'])

# %%
