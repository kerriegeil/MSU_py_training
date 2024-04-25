#!/bin/bash

# in an environment where nco is installed and activated
# adjust the data_dir and output_dir below and 
# run this script at the command line: bash concat_AgERA5.sh
# this script takes a few hours to complete

year_start=1979
year_end=2023

nyears=$(($year_end-$year_start+1))

# the source data files are at data_dir/yyyy/*.nc
data_dir="/full/path/to/source/files/AgERA5_daily/orig/"
output_dir="/full/path/where/to/write/output/files/AgERA5_daily/"

var_in=("Precipitation-Flux" "Temperature-Air-2m-Max-24h" "Temperature-Air-2m-Min-24h")
var_out=("prcp" "tmax" "tmin")


# dividing this concat up into stages so that I can double check 
# if anything goes wrong and fix it without waiting too much time

# first concat daily files into annual files for each variable
for ivar in "${!var_in[@]}"; do
    echo "---------- processing ${var_out[ivar]} -----------"
    for y in $(seq $year_start $year_end); do
  
        # one nc file per year of daily data files
        outfile="${data_dir}${var_out[ivar]}_${y}.nc"

        echo $y", concatenating files to "$outfile
        
        # concatenate and write new netcdf
        ls $data_dir$y/*${var_in[ivar]}* | ncrcat -o $outfile
        
        # delete the lengthy history global attritbutes and overwrite netcdf 
        ncatted -O -a,global,d,, $outfile $outfile
    done
done


# fix any files/years that errored for each variable
echo "---------- now processing years that had errors -----------"
err_year_start=2019
err_year_end=2023

for ivar in "${!var_in[@]}"; do
    echo "---------- processing ${var_out[ivar]} -----------"
    for y in $(seq $err_year_start $err_year_end); do
    
        # one nc file per year of daily data files
        outfile="${data_dir}${var_out[ivar]}_${y}.nc"
        
        # some source data files are written differently where
        # time dim was not set as a record dim, which is required for ncrcat
        # make time a record/unlimited dimension in each daily file
        echo "changing time to the record dim in daily files..."
        files=$(ls $data_dir$y/*${var_in[ivar]}*)  # list of all the daily files
        for f in $files; do
            ncks -O --mk_rec_dmn time $f $f
        done

        # now do the same steps as we did for the other years of data
        # concatenate and write new netcdf    
        echo $y", concatenating files to "$outfile
        ls $data_dir$y/*${var_in[ivar]}* | ncrcat -o $outfile
        
        # delete the lengthy history global attritbutes and overwrite netcdf 
        ncatted -O -a,global,d,, $outfile $outfile
    done
done


# last concat annual files to a single netcdf file for each variable
for ivar in "${!var_in[@]}"; do
    echo "---------- processing ${var_out[ivar]} -----------"
    
    # an array of the annual files
    file_array=($(ls $data_dir${var_out[ivar]}_????.nc))
    
    # make sure all the annual files are present, if so, concatenate
    if [ ${#file_array[@]} == $nyears ]
    then 
        # one nc file per year of daily data files
        outfile="${output_dir}${var_out[ivar]}_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc"

        echo "concatenating files to "$outfile
        
        # concatenate and write new netcdf
        ls $data_dir${var_out[ivar]}_????.nc | ncrcat -o $outfile
        
        # delete the lengthy history global attritbutes and overwrite netcdf 
        ncatted -O -a,global,d,, $outfile $outfile
    # if all annual files aren't found, print a message
    else
        echo "expected $nyears data files to combine but only found ${#files[@]}"
    fi
done
