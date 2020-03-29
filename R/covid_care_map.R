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
#' 
#' @source
#' - \url{https://github.com/covidcaremap/covid19-healthsystemcapacity}
#' - \url{https://raw.githubusercontent.com/covidcaremap/covid19-healthsystemcapacity/master/data/published/us_healthcare_capacity-facility-CovidCareMap.csv}
#'
#' @examples
#' us_healthcare_capacity()
#' 
#' @export
us_healthcare_capacity <- function() {
    readr::read_csv('https://raw.githubusercontent.com/covidcaremap/covid19-healthsystemcapacity/master/data/published/us_healthcare_capacity-facility-CovidCareMap.csv')
}
