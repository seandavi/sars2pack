#' United States county-level geographic details
#'
#'
#' @importFrom readr read_tsv
#' 
#' @source \url{https://raw.githubusercontent.com/josh-byster/fips_lat_long/master/counties.txt}
#'
#' @seealso \url{https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html}
#'
#' @return a data frame with county names, FIPS codes, areas, and lat/long
#'
#' @examples
#' us_county_geo_details()
#'
#' @export
us_county_geo_details <- function() {
    read_tsv('https://raw.githubusercontent.com/josh-byster/fips_lat_long/master/counties.txt')
}
