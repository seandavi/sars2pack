context("Data retrieval from web")

library(yaml)
yml = yaml.load_file(system.file(package='sars2pack', path='data_catalog/dataset_details.yaml'))
dsets = yml$datasets

for(dset in names(dsets)) {
    accessor = get(dset)
    res = accessor()
    message(dset)
    cnames = colnames(res)
    test_that(paste0(dset, " column names match"), 
              expect_equal(cnames, names(dsets[[dset]]$columns)))
    ctypes = lapply(res, class)
    test_that(paste0(dset, " column types match"),
              expect_equal(ctypes, dsets[[dset]]$columns))
}
