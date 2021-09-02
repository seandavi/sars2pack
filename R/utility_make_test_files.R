rcode = '
library(testthat)
context("Data retrieval from web")

dset="%s"
if(grepl("^google|^apple",dset)) {
    test_data_accessor(dset,nrows=100000)
} else {
    test_data_accessor(dset)
}
'

#' Utility function to autogenerate test files
#' 
#' @keywords internal
make_test_files = function() {
    testdir = 'tests/testthat/'
    sapply(dir(testdir,pattern='^test_accessor',full.names=TRUE),
           unlink)
    library(yaml)
    yml = yaml::yaml.load_file(system.file(
        package='sars2pack', path='data_catalog/dataset_details.yaml'))
    dsets = yml$datasets
    
    for(dset in sort(names(dsets))) {
        writeLines(sprintf(rcode,dset),
                   con=sprintf('tests/testthat/test_accessor_%s.R',dset))
    }
}