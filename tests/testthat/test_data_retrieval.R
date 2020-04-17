context("Data retrieval from web")

library(yaml)
dsets = yaml.load_file('../dataset_details.yaml')
dsets = Filter(f = is.list, dsets)

for(dset in names(dsets)) {
    accessor = get(dset)
    res = accessor()
    message(dset)
    test_that(dset, expect_equal(colnames(res), names(dsets[[dset]]$columns)))
}