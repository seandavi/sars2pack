#!/usr/bin/env Rscript
library(sars2pack)
library(openxlsx)
write.xlsx(enriched_jhu_data(),file='covid-19-data.xlsx')
