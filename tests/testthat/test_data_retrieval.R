context("Data retrieval from web")

library(yaml)
yml = yaml.load_file(system.file(package='sars2pack', path='data_catalog/dataset_details.yaml'))
dsets = yml$datasets

for(dset in sort(names(dsets))) {
    if(grepl('^google|^apple',dset)) {
        test_data_accessor(dset,nrows=100000)
    } else {
        test_data_accessor(dset)
    }
}
