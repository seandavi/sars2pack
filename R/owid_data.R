#' Our world in data worldwide cases and tests
#'
#' The OurWoldInData dataset includes country-level testing,
#' deaths, and confirmed cases for most countries in the world.
#'
#' @importFrom readr read_csv cols
#' @importFrom dplyr %>% mutate
#' @importFrom lubridate ymd
#' @importFrom tidyr pivot_longer
#' 
#' @source 
#' 
#' - \url{https://ourworldindata.org/coronavirus}
#' 
#' @references 
#' 
#' Max Roser, Hannah Ritchie, Esteban Ortiz-Ospina and Joe Hasell (2020) - 
#' "Coronavirus Pandemic (COVID-19)". Published online at OurWorldInData.org. 
#' Retrieved from: 'https://ourworldindata.org/coronavirus' [Online Resource]
#' 
#' 
#' @family case-tracking
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @examples 
#' res = owid_data()
#' colnames(res)
#' 
#' head(res)
#' 
#' dplyr::glimpse(res)
#'   
#' @export
owid_data = function() {
    url = 'https://covid.ourworldindata.org/data/owid-covid-data.csv'
    rpath = s2p_cached_url(url)
    dat = readr::read_csv(rpath, col_types = readr::cols())
    dat %>% dplyr::select(iso_code, location, date, total_cases, 
                          total_deaths, total_tests, tests_units) %>%
        dplyr::rename(
            iso3c = 'iso_code',
            country = 'location',
            confirmed = 'total_cases',
            deaths = 'total_deaths',
            tests = 'total_tests'
        )
}