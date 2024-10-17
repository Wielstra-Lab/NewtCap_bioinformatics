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

# Change to directory where the msgVCF is located that contains the samples of interest for a certain phylogenetic analysis
cd /PATH/TO/VARIANTS/

# Load modules
module load BCFtools

# This will filter the raw g.vcf file and exclude/include sites with heterozygote excess and or exclude/include sites with heterozygote deficit (depending on parameters used)
# for instance; 'view -e ExcHet>0.05' will keep only the significantly deviant sites, whereas 'view -e ExcHet<0.05' will keep only the good quality sites and filter out the deviant sites

bcftools +fill-tags MAIN.g.vcf -Ou -- -t all | bcftools view -e'ExcHet<0.05' > MAIN.ExHW.g.vcf 
