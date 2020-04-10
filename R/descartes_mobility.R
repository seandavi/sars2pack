#' Get US daily mobility data from Descarte Labs
#'
#' 
#' 
#' @source
#' - https://raw.githubusercontent.com/descarteslabs/DL-COVID-19/master/DL-us-mobility-daterow.csv
#' @return
#' - country_code: ISO 3166-1 alpha-2 code.
#' - admin_level: 0 for country, 1 for admin1, 2 for admin2 granularity.
#' - admin1: GeoNames ADM1 feature name for the first-order administrative division, such as a state in the United States.
#' - admin2: GeoNames ADM2 feature name for the second-order administrative division, such as a county or borough in the United States.
#' - fips: FIPS code, a standard geographic identifier, to make it easier to combine this data with other data sets.
#' - samples: The number of samples observed in the specified region.
#' - m50: The median of the max-distance mobility for all samples in the specified region.
#' - m50_index: The percent of normal m50 in the region, with normal m50 defined during 2020-02-17 to 2020-03-07.
#'
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @examples
#' res = descartes_mobility_data()
#' colnames(res)
#' glimpse(res)
#'
#' @family data-import
#' 
#' @export
decartes_mobility_data = function() {
    rpath = s2p_cached_url('https://raw.githubusercontent.com/descarteslabs/DL-COVID-19/master/DL-us-mobility-daterow.csv')
    res = readr::read_csv(rpath)
    res$date = lubridate::mdy(res$date)
    class(res) = c('s2p_mobility', class(res))
    res
}
