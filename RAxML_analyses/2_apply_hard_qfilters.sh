#!/bin/bash
# Based on filtering Wielstra et al., 2019 ("Phylogenomics of the adaptive radiation of Triturus newts supports gradual ecological niche expansion towards an incrementally aquatic lifestyle" Molecular Phylogenetics and Evolution paper)
# and the bioinformatics applied for filtering there (based on code by Evan McCartney-Melstad)

#SBATCH --ntasks=
#SBATCH --cpus-per-task=
#SBATCH --partition=
#SBATCH --mem=
#SBATCH --output=
#SBATCH --error=
#SBATCH --job-name=
#SBATCH --mail-type=
#SBATCH --mail-user=

## Change to directory where the msgVCF is located that contains the samples of interest for a certain phylogenetic analysis and that has been filtered for heterozygote excess / deviations fronm HWE
cd /PATH/TO/VARIANTS/


## Separate out SNPs and indels and apply some fairly stringent hard filters Separate out SNPs and indels and apply some fairly stringent hard filters

echo "\n\nSeparating SNPs from INDELs in raw, ms-VCF and applying stringent filtering, pull out variants that PASS"


## Separate SNPs from INDELS:

/PATH/TO/vcftools --vcf MAIN.ExHW.g.vcf --remove-indels --recode --recode-INFO-all --out MAIN.ExHW.g.vcf.SNPs

/PATH/TO/vcftools --vcf MAIN.ExHW.g.vcf --keep-only-indels --recode --recode-INFO-all --out MAIN.ExHW.g.vcf.indels


## Apply filters

/PATH/TO/gatk --java-options '-Xms800m -Xmx110g -DGATK_STACKTRACE_ON_USER_EXCEPTION=true' VariantFiltration -R /PATH/TO/Tdob_reference_7139unique.fasta -V MAIN.ExHW.g.vcf.SNPs.recode.vcf -O MAIN.ExHW.g.vcf.SNPs.recode.qfilt.vcf --filter-expression 'QD < 2.0' --filter-name 'QDfail' --filter-expression 'MQ < 40.0' --filter-name 'MQfail' --filter-expression 'FS > 60.0' --filter-name 'FSfail' --filter-expression 'MQRankSum < -12.5' --filter-name 'MQRankSumFail' --filter-expression 'ReadPosRankSum < -8.0' --filter-name 'ReadPosRankSumFail' --filter-expression 'QUAL < 30' --filter-name 'qualFail'

/PATH/TO/gatk --java-options '-Xms800m -Xmx110g -DGATK_STACKTRACE_ON_USER_EXCEPTION=true' VariantFiltration -R /PATH/TO/Tdob_reference_7139unique.fasta -V MAIN.ExHW.g.vcf.indels.recode.vcf -O MAIN.ExHW.g.vcf.indels.recode.qfilt.vcf --filter-expression 'QD < 2.0' --filter-name 'QDfail' --filter-expression 'SOR > 10.0' --filter-name 'SORfail' --filter-expression 'FS > 60.0' --filter-name 'FSfail' --filter-expression 'ReadPosRankSum < -8.0' --filter-name 'ReadPosRankSumFail' --filter-expression 'QUAL < 30' --filter-name 'qualFail'


## Pull out the passing variants and create the idx file accordingly

grep -P "^#|\tPASS\t" MAIN.ExHW.g.vcf.SNPs.recode.qfilt.vcf > MAIN.ExHW.g.vcf.SNPs.recode.qfilt.PassOnly.vcf
/PATH/TO/gatk IndexFeatureFile -I MAIN.ExHW.g.vcf.SNPs.recode.qfilt.PassOnly.vcf

grep -P "^#|\tPASS\t" MAIN.ExHW.g.vcf.indels.recode.qfilt.vcf > MAIN.ExHW.g.vcf.indels.recode.qfilt.PassOnly.vcf
/PATH/TO/gatk IndexFeatureFile -I MAIN.ExHW.g.vcf.indels.recode.qfilt.PassOnly.vcf

echo "\n\nFinished creating gold standard SNPs and INDELs, separate vcfs + idx files available.\n\n"
