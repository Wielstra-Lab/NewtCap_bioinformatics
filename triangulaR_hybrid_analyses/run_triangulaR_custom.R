### This script uses triangulaR (see https://github.com/omys-omics/triangulaR), and some customized/additional filtering, to do our analysis and eventually make the plot provided in our manuscript.
### The adjustments were made with the help of triangulaR creator: Benjamin Wiens. See also this paper for more explanation on the tool: triangulaR; an R package for identifying AIMs and building triangle plots using SNP data from hybrid zones; 
### Ben J. Wiens, Jocelyn P. Colella; bioRxiv 2024.03.28.587167; DOI: https://doi.org/10.1101/2024.03.28.587167

### Install and load packages
install.packages("devtools")
devtools::install_github("omys-omics/triangulaR")
install.packages("vcfR")

### Note that you will also need ggplot2 and vcfR

library(triangulaR)
library(ggplot2)
library(vcfR)

### Read data in
data <- read.vcfR("/PATH/TO/hybrids.filtered.vcf")
popmap <- read.table("/PATH/TO/popmap_lisso.txt", header = TRUE, sep = "\t" )

### Pass SNPs through threshold (1 is fixed difference parent populations)
diff <- alleleFreqDiff(vcfR = data, pm = popmap, p1 = "Lvul", p2 = "Lmon", difference = 1 )

### Added/Customized part to filter for 0/1 in F1s
# Find sites where each F1 is heterozygous (change HYBRID to be the pop name for F1s)
diagnostic.het.site <- rowSums(extract.gt(diff[,,popmap[popmap$pop=="F1",]$id])=="0/1", na.rm = T)==sum(popmap$pop=="F1")

# Names of snps where each F1 is heterozygous
het.snps <- names(diagnostic.het.site[diagnostic.het.site])

# Positions of het.snps in vcfR
het.snps.pos <- which(rownames(extract.gt(diff))%in%het.snps)

# Make new vcfR object where all F1s are heterozygous at each site
diff.F1.het <- diff[het.snps.pos,,]

### Calculate hybrid index
hi.het <- hybridIndex(vcfR = diff.F1.het, pm = popmap, p1 = "Lvul", p2 = "Lmon")

### Visualize the results as a triange plot
cols <- c("#c7eae5", "#5ab4ac", "#01665e", "#8c510a", "#d8b365") ## These are colorblind safe and print friendly
triangle.plot(hi.het, cols)
