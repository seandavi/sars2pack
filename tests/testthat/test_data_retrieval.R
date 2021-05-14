context("Data retrieval from web")

library(yaml)
yml = yaml.load_file(system.file(package='sars2pack', path='data_catalog/dataset_details.yaml'))
dsets = yml$datasets

for(dset in names(dsets)) {
  test_data_accessor(dset)
}
