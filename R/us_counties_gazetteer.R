#' United States county-level geographic details
#'
#'
#' @importFrom readr read_tsv cols
#' 
#' @source \url{https://raw.githubusercontent.com/josh-byster/fips_lat_long/master/counties.txt}
#'
#' @seealso \url{https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html}
#'
#' @return a data frame with county names, FIPS codes, areas, and lat/long
#'
#' @family data-import
#' 
#' @examples
#' usc = us_county_geo_details()
#' dplyr::glimpse(usc)
#' usc
#' 
#'
#' @export
us_county_geo_details <- function() {
    readr::read_tsv('https://raw.githubusercontent.com/josh-byster/fips_lat_long/master/counties.txt',
                    col_types = readr::cols())
}
