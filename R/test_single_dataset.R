#' Check a dataset to see if it matches the expected output
#' 
#' @keywords internal
#' 
#' @param accessor character(1) the accessor function name of the dataset to check. 
#' @param ... passed to accessor directly
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @examples 
#' 
#' test_data_accessor("nytimes_state_data")
#' 
test_data_accessor = function(accessor,...) {
    dset = accessor
    yml = yaml.load_file(system.file(package='sars2pack', path='data_catalog/dataset_details.yaml'))
    dsets = yml$datasets
    
    #if(dset=='apple_mobility_data') next ## skip for now
    accessor = get(accessor)
    invisible(capture_output(res <- accessor(...)))
    # skip non-data-frame-like objects for now
    if(inherits(res,'data.frame')) {
        context(sprintf("%s columns and datatypes",dset))
        cnames = colnames(res)
        test_that(paste0(dset, " column names match"),
                  expect_equal(cnames, names(dsets[[dset]]$columns)))
        ctypes = lapply(res, class)
        test_that(paste0(dset, " column types match"),
                  expect_equal(ctypes, dsets[[dset]]$columns))
    }
}
