# Anaconda/Jupyter Set Up Instructions 

It is unlikely that you will need administrative privileges on your machine to follow these instructions but if your machine is managed or updated by someone other than yourself, it is possible that you may need assistance from someone who has administrative privileges on your machine. 

#### System Requirements
-	Hard drive: 5-10 gigabites of free space at minimum 
-	RAM: 8GB or more is recommended

#### If you are already using python, conda, and Jupyter

You can skip these instructions. Just build the conda environment necessary to run the jupyter notebooks in this repo using [learnbydoing.yml](https://github.com/kerriegeil/MSU_py_training/blob/main/conda_env/learnbydoing.yml). 


#### If you are NOT already using python, conda, and Jupyter

Follow all the instructions in this document. Estimated time to complete is 30 minutes, but could be much longer if you encounter problems. Administrative privileges may or may not be needed to install the required software. 

#### Note for Mac Users

**Anywhere you see instructions below to use the Anaconda Prompt, you will use the Mac terminal instead.**

<br>
<br>

## Task 1: Installing Anaconda

Estimated time to complete: 5-10 minutes

Install Anaconda using the instructions provided on the Anaconda documentation pages. Note, you do not have to provide your email on the distribution page, just click the “skip registration” link.

Windows OS machines: [https://docs.anaconda.com/free/anaconda/install/windows/](https://docs.anaconda.com/free/anaconda/install/windows/) 

For other OS machines: [mac](https://docs.anaconda.com/free/anaconda/install/mac-os/), [linux](https://docs.anaconda.com/free/anaconda/install/linux/) 

<br>
<br>

## Task 2: Creating the learnbydoing conda environment

Estimated time to complete: 5-20 minutes

Here, we will create a conda environment called “learnbydoing” and install python packages to it.

1.	Follow this link [learnbydoing.yml](https://github.com/kerriegeil/MSU_py_training/blob/main/conda_env/learnbydoing.yml) and download the yml file by clicking on the download symbol near the top right of the file (next to Raw and copy)
2.	Save the file to your home directory which is usually C:/Users/yourusername
3.	From your computer's start menu, find the Anaconda3 folder and inside that folder open the Anaconda Prompt. Alternatively, type ```Anaconda Prompt``` in your computer's search bar (next to your start menu) and open the app that way. (Mac users, open the Mac terminal since you won't have the Anaconda Prompt)
4.	Type the following at the command line: ```conda env create -f learnbydoing.yml```
5.	Let the installation proceed, which could take anywhere from 2-20 minutes. When the installation is finished you will see a message about activate and deactivate and you’ll once again see the prompt which starts with (base).


#### Troubleshooting if the above does not work
**If you already had Anaconda installed on your machine (i.e. you did not just execute Task 1 for the first time):** 

You may have an older slower version Anaconda. Anaconda incorporated a major speed upgrade at the end of 2023. Update to the latest version of Anaconda. Instructions can be found at the top of this page: [updating conda and Anaconda](https://docs.anaconda.com/free/anaconda/install/update-version/). Then, try Task 2 again. 

**If you are working with a fresh install of Anaconda and are still having problems:** 

Instead of using the yml file to build your conda environment copy this command into your Anaconda Prompt/Mac terminal.

```conda create -n learnbydoing -c conda-forge cartopy dask glob2 jupyter matplotlib nb_conda_kernels netcdf4 numpy pandas rasterio rioxarray xarray```

<br>
<br>

## Task 3: Launching Jupyter Lab

Estimated time to complete: 2 minutes

1.	In Anaconda Prompt type the following command: ```conda activate learnbydoing```
2.	In Anaconda Prompt type the following command: ```jupyter lab```
3.	You should see a browser window open JupyterLab
<br>
<br>

## Task 4: Test your Jupyter/conda set up

Estimated time to complete: 5 minutes

1.	In JupyterLab, use the navigation panel on the left to navigate to a location on your machine where you can create a test jupyter notebook. Either navigate to an existing location or create a new folder on your machine with the navigation panel (the create new folder button is near the top of the screen or you can right click in the navigation panel and choose “New Folder”).
2.	Once you have navigated in JupyterLab to where you want to create your jupyter notebook, on the Launcher tab to the right, click the square in the Notebook section that says “Python [conda env: learnbydoing]”. This will open a new untitled jupyter notebook. 
3.	In the first notebook cell where the cursor is blinking paste the following 3 lines:
```
import xarray as xr
import numpy as np
import numpy.testing as npt
import pandas as pd
import scipy.stats as ss
from scipy.signal import detrend
import rioxarray as rio
import warnings
import os
from urllib.request import urlretrieve
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cf
from cartopy.mpl.gridliner import LongitudeFormatter
```
4. If you've received no errors, then you are ready to successully run the learn by doing jupyter notebooks.