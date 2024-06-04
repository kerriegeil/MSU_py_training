# Author: K Geil
# Date: March 2024
# Description: Climate Data Store Parallel Download of AgERA5 

# To run this script: 
# 1) if it's your first time using the Climate Data Store, self register at the CDS registration page 
# (https://cds.climate.copernicus.eu/user/register?destination=%2F%23!%2Fhome) 
# 2) if it's your first time using the cdsapi for downloading, create a file called .cdsapirc containing the 
# cdsapi url and your key to your home directory. instructions for installing the CDS API key are at
# (https://cds.climate.copernicus.eu/api-how-to#install-the-cds-api-key)
# 3) create a conda environment with the cdsapi and dask packages installed if you don't already have this, 
# 4) activate your conda environment
# 5) navigate to the directory where you've saved this script
# 6) update the out_dir below to where you want the files to download
# 7) at the command line: python get_AgERA5_daily.py


import cdsapi
import os
import dask
import time
import glob
import subprocess
import sys 

start_time=time.time()

# user-specific variables
out_dir='/full/path/where/to/write/downloads/AgERA5_daily/orig/'

# info for the API call
year_first = 1979
year_last = 2023
dataset_varnames=['2m_temperature','2m_temperature','precipitation_flux']
var_statistic=['24_hour_minimum','24_hour_maximum',None]
outfile_varnames=['tmin','tmax','prcp']
latN,lonW,latS,lonE=71.7, -170.2, 13.4,-59.6  # North America

# create out_dir if it doesn't already exist
if not os.path.exists(out_dir):
    os.makedirs(out_dir)

#######################################################
########## DOWNLOAD ###################################    
#######################################################

# function to grab 1 year of data 
def get_CDS_data(year,var_in,var_out,stat):

    c = cdsapi.Client() # connect to Climate Data Store 

    api_dict={'variable': var_in,
        'year': str(year),
        'month': ['01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12'],
        'day': ['01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
            '13', '14', '15',
            '16', '17', '18',
            '19', '20', '21',
            '22', '23', '24',
            '25', '26', '27',
            '28', '29', '30',
            '31'],
        'area': [latN,lonW,latS,lonE],
        'version': '1_1',
        'format': 'tgz',
        'statistic': stat}

    # there is no 'statistic' for precip so delete it
    if var_out=='prcp':
        del api_dict['statistic']

    # api call
    c.retrieve(
    'sis-agrometeorological-indicators',
    api_dict,
    out_dir+ var_out+'_AgERA5_'+str(year)+'.tar.gz')

# build your list of delayed compute tasks
tasklist=[]
for ivar,var in enumerate(outfile_varnames):
    for yyyy in range(year_first,year_last+1):
        tasklist.append(dask.delayed(get_CDS_data)(str(yyyy),dataset_varnames[ivar],var,var_statistic[ivar]))    

# execute tasks (downloads)    
dask.compute(*tasklist)
task_time=(time.time()-start_time)/60.
print('----------',task_time,'minutes ----------')


#######################################################
########## UNPACK #####################################    
#######################################################

# unzip/untar into directories by year
print('unpacking zipped tar files...')
os.chdir(out_dir)
for year in range (year_first,year_last+1):
    print(year)
    
    # create the dir if it doesn't exist
    if not os.path.exists(out_dir+str(year)):
        os.makedirs(out_dir+str(year))

    for var in outfile_varnames:
        # get the file name
        try:
            filename=glob.glob(out_dir+ var+'_AgERA5_'+str(year)+'.tar.gz')[0]
        except:
            sys.exit(str(year)+' problem finding file '+filename)
            
        # bash command to untar into the yearly directories  
        subprocess.run(['tar', 'xf', filename, '-C', str(year)],check=True, text=True)

#######################################################
########## CLEAN UP ###################################    
#######################################################        

# remove the tar files since we don't need them any more
for var in outfile_varnames:
    for year in range (year_first,year_last+1):
        f=glob.glob(out_dir+var+'_AgERA5_'+str(year)+'.tar.gz')[0]
        subprocess.run(['rm', f],check=True, text=True)
