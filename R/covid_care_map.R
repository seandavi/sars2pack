#' United States healthcare system capacity by provider
#'
#' @details
#' From the data providers:
#'
#' Mapping existing and forecasted health system capacity gaps (beds,
#' staffing, ventilators, supplies) to care for surging numbers of
#' COVID19 patients (especially ICU-level care) at high spatiotemporal
#' resolution (by facility, daily, all USA to start).
#' 
#' @importFrom readr read_csv
#' @importFrom dplyr glimpse
#' 
#' @source
#' - \url{https://github.com/covidcaremap/covid19-healthsystemcapacity}
#' - \url{https://raw.githubusercontent.com/covidcaremap/covid19-healthsystemcapacity/master/data/published/us_healthcare_capacity-facility-CovidCareMap.csv}
#'
#' @examples
#' res = us_healthcare_capacity()
#' colnames(res)
#' glimpse(res)
#'
#' @family data-import
#' 
#' @export
us_healthcare_capacity <- function() {
    fpath = s2p_cached_url('https://raw.githubusercontent.com/covidcaremap/covid19-healthsystemcapacity/master/data/published/us_healthcare_capacity-facility-CovidCareMap.csv')
    readr::read_csv(fpath, col_types = cols(), guess_max=5000)
}
