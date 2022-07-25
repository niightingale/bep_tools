# :microscope: `fiji_analysis`
This folder carries the Jupyter notebooks with the random forest classifier, the input data obtained from Harmony, and the output data from the classifier.

## 📁 Folder Structure
- `models_X3.ipynb` and other versions
- `screener_v3.ijm` and other versions
- data

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
Determines two measures; (i) the amount of nuclei with a spot (`nuc_w_spot`) and (ii) the amount of late-s nuclei (`nuc_sel`), all separated for each well used in the analysis. The ratio between these two measures is the *spickle ratio*.

## 🖥 `screener_v3.ijm`
This macro is used to do yes-no assays on the foci in the dataframes that are the **saved output** of the `do_analysis()` function of `model_X3.ipynb`. However, its functionality is not limited to this, each stored dataframe that has the correct columns may work.

### ✍️ How to Use
<p align="center"><img width=85% src="https://user-images.githubusercontent.com/65312137/180715223-59752ef3-5180-444a-8c3a-55ba1cfcffd2.png"></p>

> **Figure 1:** Screenshot of the user interface of the macro

For ease of use this macro sports a GUI. This GUI consists of three blocks:
- **Manual Setup:** Requests the (i) dataframe (as `.txt` or `.csv`) that we want to review, where the corresponding (ii) images are stored and (iii) where the analysis output should be stored. Note that the folders should be specified with a forward slash at the end.
- **Quick Setup:** Allows for the input of a *linker* file, which is essentially a `.txt` file with 3 lines, with each of the previously specified paths on one line.
- **Analysis Mode:** We may choose to go through the foci from beginning to end (linear) or take a representative random sample (random). The *samples* slider only works when the random mode is selected. The *stack depth* is used in maximum projection assays; if it is put to a value any other than 0, the macro will try and fetch the whole z-stack corresponding to the spot.

When the analysis is started, the user will be given an image and prompted to say whether the ROI in the image has a spot in its center or not. 

After answering, the image will be stored to the *output* directory and the answer will be kept in a list to later be stored as a `.txt` file in which each line describes whether there was a spot or not. This `.txt` file will use three numbers, **0** for no spot, **1** for spot and **3** for unannotated entries in a random assay. It works like this to allow for the `.txt` file to be pasted back unto the used *dataframe* without hassle.

#### 🛑 Known Problems
- **Maximum Projection Assays [feature not final]:** 
  - The maximum projections are generated in **real-time**. This makes usage of the macro very slow as the images are fetched linearly and then processed.
  - If the maximum projections are calculated in advance and linked through the *Images* path, set *Stack Depth* to 0. 
  - This feature may break under unknown conditions.
- **Output Problems:**
  - The macro is made to output all the used image cutouts with an annotated title, however sometimes the saving system misses. The accompanying `.txt` file which denotes the postives, negatives and non-useds is always complete.
  

## 💽 Data
For each session of imaging, the (i) Harmony data used together with (ii) the classifier output data is stored in one folder. 

These folders have a distinct naming convention of: `date of imaging` + assay + `identifier for type of assay`. They have two subfolders:
- **Input Data:** Here the direct Harmony output is stored. Most often this are two files, respectively called (i) `Objects_Population - coloc AR.txt` and (ii) `PlateResults.txt`. The former holds the *identifying properties* and the *object properties* of each of the AR spickles that Harmony found, while the latter holds the *well properties*.

  Beside these two files, there are also usually files with the prefix `sneaky`. These files are used by the `screener` ImageJ macro. And are **never** accessed through the code. 
- **Output Data:** When the random forest classifier is run it creates different dataframes. These are all stored inside this folder and are named following this convention: `date of imaging` + `plate row` + `plate column` + `full/view` + ... 

  Also manual accuracy controls of the model's predictions are stored here. These follow the naming convention `plate row` + `plate column` + `f` + `number of samples taken`. These files are **not** generated by the model, but rather by the `screener` ImageJ macro.
