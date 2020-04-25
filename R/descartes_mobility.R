#' Get US daily mobility data from Descartes Labs
#'
#' Descartes Labs quantify the level of human mobility in the US at
#' the state level. Their methodology looks at a collection of mobile
#' devices reporting consistently throughout the day. They calculate the
#' maximum distance moved in kilometers (excluding outliers) from the
#' first reported location. Using this value, they calculate the median
#' across all devices in the sample to generate a mobility metric for
#' selected states.
#' 
#' 
#' @source
#' - https://raw.githubusercontent.com/descarteslabs/DL-COVID-19/master/DL-us-mobility-daterow.csv
#'
#' @references
#' - https://www.descarteslabs.com/mobility-v097/
#' - https://www.descarteslabs.com/wp-content/uploads/2020/03/mobility-v097.pdf
#'
#' @section License:
#'
#' Creative Commons Attribution (CC BY 4.0), see https://github.com/descarteslabs/DL-COVID-19
#'
#' @importFrom readr read_csv
#' 
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
#' library(dplyr)
#' res = descartes_mobility_data()
#' colnames(res)
#' glimpse(res)
#'
#' @family data-import
#' 
#' @export
descartes_mobility_data = function() {
    rpath = s2p_cached_url('https://raw.githubusercontent.com/descarteslabs/DL-COVID-19/master/DL-us-mobility-daterow.csv')
    res = readr::read_csv(rpath, col_types = cols())
    res$fips = integer_to_fips(as.integer(res$fips))
    class(res) = c('s2p_mobility', class(res))
    colnames(res)[colnames(res)=='country_code'] = 'iso2'
    res
}
