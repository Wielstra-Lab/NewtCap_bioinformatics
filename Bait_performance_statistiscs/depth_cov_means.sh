#!/bin/bash

#creates a new file and adds header to the new columns 1, 2 and 3
#adds the names of each file in column 1 as it loops through the files
#calculates and writes the mean of the mean depths per loci (column 7 of output file from SAMtools coverage function) to column 2 of the new file 
#and adds the SD information to column 3 of the new file. The same is done for the percent coverage data.

touch coverage_samtools_meanofmeandepths.txt

echo -e "Sample\tMeandepth\tSD_md" > coverage_samtools_meanofmeandepths.txt 

for file in *_dedup.coverage.txt; do awk -F '\t' 'NR > 1 {sum+=$7; sumsq+=$7*$7} END {print FILENAME "\t" sum / (NR -1) "\t" sqrt(sumsq/NR - (sum/NR)**2)}' $file >> coverage_samtools_meanofmeandepths.txt; done

touch coverage_samtools_meanofmeancovs.txt

echo -e "Sample\tMeancov\tSD_mc" > coverage_samtools_meanofmeancovs.txt

for file in *_dedup.coverage.txt; do awk -F '\t' 'NR > 1 {sum+=$6; sumsq+=$6*$6} END {print FILENAME "\t" sum / (NR -1) "\t" sqrt(sumsq/NR - (sum/NR)**2)}' $file >> coverage_samtools_meanofmeancovs.txt; done

paste coverage_samtools_meanofmeandepths.txt coverage_samtools_meanofmeancovs.txt | column -s $'\t' -t > coverage_samtools_cov_depth_means.txt
