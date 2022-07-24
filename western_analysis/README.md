# 📐 `western_analysis`
This folder carries the `integral_assay.ipynb` Jupyter notebook. This notebook is used to calculate the area intensity integral of Western blot bands.

## 📁 Folder Structure
- `integral_assay.ipynb`
- data; this folder holds the data used in the analyses. Note that the exact details of the files are discussed under the next section.

## 📏 `integral_assay.ipynb`
This notebook has one functionality; compare two blot bands.

### ✍️ How to Use
#### Input
To do a comparative analysis between two bands, they need to adhere to a certain naming and storage conventions:
- (Not required) Usually each blot should have all its files for band comparisons together in one folder. In the repo these folders sit under `bep_tools>western_analysis>data>new`.
- To compare two bands, they both need to be cut out from the Western blot image using an ROI (ImageJ) of equal size. Ideally, the whole assay is done using an ROI of the same dimensions. Images are cut out using the `obtainer.ijm.ijm` macro, which stores the band as a .csv file.
- Two bands that are to be compared should be stored with the following naming convention: `name` + `+` for one `name` + `-` for the other. If there are accompanying normalization bands, these carry the same name with an added `n` at the end.

Given that we have stored our data as described above, we may do an analysis which compares two bands. To do this, we use the `enrichment_analysis()` function.

#### `enrichment_analysis()` function
The use of this function is straightforward. Its parameters are:
- `rel_path`: The path to the blot folder excluding final slash (as described in the previous subsection).
- `suffix` : The `name` as given above.
- `title` : Cosmetic identifier for plots, usually same as `suffix` but not necessarily.
- `threshold = 0.75` : Threshold for method 0 (simple threshold), ignored at 1 (Otsu).
- `method = 0' : Method of thresholding to find background, 0 is simple percentage intensity thresholding, 1 is Otsu thresholding, which often works better.
- `processing = False` : Unfinished functionalities. Setting `True` could cause unexpected behaviour.

#### Output
The function has no return values, however it outputs quite a lot of info for the user:
- **Plot Properties:** Information is granted about the min and max intensities, the area integrals, etc.

  The most important metrics to verify a good quality blot here are; (i) adequate distance between the foreground and background averages, (ii) foreground average not close to clipping at maximum dynamic range.
  
  The difference in integral area intensity is given as the `Enrichment of <name>` and is the last metric given.
- **Step Images:** A series of images is given, three per band. The first image is a raw convesion of the .csv file, the second one is the threshold determined by the algorithm and the third image is the raw image normalized against the threshold data. This is used to verify whether the notebook works as expected.
