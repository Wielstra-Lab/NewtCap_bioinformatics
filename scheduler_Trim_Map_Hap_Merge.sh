#!/bin/bash

#SBATCH --ntasks=
#SBATCH --time=
#SBATCH --cpus-per-task=
#SBATCH --partition=
#SBATCH --output=
#SBATCH --mem=
#SBATCH --error=
#SBATCH --job-name=
#SBATCH --mail-type=
#SBATCH --mail-user=

### This is an example script to run the master pipeline script remotely in the SLURM system. Fill in/adjust the settings above, and the path names below as desired.

cd /PATH/TO/ANALYSIS_FOLDER/

### If you workd with modules (as we do), load the software modules required (first, make sure they are available on your system of course):

module load BWA
module load VCFtools
module load SAMtools
module load picard
module load Trimmomatic
module load Perl
module load GATK

perl /PATH/TO/Trim_Map_Hap_Merge.pl
