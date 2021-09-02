
library(testthat)
context("Data retrieval from web")

dset="world_population_data"
if(grepl("^google|^apple",dset)) {
    test_data_accessor(dset,nrows=100000)
} else {
    test_data_accessor(dset)
}

