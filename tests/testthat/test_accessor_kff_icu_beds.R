
library(testthat)
context("Data retrieval from web")

dset="kff_icu_beds"
if(grepl("^google|^apple",dset)) {
    test_data_accessor(dset,nrows=100000)
} else {
    test_data_accessor(dset)
}

