#!/bin/bash

# in an environment where nco is installed and activated
# adjust the data_dir and output_dir below and 
# run this script at the command line: bash concat_AgERA5.sh
# this script takes a few hours to complete

year_start=1979
year_end=2023

nyears=$(($year_end-$year_start+1))

# the source data files are at data_dir/yyyy/*.nc
data_dir="/full/path/to/source/files/.../AgERA5_daily/orig/"
output_dir="/full/path/where/to/write/output/files/.../AgERA5_daily/"

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
        ls $data_dir$y/*${var_in[ivar]}* | ncrcat -h -o $outfile
        
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
            ncks -h -O --mk_rec_dmn time $f $f
        done

        # now do the same steps as we did for the other years of data
        # concatenate and write new netcdf    
        echo $y", concatenating files to "$outfile
        ls $data_dir$y/*${var_in[ivar]}* | ncrcat -h -o $outfile
        
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
        ls $data_dir${var_out[ivar]}_????.nc | ncrcat -h -o $outfile
        
        # delete the lengthy history global attritbutes and overwrite netcdf 
        ncatted -O -a,global,d,, $outfile $outfile
    # if all annual files aren't found, print a message
    else
        echo "expected $nyears data files to combine but only found ${#files[@]}"
    fi
done


# rename data variables
echo "renaming data variable in ${output_dir}prcp_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc"
ncrename -h -O -v Precipitation_Flux,prcp ${output_dir}prcp_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc
echo "renaming data variable in ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc"
ncrename -h -O -v Temperature_Air_2m_Max_24h,tmax ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc
echo "renaming data variable in ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc"
ncrename -h -O -v Temperature_Air_2m_Min_24h,tmin ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc


# convert units
echo "converting tmin K to C..."
echo "tmax..."
ncap2 -h -O -s 'tmax+=-273.15f' ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc
echo "tmin..."
ncap2 -h -O -s 'tmin+=-273.15f' ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc


# compress files
echo "compressing files..."
echo "prcp..."
ncpdq -h -O -7 -L 1 ${output_dir}prcp_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}prcp_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc
echo "tmax..."
ncpdq -h -O -7 -L 1 ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc
echo "tmin..."
ncpdq -h -O -7 -L 1 ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc


# modifying metadata
echo "updating metadata..."
echo "prcp..."
# create a new 'standard_name' attribute, overwrite the nc file, don't save the history
ncatted -h -O -a standard_name,prcp,c,c,precipitation ${output_dir}prcp_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc
echo "tmax..."
# edit the 'units' attribute, overwrite the existing character type attribute, overwrite the nc file, don't save the history
ncatted -h -O -a units,tmax,o,c,degrees_C ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc 
# create a new 'standard_name' attribute, overwrite the nc file, don't save the history
ncatted -h -O -a standard_name,tmax,c,c,2m_max_air_temperature ${output_dir}tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc
echo "tmin..."
# edit the 'units' attribute, overwrite the existing character type attribute, overwrite the nc file, don't save the history
ncatted -h -O -a units,tmin,o,c,degrees_C ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc 
# create a new 'standard_name' attribute, overwrite the nc file, don't save the history
ncatted -h -O -a standard_name,tmin,c,c,2m_min_air_temperature ${output_dir}tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc


# create subset files for Mississippi
echo "subsetting files to Mississippi..."
echo "prcp..."
ncea -h -d lat,30.0,35.3 -d lon,-91.9,-87.9 ${output_dir}test_prcp_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}prcp_AgERA5_Mississippi_Daily_${year_start}-${year_end}.nc
echo "tmax..."
ncea -h -d lat,30.0,35.3 -d lon,-91.9,-87.9 ${output_dir}test_tmax_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}tmax_AgERA5_Mississippi_Daily_${year_start}-${year_end}.nc
echo "tmin..."
ncea -h -d lat,30.0,35.3 -d lon,-91.9,-87.9 ${output_dir}test_tmin_AgERA5_NorthAmerica_Daily_${year_start}-${year_end}.nc ${output_dir}tmin_AgERA5_Mississippi_Daily_${year_start}-${year_end}.nc


# create subset files for Starkville
echo "subsetting files to Starkville..."
echo "prcp..."
ncea -h -d lat,33.5 -d lon,-88.8 ${output_dir}prcp_AgERA5_Mississippi_Daily_${year_start}-${year_end}.nc ${output_dir}prcp_AgERA5_Starkville_Daily_${year_start}-${year_end}.nc
echo "tmax..."
ncea -h -d lat,33.5 -d lon,-88.8 ${output_dir}tmax_AgERA5_Mississippi_Daily_${year_start}-${year_end}.nc ${output_dir}tmax_AgERA5_Starkville_Daily_${year_start}-${year_end}.nc
echo "tmin..."
ncea -h -d lat,33.5 -d lon,-88.8 ${output_dir}tmin_AgERA5_Mississippi_Daily_${year_start}-${year_end}.nc ${output_dir}tmin_AgERA5_Starkville_Daily_${year_start}-${year_end}.nc