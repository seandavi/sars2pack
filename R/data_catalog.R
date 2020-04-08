#' list and detail available sars2pack datasets 
#'
#' @importFrom yaml yaml.load_file
#' @importFrom dplyr bind_rows
#'
#' @return
#' A data.frame in which each row represents an available dataset.
#'
#' - name: the short name of the dataset
#' - accessor: accessor function
#'
#' @examples
#' res = available_datasets()
#' res
#' # and how to use the accessor programmatically
#' get(res[1,]$accessor)()
#' 
#'
#' @export
available_datasets <- function() {
    catalog = system.file('data_catalog/catalog.yaml',package='sars2pack')
    do.call(dplyr::bind_rows, lapply(yaml::yaml.load_file(catalog)$datasets,as.data.frame))
}
