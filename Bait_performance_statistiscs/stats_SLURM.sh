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
cd /PATH/TO/VARIANTS

# Load modules
module load BCFtools 

# Run the stats command (adjust if needed)
for f in *.raw.g.vcf.gz;
do bcftools stats "$f";
done
