#' Our world in data worldwide cases and tests
#'
#' The OurWoldInData dataset includes country-level testing,
#' deaths, and confirmed cases for most countries in the world.
#'
#' @importFrom dplyr %>% mutate
#' 
#' @source 
#' 
#' - \url{https://ourworldindata.org/coronavirus}
#' 
#' @references 
#' 
#' Max Roser, Hannah Ritchie, Esteban Ortiz-Ospina and Joe Hasell (2020) - 
#' "Coronavirus Pandemic (COVID-19)". Published online at OurWorldInData.org. 
#' Retrieved from: 'https://ourworldindata.org/coronavirus'
#' 
#' 
#' @family case-tracking
#' @family data-import
#' 
#' @return a data.frame
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
    dat = data.table::fread(rpath)
    not_to_keep=grep('smoothed',names(dat), value=TRUE)
    dat[,c(not_to_keep):=NULL]
    data.table::setnames(
        dat,
        c('iso_code','location','total_cases','total_deaths','total_tests'),
        c('iso3c','country','confirmed','deaths','tests')
    )
    dat
}
