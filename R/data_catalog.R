#' list and detail available sars2pack datasets 
#'
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
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
#' 
#'
#' @export
available_datasets <- function() {
    catalog = system.file('data_catalog/catalog.json',package='sars2pack')
    as_tibble(jsonlite::fromJSON(catalog)$datasets)
}

#' @describeIn available_datasets
#' 
#' @details 
#' `dataset_details`: returns a pre-computed set of column names and types,
#'   dimensions of the datasets, and for datasets with a date (time course),
#'   the min and max dates included in the dataset. Each dataset is an item
#'   in the list. See examples for details and for viewing suggestions.
#' 
#' 
#' @examples 
#' dd = dataset_details()
#' str(dd,list.len=3)
#' names(dd$datasets)
#' # evaluated
#' dd$eval_date
#' 
#' 
#' @export
dataset_details = function() {
    dd = system.file('data_catalog/dataset_details.yaml',package='sars2pack')
    yaml::yaml.load_file(dd)
}


#' create data details yaml file for all datasets
#' 
#' This function runs available_datasets() and then
#' loops over the datasets to collect a list that looks like:
#' 
#' ```
#' kff_icu_beds:
#' columns:
#'     fips: character
#' county: character
#' st: character
#' state: character
#' hospitals_in_cost_reports: numeric
#' Hospitals_in_HC: numeric
#' all_icu: numeric
#' Total_pop: numeric
#' 60plus: numeric
#' 60plus_pct: numeric
#' 60plus_per_each_icu_bed: numeric
#' dimensions:
#'     nrow: 3142
#' ncol: 11
#' us_county_geo_details:
#'     columns:
#'     state: character
#' fips: character
#' ansicode: character
#' county: character
#' area_land: numeric
#' area_water: numeric
#' area_land_sqmi: numeric
#' area_water_sqmi: numeric
#' geometry:
#'     - sfc_POINT
#'     - sfc
#' dimensions:
#'     nrow: 3220
#'     ncol: 9
#' ```
#' 
#' @importFrom yaml as.yaml
#' 
#' @keywords internal
create_dataset_details = function(fname='inst/data_catalog/dataset_details.yaml') {
    z = available_datasets()
    res = lapply(unique(z$accessor), function(f) {
        a = get(f)()
        ret = list(columns=lapply(a, class), 
                   dimensions=list(nrow=nrow(a), ncol = ncol(a)))
        if('date' %in% colnames(a)) {
            ret[['dates']]=list(min = as.character(min(a[['date']],na.rm=TRUE)), 
                                max = as.character(max(a[['date']],na.rm=TRUE)))
        }
        ret
    })
    names(res) = unique(z$accessor)
    res = list(datasets=res)
    res[['eval_date']] = as.character(Sys.Date())
    writeLines(yaml::as.yaml(res),fname)
}
