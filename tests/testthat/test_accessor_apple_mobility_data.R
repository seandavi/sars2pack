
library(testthat)
context("Data retrieval from web")

dset="apple_mobility_data"
skip_on_ci()
if(grepl("^google|^apple",dset)) {
    test_data_accessor(dset,nrows=100000)
} else {
    test_data_accessor(dset)
}

