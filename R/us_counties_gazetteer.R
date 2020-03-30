#' United States county-level geographic details
#'
#'
#' @importFrom readr read_tsv cols
#' @importFrom sf st_as_sf
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
#' glimpse(usc)
#' usc
#' 
#'
#' @export
us_county_geo_details <- function() {
    res = readr::read_tsv(s2p_cached_url('https://raw.githubusercontent.com/josh-byster/fips_lat_long/master/counties.txt'),
                          col_types = readr::cols())
    res = sf::st_as_sf(res, coords=c('INTPTLONG','INTPTLAT'))
    colnames(res)[1:8] = c('state','fips','ansicode','county','area_land','area_water','area_land_sqmi','area_water_sqmi')
    res
}
