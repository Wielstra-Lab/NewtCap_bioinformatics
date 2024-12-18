#!/bin/bash

#SBATCH --ntasks=
#SBATCH --mem=
#SBATCH --partition=
#SBATCH --output=
#SBATCH --error=
#SBATCH --job-name=
#SBATCH --mail-type=
#SBATCH --mail-user=

# Change to directory where files will be placed
cd /PATH/TO/MAPPING

# Load modules
module load SAMtools 

# Run the flagstat command (adjust if you want to run on raw BAMs instead of deduplicated BAMs)
for f in *dedup.bam;
do samtools flagstat "$f" -O tsv > "${f%.dedup.bam}.stat.tsv";
done
