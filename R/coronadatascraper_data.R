#' Time series cases, hospitalizations, and testing from Corona Data Scraper project
#'
#' Corona Data Scraper pulls COVID-19 Coronavirus case data from
#' verified sources, finds the corresponding GeoJSON features, and
#' adds population data. All sources are cited right in the same row
#' as the data. Covers testing, hospitalization, deaths, cases, icu.
#' Includes population and geospatial coordinates. 
#'
#' @references
#' \url{https://coronadatascraper.com/#home}
#'
#' @source
#' \url{https://coronadatascraper.com/timeseries.csv}
#'
#' @author
#' Sean Davis <seandavi@gmail.com>
#'
#' @family data-import
#' @family case-tracking
#' 
#' @examples
#' res = coronadatascraper_data()
#' colnames(res)
#' head(res)
#' dplyr::glimpse(res)
#' 
#' length(unique(res$names))
#' length(unique(res$county))
#' length(unique(res$state))
#' length(unique(res$country))
#'
#' @export
coronadatascraper_data <- function() {
    url = 'https://coronadatascraper.com/timeseries.csv'
    rpath = s2p_cached_url(url)
    res = readr::read_csv(rpath, col_types = readr::cols(), guess_max = 500000)
    res
}
