
library(testthat)
context("Data retrieval from web")

dset="us_hospital_details"
if(grepl("^google|^apple",dset)) {
    test_data_accessor(dset,nrows=100000)
} else {
    test_data_accessor(dset)
}

