#!/bin/bash
#Written by M.C. de Visser

#This script will make sure the R1 and R2 FASTQ files obtained after BBduk + Trimming are actually sorted/in sync again.
#This is necessary because otherwise BWA will not recognize read pairs that belong to each other, and hence mapping will fail
#This failure does not always occur, but sometimes it does, so if applicable this script can be run (included in master pipeline, better safe than sorry!)
#Make sure this script is adjusted appropriately, and located somewhere where you can find it through the master pipeline script

### BBmap requires unzipped files to work with, so we gunzip everything

cd TRIMMOMATIC/
for file in *_P_*.gz; do gunzip $file; done

### This oneliner can be used to automatically detect the R1 and R2 files that belong to each other and will run the repair.sh script accordingly (make sure this script is in the righ place in your Linux environment). The oneliner was discovered online.

for file in `ls -1 *R1_P*.fastq | sed 's/_150_R1_P_trimmomatic.fastq//'` ; do ~/bbmap/repair.sh in1=$file\_150_R1_P_trimmomatic.fastq in2=$file\_150_R2_P_trimmomatic.fastq out1=$file\_150_R1_P_trimmomatic-fixed.fastq out2=$file\_150_R2_P_trimmomatic-fixed.fastq; done

### For the rest of the master pipeline we continue using zipped files again, so gzip

for file in *fixed*.fastq; do gzip $file; done

### And lastly, as we now have some intermediate/old gunzipped files remaining that just take up storage, we remove those (always make sure you don't remove something relevant, though!)

for file in *.fastq; do rm $file; done
cd ../
