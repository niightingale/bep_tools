# %%
import matplotlib.pyplot as plt
import numpy as np

# %%
labels = ['C4', 'C5', 'WT', 'HP', 'H']

r1881_pos = [0.78, 0.74, 1.5, 0.66, 0.03]
r1881_neg = [0.72, 0.47, 0.65, 0.52, 0.02]

x = np.arange(len(labels))
width = 0.35

fig, ax = plt.subplots()
rect1 = ax.bar(x - width/2, r1881_neg, width, label = 'R1881-', fill = False, hatch = '..')
rect2 = ax.bar(x + width/2, r1881_pos, width, label = 'R8881+', fill = False, hatch = '...')

ax.set_ylabel('Integral')
ax.set_title('Enrichment after R1881 incubation (cutoff = 0.75, hard = False)')
ax.set_xticks(x, labels)
ax.legend()

ax.bar_label(rect1, padding = 3)
ax.bar_label(rect2, padding = 3)

fig.tight_layout()
plt.ylim([0, 1.7])

plt.show()
# %%
