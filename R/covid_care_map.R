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
#' 
#' @source
#' - \url{https://github.com/covidcaremap/covid19-healthsystemcapacity}
#' - \url{https://raw.githubusercontent.com/covidcaremap/covid19-healthsystemcapacity/master/data/published/us_healthcare_capacity-facility-CovidCareMap.csv}
#'
#' @return a `data.frame`
#'
#' @examples
#' res = us_healthcare_capacity()
#' colnames(res)
#' dplyr::glimpse(res)
#'
#' @family data-import
#' @family healthcare-system
#' 
#' @export
us_healthcare_capacity <- function() {
    fpath = s2p_cached_url('https://raw.githubusercontent.com/covidcaremap/covid19-healthsystemcapacity/master/data/published/us_healthcare_capacity-facility-CovidCareMap.csv')
    data.table::fread(fpath)
}
