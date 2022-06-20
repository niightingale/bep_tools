# %%
import matplotlib.pyplot as plt
import numpy as np
# %%
labels = ['C4', 'C5', 'WT', 'HP', 'H']

r1881_pos = [0.78, 0.74, 1.5, 0.66, 0.03]
r1881_neg = [0.72, 0.47, 0.65, 0.52, 0.02]

gain = ['{0:.2f}'.format(p/n) for p,n in zip(r1881_pos, r1881_neg)]
labels = [label + ' | ' + str(g) + 'x' for label, g in zip(labels, gain)]

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
labels = ['C4', 'WT', 'HP', 'H']

r1881_pos = [1.93, 1.95, 1.22, 0.21]
r1881_neg = [0.81, 0.29, 0.86, 0.14]

gain = ['{0:.2f}'.format(p/n) for p,n in zip(r1881_pos, r1881_neg)]
labels = [label + ' | ' + str(g) + 'x' for label, g in zip(labels, gain)]

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
plt.ylim([0, 2.25])

plt.show()
# %%
c4_enrich = np.array([1.11, 2.38, 1.49])
wt_enrich = np.array([2.26, 6.72, 2.36])
hp_enrich = np.array([1.34, 1.42])
h_enrich = np.array([1.18, 1.59])

std_c4_e, avg_c4_e = np.std(c4_enrich), np.mean(c4_enrich)
std_wt_e, avg_wt_e = np.std(wt_enrich), np.mean(wt_enrich)
std_hp_e, avg_hp_e = np.std(hp_enrich), np.mean(hp_enrich)
std_h_e, avg_h_e = np.std(h_enrich), np.mean(h_enrich)
# %%
fig = plt.figure()
fig.set_size_inches([2,2])
fig.set_dpi(200)
ax = fig.add_axes([0,0,1,1])
fields = ['C4', 'WT', 'HP', 'H']

means = [avg_c4_e, avg_wt_e, avg_hp_e, avg_h_e]
errors = [std_c4_e, std_wt_e, std_hp_e, std_h_e]
ax.bar(fields, means, yerr = errors, width = 0.8, capsize = 5, fill = False, hatch = '///')
ax.set_title('Relative Enrichment of PCNA after o/n incubation with R1881 (n=3)*')
ax.set_ylabel('Enrichment')
ax.yaxis.grid(True, alpha = 0.35)
plt.show()

 # %%
means = [1.05, 4.65]
titles = ['C4', 'WT']

fig = plt.figure()
fig.set_size_inches([2,2])
fig.set_dpi(200)

ax = fig.add_axes([0,0,1,1])

ax.bar(titles, means, fill = False, hatch = 'oo')
ax.set_title('Relative Enrichment of AR after o/n incubation with R1881 (n=1)**', loc = 'center', wrap = True)
ax.set_ylabel('Enrichment')
ax.yaxis.grid(True, alpha = 0.35)
plt.show()
# %%
