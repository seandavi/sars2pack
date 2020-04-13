#' Country, region, and province level COVID-19 time series for Europe
#'
#' covid19-eu-data is a dataset repository for COVID-19/SARS-CoV-2
#' cases in Europe. They pull data from official government websites
#' regularly using the open-source scripts inside the repository.
#'
#' @importFrom lubridate as_date
#' @importFrom readr read_csv
#'
#' 
#' @note Some oddities of the dataset are captured on the original
#'     site at
#'     \url{https://github.com/covid19-eu-zh/covid19-eu-data#notes}
#' 
#' @source
#' - \url{https://covid19-eu-data-cache.now.sh/}
#' - \url{https://github.com/covid19-eu-zh/covid19-eu-data}
#'
#' @export
eu_data_cache_data <- function(datasets = eu_data_cache_datasets(include_ecdc = FALSE)) {
    .local = function(abbrev) {
        fpath = s2p_cached_url(sprintf('https://covid19-eu-data-cache.now.sh/covid-19-%s.csv', abbrev))

        ret = suppressWarnings(readr::read_csv(fpath, col_types = cols(), guess_max=20000))
        ret$date = lubridate::as_date(ret$datetime)
        ret$cases = suppressWarnings(as.numeric(ret$cases))
        ## these are either unused or not well-sourced, so remove
        .cols_to_remove = c('cases_lower', 'cases_upper', 'cases/100k pop.', 'percent', 'population')
        ## lau is Large Urban Unit
        ret = ret[,setdiff(colnames(ret),.cols_to_remove)]
        ret
    }
    do.call(bind_rows, lapply(datasets,
                              .local))
}

#' @importFrom stringr str_extract_all str_replace
#'
#' @describeIn eu_data_cache_data
#' 
#' @export
eu_data_cache_datasets <- function(include_ecdc=TRUE) {
    #z1 = yaml::read_yaml(url('https://raw.githubusercontent.com/covid19-eu-zh/covid19-eu-data/master/.dataherb/metadata.yml'))
    
    z = httr::content(httr::GET('https://covid19-eu-data-cache.now.sh/'),
                      type='text',encoding='UTF-8')
    z = unique(stringr::str_extract_all(z, 'covid-19-.{1,4}\\.csv')[[1]]) %>%
        str_replace('.*covid-19-','') %>% str_replace('\\.csv','')
    names(z) = z
    if(!include_ecdc) {
        z = z[names(z) != 'ecdc']
    }
    z
}
