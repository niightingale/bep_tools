# :microscope: `fiji_analysis`
This folder carries the Jupyter notebooks with the random forest classifier, the input data obtained from Harmony, and the output data from the classifier.

## 📁 Folder Structure
- `models_X3.ipynb` and other versions
- `screener_v3.ijm` and other versions
- [data](https://github.com/niightingale/bep_tools/tree/main/fiji_analysis#-data)

## 🎛 `model_X3.ipynb`
This Jupyter notebook holds all the functionality required to use a model to predict which spickles are *true* based on five of their properties:
 - Spot Contrast
 - Spot Area [px²]
 - Relative Spot Intensity
 - Corrected Spot Intensity
 - Spot to Region Intensity

Although the code can easily be adjusted to use other properties (as the dataset used permits) when using another model.

### 💡 Use Case
The designed use of this notebook is as follows:
1. The user provides a **(i) set of spot objects** with values for its properties and the **(ii) model** to use to predict what subset of these spots are true positives.
2. The model will obtain a subset of the input set that it believes are true positives. 
3. These will be post-processed and given to the user as a `.csv`-file.

Note that along this process the script will output multiple `.csv`-files.

### ✍️ How to Use
#### Input
To do an *analysis* on a spot dataset, we use the `do_analysis()` function. Most of its parameters are straightforward (and explained in the docstrings), however some require more explanation:
- **Cuts:** This parameters expects a list of tuples, where each tuple describes the row and column of a well. These are the wells on which the analysis will be carried out.
- **Thresholds:** Here the thresholds must be specified as a list with three values. The first threshold is the maximum distance in space a spot may have between its datapoints, the second threshold is that maximum distance in time and the third refers to the minimum amount of datapoints that a spot is required to have to consider it a true spot.

#### Saved Output
This function will output four `.csv`-files for each well specified under the `cuts` parameter. These are all stored from [Pandas](https://pandas.pydata.org/) dataframes:
- date_row_column_*full*: Just the well specified in row_column separated from the rest of the dataset.
- date_row_column_*view*_modelidentifier: The previous file but run through the model that is named as 'modelidentifier'. Row `predicted_clc` is added to store whether the model predicted the datapoint as a true spot or not.
- date_row_column_*view_anno*_modelidentifier: The previous file but with the spots traced through time, space and nuclei. Rows `cluster_id`, `cluster_size` and `nucleus_id` are added. Cluster refers to the set of spots found in different images which are one and the same spot, the `nucleus_id` is a unique identifier of a nucleus through time and space (z-stack).
- date_row_column_*view_anno_th*_modelidentifier: The previous file but with the third threshold applied. This means that all unique clusters under a certain `cluster_size` are removed from the previous set to create this one.

#### Function Return
The `do_analysis()` function has two returns (i) `cut_results` and (ii) `nuc_vals`. These are both Pandas dataframes.

##### `cut_results`
Determines four measures; (i) nuclei with colocalization, (ii) nuclei total, (iii) nuclei total late-s and (iv) nuclei ratio (ratio between (i) and (iii), all determined for each timepoint.

This can be used to determine the distribution of nuclei with spots across time.

##### `nuc_vals`
Determines two measures; (i) the amount of nuclei with a spot (`nuc_w_spot`) and (ii) the amount of late-s nuclei (`nuc_sel`), all separated for each well used in the analysis.

### 💽 Data
For each session of imaging, the (i) Harmony data used together with (ii) the classifier output data is stored in one folder. 

These folders have a distinct naming convention of: `date of imaging` + assay + `identifier for type of assay`. They have two subfolders:
- **Input Data:** Here the direct Harmony output is stored. Most often this are two files, respectively called (i) `Objects_Population - coloc AR.txt` and (ii) `PlateResults.txt`. The former holds the *identifying properties* and the *object properties* of each of the AR spickles that Harmony found, while the latter holds the *well properties*.

  Beside these two files, there are also usually files with the prefix `sneaky`. These files are used by the `screener` ImageJ macro. And are **never** accessed through the code. 
- **Output Data:** When the random forest classifier is run it creates different dataframes. These are all stored inside this folder and are named following this convention: `date of imaging` + `plate row` + `plate column` + `full/view` + ... 

  Also manual accuracy controls of the model's predictions are stored here. These follow the naming convention `plate row` + `plate column` + `f` + `number of samples taken`. These files are **not** generated by the model, but rather by the `screener` ImageJ macro.
