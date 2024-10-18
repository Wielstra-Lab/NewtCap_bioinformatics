#!/bin/bash

#SBATCH --ntasks=
#SBATCH --cpus-per-task=
#SBATCH --time=
#SBATCH --partition=
#SBATCH --mem=
#SBATCH --output=
#SBATCH --error=
#SBATCH --job-name=
#SBATCH --mail-type=
#SBATCH --mail-user=


## Change to directory where the file is located that contains the samples of interest and that has been through all aforementioned filtering steps (this should, as this stage, be a PHYLIP file without invariant sites) 
cd /PATH/TO/VARIANTS/

## Load module 
module load RAxML

## This code is written as a for loop, in case multiple different msgVCF files are worked up for phylogenetic analyses at once (but obviously the command can be run on it's own for one file separately too) 
## Also, the command uses a number of threads as specified by the number of cpus that would be given in the SBATCH line on top (line 4)

for file in *unInv.phy
do
  raxmlHPC -T $SLURM_CPUS_PER_TASK -f a -x 609516 -p 609516 -N 100 -m ASC_GTRGAMMA --asc-corr=lewis -O -n ${file%.phy}.tre -s "$file" -w "/PATH/TO/VARIANTS"
done
