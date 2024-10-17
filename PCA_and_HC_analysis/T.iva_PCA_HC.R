### Script originally written by Dr. Peter Scott (UCLA)
### Script adjusted/expanded by Manon de Visser

## This script uses R packages such as 'gdsfmt' and 'SNPRelate' to perform population genetic analyses.

install.packages("ggplot2")
devtools::install_github("tidyverse/ggplot2")
install.packages("lifecycle")
install.packages("gdsfmt")

library(gdsfmt)
library(SNPRelate)
library(ggplot2)
library(RColorBrewer)
library(cowplot)

### Indicate where the VCF file is located to perform PCA and HC analyses on
vcf <- "/PATH/TO/T.iva_filtered.vcf"

### Create a GDS file (PG for us stands for 'Population Genetics'), check it by outputting summary, and create a variable
snpgdsVCF2GDS(vcf, "/PATH/TO/PG.gds", method="biallelic.only")
snpgdsSummary("/PATH/TO/PG.gds")
PG_gds <- snpgdsOpen("/PATH/TO/PG.gds")


########################################
##### PRINCIPAL COMPONENT ANALYSIS #####
########################################

### Perform the PCA and calculate eigenvector values
pca <- snpgdsPCA(PG_gds, autosome.only = FALSE)
pca
pc.percent <- pca$varprop*100
(round(pc.percent, 2))
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1], # the first eigenvector
                  EV2 = pca$eigenvect[,2], # the second eigenvector
                  stringsAsFactors = FALSE)
head(tab)
PG_names<-read.csv("/PATH/TO/PG_names.txt", sep="\t")
head(PG_names)

### Plot a PCA with no colors
plot(tab$EV2, tab$EV1, xlab="eigenvector 2", ylab="eigenvector 1")

### Now go on creating the info to make more and nicer plots
PG_names<-read.csv("/PATH/TO/PG_names.txt", sep="\t")
head(PG_names)
pop=PG_names$pop.code

tab12 <- data.frame(sample.id = PG_names$sample.id,
                    Populations = PG_names$pop.code,
                    EV1 = pca$eigenvect[,1], # the first eigenvector
                    EV2 = pca$eigenvect[,2], # the second eigenvector
                    key = pop)

tab13 <- data.frame(sample.id = PG_names$sample.id,
                    Populations = PG_names$pop.code,
                    EV1 = pca$eigenvect[,1], # the first eigenvector
                    EV3 = pca$eigenvect[,3], # the second eigenvector
                    stringsAsFactors = FALSE)

tab23 <- data.frame(sample.id = PG_names$sample.id,
                    Populations = PG_names$pop.code,
                    EV2 = pca$eigenvect[,2], # the first eigenvector
                    EV3 = pca$eigenvect[,3], # the second eigenvector
                    stringsAsFactors = FALSE)

#pop.colors8<-c("lightpink1", "hotpink", "firebrick1", "firebrick4", "cyan2", "darkblue", "lightgreen", "forestgreen")
# EIGHT COLORS BELOW ARE THE COLORBLIND SAFE OKABE-ITO PALETTE COLORS, this can be extended to nine with gray:  "#999999"  
pop.colors<-c("#56B4E9", "#E69F00", "#000000", "#009E73", "#F0E442",  "#0072B2",  "#D55E00", "#CC79A7")

### Note that, when making the plots, we manually add the % variation explained by a PC axis - as should come out of the analyses above - here:
gplot12 <- ggplot(tab12, aes(EV1,EV2,color=Populations)) + geom_point(size=3) +
  scale_color_manual(values=pop.colors) +
  xlab("PC1 (15.31%)") +
  ylab("PC2 (9.95%)") +
  theme_bw() 

gplot13 <- ggplot(tab13, aes(EV1,EV3,color=Populations)) + geom_point(size=3) +
  scale_color_manual(values=pop.colors) +
  xlab("PC1 (15.31%)") +
  ylab("PC3 (7.59%)") +
  theme_bw() 

gplot23 <- ggplot(tab23, aes(EV2,EV3,color=Populations)) + geom_point(size=3) +
  scale_color_manual(values=pop.colors) +
  xlab("PC2 (9.95%)") +
  ylab("PC3 (7.59%)") +
  theme_bw() 

gplot12
gplot13
gplot23


############################################
##### HIERARCHICAL CLUSTERING ANALYSIS #####
############################################

### Make a simple tree / dendogram for the Hierarchical Clustering
set.seed(100)

### Create the dissimilarity matrix
dissim <- snpgdsHCluster(snpgdsIBS(PG_gds,num.thread=2,autosome.onl=FALSE))

### Make the tree / dendogram
cut_tree <- snpgdsCutTree(dissim)
cut_tree
dendogram = cut_tree$dendrogram
dendogram
snpgdsDrawTree(cut_tree,clust.count=NULL,dend.idx=NULL,
               type=c("dendrogram", "z-score"), yaxis.height=TRUE, yaxis.kinship=TRUE,
               y.kinship.baseline=NaN, y.label.kinship=FALSE, outlier.n=NULL,
               shadow.col=c(rgb(0.5, 0.5, 0.5, 0.25), rgb(0.5, 0.5, 0.5, 0.05)),
               outlier.col=rgb(1, 0.50, 0.50, 0.5), leaflab="perpendicular",
               labels=NULL, y.label=0.2)
plot(cut_tree$dendogram,horiz=F,main="Dendogram HC SNP Tree")
