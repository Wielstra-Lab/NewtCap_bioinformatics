#!/bin/bash

#SBATCH --ntasks=
#SBATCH --cpus-per-task=
#SBATCH --partition=
#SBATCH --mem=
#SBATCH --output=
#SBATCH --error=
#SBATCH --job-name=
#SBATCH --mail-type=
#SBATCH --mail-user=

# In our studies, we usually filter out sites with more than 50% missing data for PCA and RAxML analyses  
# For 50% filtering you have to set the value to 0.5 (and for instance for 100% filtering you would set the value to 1.0, which would mean no missing genotypes/data points would remain at all after filtering)

# Change to directory where the msgVCF is located that contains the samples of interest for a certain phylogenetic analysis
cd /PATH/TO/VARIANTS/

# This code is written as a for loop, in case multiple different msgVCF files are worked up for phylogenetic analyses at once (but obviously the command can be run on it's own for one file separately too)
for file in *SNPs*PassOnly.vcf
do
  /PATH/TO/vcftools --vcf $file --max-missing 0.5 --recode --recode-INFO-all --out ${file%.vcf}_miss05.vcf
done
