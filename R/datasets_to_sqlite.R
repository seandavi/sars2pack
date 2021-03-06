#' Build a data warehouse of all datasets in one line
#'
#' SQL databases are the cornerstone of many data science efforts.
#' We provide this simple function to export all the available
#' datasets in `available_datasets()` to any relational database
#' supported by dbplyr.
#'
#' @details
#'
#'  Create connections using RSQLite::SQLite() for RSQLite, RMariaDB::MariaDB() for
#'  RMariaDB, RPostgres::Postgres() for RPostgres, odbc::odbc() for
#'  odbc, and bigrquery::bigquery() for BigQuery.
#'
#' @param con a remote data source. See [dplyr::copy_to()]
#' @param dataset_accessors character() vector of accessors for datasets.
#'      The `accessor` column of [available_datasets()] is the default, meaning
#'      that all data.frame-like datasets will be written to the SQL destination.
#' @param overwrite If TRUE, will overwrite an existing table with name
#'        name. If FALSE, will throw an error if name already
#'        exists.
#' @param \dots passed on to [dplyr::copy_to()]
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @seealso [dplyr::copy_to()]
#'
#' @family data-export
#' 
#' @examples
#' if(requireNamespace("RSQLite", quietly=TRUE) 
#'    & requireNamespace("DBI", quietly=TRUE)) {
#'   sql = DBI::dbConnect(RSQLite::SQLite(), ':memory:')
#'   datasets_to_sql(sql, dataset_accessors = "coronadatascraper_data")
#'   DBI::dbListTables(sql)
#'   DBI::dbDisconnect(sql)
#' } else {
#'   print("install.packages('RSQLite') to run this example")
#' }
#' 
#' @return used for side effects
#' 
#' @export
datasets_to_sql <- function(con, dataset_accessors = available_datasets()$accessor,
                            overwrite=TRUE, ...) {
    dataset_accessors = unique(dataset_accessors)
    if(length(dataset_accessors) > intersect(dataset_accessors, available_datasets()$accessor)) {
        stop('Dataset accessors must be included in available_datasets()$accessor')
    }
    for(i in dataset_accessors) {
        ds = get(i)()
        message(i)
        ds = try(as.data.frame(get(i)()))
        if(inherits(ds, 'try-error')) next
        ds = ds[, as.vector(which(vapply(ds, is.atomic, logical(1))))]
        if(is.data.frame(ds)) {
            message("writing")
            dplyr::copy_to(con, ds, i, ..., overwrite=TRUE)
        }
    }
}
