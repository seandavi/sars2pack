#' YouGov personal behavior survey tracker
#' 
#' These data represent a large collection of survey
#' materials from multiple countries. 
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @family data-import
#' @family behavior
#' 
#' @examples 
#' 
#' res = yougov_behavioral_data()
#' 
#' head(res)
#' dplyr::glimpse(res)
#' 
#' @export
yougov_behavioral_data = function() {
  url = 'https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/yougov/YouGov-Imperial%20COVID-19%20Behavior%20Tracker.csv'
  rpath = s2p_cached_url(url)
  dat = readr::read_csv(rpath, col_types = readr::cols()) %>%
    dplyr::mutate(Date=as.Date('2020-01-01')+Date) %>%
    dplyr::rename(Entity=country) %>%
    dplyr::rename(Date=date)
  dat
}


