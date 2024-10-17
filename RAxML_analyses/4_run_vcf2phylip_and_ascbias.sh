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


# Change to directory where the file is located that contains the samples of interest for a certain phylogenetic analysis and that has been through the HWE deviations filtering, the SNP quality filtering, and the maxmissing filtering steps
cd /PATH/TO/VARIANTS/

# Load required modules (see GitHub respositories highlighted in line 22 and 29 for more information)
numpy
pandas
Biopython

# Run 'vcf2phylip.py' (see; Ortiz, 2019 - https://github.com/edgardomortiz/vcf2phylip)
# This code is written as a for loop, in case multiple different msgVCF files are worked up for phylogenetic analyses at once (but obviously the command can be run on it's own for one file separately too) 
for file in *_miss05.vcf
do
 python3 /PATH/TO/vcf2phylip.py --input $file
done

# Run 'ascbias.py' (see - https://github.com/btmartin721/raxml_ascbias)
# This code is written as a for loop, in case multiple different msgVCF files are worked up for phylogenetic analyses at once (but obviously the command can be run on it's own for one file separately too) 
# Note that the 'min4*.phy' file is the output of the ‘vcf2phylip.py’ script 
for file in *min4*.phy
do
  python3 /PATH/TO/ascbias.py -p $file -o ${file%.phy}.unInv.phy
done
