#' list and detail available sars2pack datasets 
#'
#' @importFrom yaml yaml.load_file
#' @importFrom dplyr bind_rows
#'
#' @return
#' A data.frame with columns:
#'
#' - name: the short name of the dataset
#' - accessor: accessor function
#'
#' @examples
#' available_datasets()
#'
#' @export
available_datasets <- function() {
    catalog = system.file('data_catalog/catalog.yaml',package='sars2pack')
    do.call(dplyr::bind_rows, yaml::yaml.load_file(catalog))
}
