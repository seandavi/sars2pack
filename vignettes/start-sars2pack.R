# This script loads the dependencies to run sars2pack into a clean R environment
# Install the BiocManger package
install.packages("BiocManager")
# Use it - Bioconductor version 3.10 (BiocManager 1.30.10), ?BiocManager::install for help
library(BiocManager)
# Use the sars2pack - loads packages: R0, MASS, sf - Links to GEOS 3.7.2, GDAL 2.4.2, PROJ 5.2.0
library(sars2pack)