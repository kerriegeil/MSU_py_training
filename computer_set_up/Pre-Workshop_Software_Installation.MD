# PLEASE ATTEMPT THIS SOFTWARE INSTALLATION PRIOR TO THE WORKSHOP DATES (administrative privileges on your machine may be necessary)

## Preparation for “Python: Getting Started” and “Python: Learn by Doing” workshops

#### System Requirements
-	Hard drive: a few gigabites of free space at minimum 
-	RAM: 8GB or more is recommended
-	Internet access: an internet connection is needed to build or modify conda environments

#### Other Equipment Considerations
-	When joining the workshop, it will be ideal to either have multiple monitors or one very large monitor where you can have the web meeting open alongside other applications like a jupyter notebook. You will be following along with the instructor executing code in your own jupyter notebook. It would be very difficult to keep up without enough space to have both applications open and visible at the same time.

#### Software Used During the Workshop
-	Anaconda 
-	JupyterLab through Anaconda

#### For participants who are already using python, conda, and Jupyter

Most of the workshop instructors will use Windows machines with Anaconda to install python packages and launch JupyterLab. If you are already using conda, python, and jupyter notebooks but accessing them through a different workflow (e.g. using an IDE like VS Code and command line conda with git bash) or are on a different operating system that is ok but note that there will be small differences in the appearance and outputs of the workshop materials. If you are experienced with these tools, these differences shouldn’t cause any problems. ***Before the workshop, please create the pyworkshop conda environment using [env.yml](https://github.com/kerriegeil/MSU_py_training/blob/main/conda_env/env.yml) and proceed to Task 4, steps 3 through 7 to verify that everything is working.*** Estimated time to complete is 5-20 minutes, depending on your conda version.

#### For participants who are NOT already using python, conda, and Jupyter

Or for participants who want a nearly identical set up to the instructors, ***before the workshop please follow all the instructions in this document.*** Estimated time to complete these instructions is 30 minutes. Administrative privileges may or may not be needed to install the required software. Please ask for assistance from local IT staff if any problems are encountered with these instructions on your machine. MSU will provide limited support for problems only on day 1 of the “Getting Started” workshop (6 May 2024), but of course we will not be able to remedy any issues arising from the need for administrative privileges or lack of hard drive space on individual machines. Please plan accordingly.

<br>
<br>

## Task 1: Installing Anaconda

Estimated time to complete: 5-10 minutes

Install Anaconda using the instructions provided on the Anaconda documentation pages. Note, you do not have to provide your email on the distribution page, just click the “skip registration” link.

Windows OS machines: [https://docs.anaconda.com/free/anaconda/install/windows/](https://docs.anaconda.com/free/anaconda/install/windows/) 

For other OS machines: [mac](https://docs.anaconda.com/free/anaconda/install/mac-os/), [linux](https://docs.anaconda.com/free/anaconda/install/linux/) 

<br>
<br>

## Task 2: Creating the pyworkshop conda environment

Estimated time to complete: 5-20 minutes

Here, we will create a conda environment called “pyworkshop” and install python packages to it.

1.	Follow this link [env.yml](https://github.com/kerriegeil/MSU_py_training/blob/main/conda_env/env.yml) and download the yml file by clicking on the download symbol near the top right of the file (next to Raw and copy)
2.	Save the file to C:/Users/yourusername
3.	From your start menu, go to Anaconda3 and open the Anaconda Prompt
4.	Type the following at the command line: ```conda env create -f env.yml```
5.	Let the installation proceed, which could take anywhere from 2-20 minutes. When the installation is finished you will see a message about activate and deactivate and you’ll once again see the prompt which starts with (base).

Alternate instructions if the above does not work:
1.	From the start menu open Anaconda Navigator click “Environments” from the navigation pane on the left
2.	Near the bottom of the screen, click the “Create” button
3.	In the “Create new environment” pop up window type “pyworkshop” (without the quotes) in the “Name” box. 
4.	On this same pop up window make sure the check box next to Python is checked (should be checked by default). Whatever version of python is pre-populated in the drop down should be fine.
5.	On this same pop up window click the “Create” button and wait for conda to finish creating your new environment. You’ll see a green play button next to the pyworkshop environment when Anaconda has finished creating and activating it.
6.	Now we’ll select a series of packages to install to the pyworkshop environment. Make sure the dropdown menu displays “All”. In the “Search Packages” bar type: numpy, then in the list of packages that appears find the one called numpy and click the check box in the “Name” column next to the package name.
7.	Repeat step 6 fourteen more times with the following package names: dask, gdal, geopandas, glob2, jupyter, matplotlib, nb_conda_kernels, netcdf4, numpy, pandas, rasterio, rioxarray, seaborn, xarray
8.	Click the “Apply” button at the bottom right
9.	When the “Install Packages” pop up window appears, click the “Apply” button on the pop up window and wait for the packages to finish installing. You’ll see the green play button next to the pyworkshop environment name when the installation is complete. 
<br>
<br>

## Task 3: Launching Jupyter Lab

Estimated time to complete: 2 minutes

1.	In Anaconda Prompt type the following command: ```conda activate pyworkshop```
2.	In Anaconda Prompt type the following command: ```jupyter lab```
3.	You should see a browser window open JupyterLab

Alternate instructions if the above does not work:
1.	In Anaconda Navigator, select the “Home” tab from the navigation pane on the left
2.	Make sure the dropdown menus display “All applications” and “pyworkshop”
3.	Scroll until you see JupyterLab and click the button that says “Launch”. If the button says “Install” instead of “Launch” click “Install” and wait for it to install then click “Launch”
<br>
<br>

## Task 4: Test your Jupyter/conda set up

Estimated time to complete: 5 minutes

1.	In JupyterLab, use the navigation pane on the left to navigate to a location on your machine where you can create a test jupyter notebook. Either navigate to an existing location or create a new folder on your machine with the navigation pane (the create new folder button is near the top of the screen or you can right click in the navigation pane and choose “New Folder”).
2.	Once you have navigated in JupyterLab to where you want to create your jupyter notebook, on the Launcher tab to the right, click the square in the Notebook section that says “Python [conda env: pyworkshop]”. This will open a new untitled jupyter notebook. 
3.	In the first notebook cell where the cursor is blinking paste the following 3 lines:
```
import numpy as np
import pandas as pd
import xarray as xr
```
4.	Hold down Shift and press Enter to run the cell. Alternatively, you can press the play button at the top of the notebook or select “Run Selected Cells” from the Run dropdown menu.
5.	In the second cell that pops up type the following line and run the cell as in step 4 above: ```from osgeo import gdal```
6.	If step 5 throws an error replace the text in the cell with the following and run the cell again: ```import gdal```
7.	If you get errors you can’t resolve, write down the specific error and the task+step in these instructions where the error appeared. Bring that information to day 1 (6 May 2024) of the "Python: Getting Started" workshop.