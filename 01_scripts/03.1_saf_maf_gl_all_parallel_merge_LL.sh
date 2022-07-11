#!/bin/bash

# Combine each chromosome's output (.beagle and .mafs) from previous step (03_saf_maf_gl_all_parallel_LL.sh)

# VARIABLES
CHR_LIST="02_info/chr_list.txt"

#prepare variables - avoid to modify
source 01_scripts/01_config.sh
N_IND=$(wc -l 02_info/bam.filelist | cut -d " " -f 1)
MIN_IND_FLOAT=$(echo "($N_IND * $PERCENT_IND)"| bc -l)
MIN_IND=${MIN_IND_FLOAT%.*}
MAX_DEPTH=$(echo "($N_IND * $MAX_DEPTH_FACTOR)" |bc -l)


# BEAGLE
# 1. Extract header for 1st chr : 
## what is the first chromosome ? 
FIRST_CHR=$(less $CHR_LIST | head -n1) ## will be Chr01
## Extract header from beagle for first chr and initialize output file
zless 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_"$FIRST_CHR".beagle.gz | head -n1 > 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_ALL_CHR.beagle

# 2. Append beagle’s contents for all chromosomes
less $CHR_LIST | while read CHR
do
  # extract the right beagle file for a given chr 
	BEAGLE_FILE=$(ls -1 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_*.beagle.gz | grep $CHR) # extract the right beagle file for a given chr 
	# Extract all lines except first one and append to ALL_CHR.beagle
  zless $BEAGLE_FILE  | grep -v ^marker >> 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_ALL_CHR.beagle
done


# MAFS
# 1. Extract header for 1st chr : 
## Extract header from maf for first chr and initialize output file. We have already identified the 1st chromosome in previous step.
less 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_"$FIRST_CHR".mafs | head -n1 > 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_ALL_CHR.mafs

# 2. Append beagle’s contents for all chromosomes
less $CHR_LIST | while read CHR
do
  # extract the right beagle file for a given chr 
	MAFS_FILE=$(ls -1 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_*.mafs | grep $CHR) # extract the right beagle file for a given chr 
	# Extract all lines except first one and append to ALL_CHR.mafs
  less $MAFS_FILE  | grep -v ^chromo >> 03_saf_maf_gl_all/all_maf"$MIN_MAF"pctind"$PERCENT_IND"_maxdepth"$MAX_DEPTH_FACTOR"_no_outliers_ALL_CHR.mafs
done





