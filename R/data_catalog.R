.catalog_file=system.file('data_catalog/catalog.csv',package='sars2pack')
.dataset_details_file = system.file('data_catalog/dataset_details.yaml',
                                    package='sars2pack')
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
    catalog = .catalog_file
    res = readr::read_csv(catalog,col_types = readr::cols()) %>% 
      dplyr::mutate(data_type=strsplit(.data$data_type,'\\|\\|')) %>%
      dplyr::mutate(region=strsplit(.data$region,'\\|\\|')) %>%
      dplyr::mutate(resolution=strsplit(.data$resolution,'\\|\\|'))
    class(res) = c('s2p_avail_datasets',class(res))
    res
}

# {
#     "name": "The Economist: Excess deaths due to COVID",
#     "accessor": "economist_excess_deaths",
#     "data_type": [
#         "time series",
#         "deaths",
#         "miscellaneous"
#         ],
#     "geographical": true,
#     "geospatial": false,
#     "resolution": [
#         "admin0",
#         "admin1"
#         ],
#     "region": "International",
#     "url": "https://github.com/TheEconomist/covid-19-excess-deaths-tracker"
# },



            

#' @describeIn available_datasets
#' 
#' @details 
#' `dataset_details`: returns a pre-computed set of column names and types,
#'   dimensions of the datasets, and for datasets with a date (time course),
#'   the min and max dates included in the dataset. Each dataset is an item
#'   in the list. See examples for details and for viewing suggestions.
#' 
#' @return a list, with each dataset as an item
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
    dd = .dataset_details_file
    yaml::yaml.load_file(dd)
}

write_dataset_details = function(dd) {
  dd[['eval_date']] = as.character(Sys.Date())
  writeLines(yaml::as.yaml(dd),.dataset_details_file)
}

add_or_update_dataset_details = function(accessor_name,...) {
  res = dataset_details()
  res$datasets[[accessor_name]]=create_dataset_detail_record(accessor_name,...)
  write_dataset_details(res)
}

create_dataset_detail_record = function(accessor_name,...) {
  a = get(accessor_name)(...)
  ret = list(columns=lapply(a, class), 
             dimensions=list(nrow=nrow(a), ncol = ncol(a)))
  if('date' %in% colnames(a)) {
    ret[['dates']]=list(min = as.character(min(a[['date']],na.rm=TRUE)), 
                        max = as.character(max(a[['date']],na.rm=TRUE)))
  }
  ret
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
#' @return No value
#' 
#' @importFrom yaml as.yaml
#' 
#' @keywords internal
create_dataset_details = function() {
    fname = .dataset_details_file
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


flatten_data_frame = function(df) {
    .flatten = function(x) {y = unlist(x); if(length(x)==length(y)) return(y) else return(x)}
    as_tibble(lapply(df, .flatten))
}
