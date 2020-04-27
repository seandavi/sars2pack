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
#' - \url{https://raw.githubusercontent.com/descarteslabs/DL-COVID-19/master/DL-us-mobility-daterow.csv}
#'
#' @references
#' - \url{https://www.descarteslabs.com/mobility-v097/}
#' - \url{https://www.descarteslabs.com/wp-content/uploads/2020/03/mobility-v097.pdf}
#'
#' @section License:
#'
#' Creative Commons Attribution (CC BY 4.0), see \url{https://github.com/descarteslabs/DL-COVID-19}
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
#' dplyr::glimpse(res)
#'
#' # plot data for Georgia
#' library(ggplot2)
#'
#' # this gets us state-level data
#' GA = res %>% dplyr::filter(admin1=='Georgia' & admin_level==1)
#'
#' ggplot(GA, aes(x=date, y=m50_index)) + geom_line() + ggtitle('M50 index over time in Georgia')
#' 
#' #limit to dates of interest around time that GA is reopening
#'
#' GA = GA %>% dplyr::filter(date>as.Date('2020-01-01') & date < as.Date('2020-06-01'))
#' ggplot(GA, aes(x=date, y=m50_index)) +
#'     geom_line() +
#'     ggtitle('M50 index over time in Georgia')
#' # Obviously, there are day-specific effects, so use
#' # R to "regress out" the effects of day of week to better
#' # observe trend.
#' GA = GA %>% dplyr::mutate(dow = lubridate::wday(date, label=TRUE))
#' lmfit = lm(m50_index ~ dow, data = GA)
#'
#' # We are interested in the residuals, or
#' # the variation in the data not explained by
#' # the day of the week.
#' GA$m50_index_regressed = residuals(lmfit)
#'
#' ggplot(GA, aes(x=date, y=m50_index_regressed)) +
#'     geom_smooth() +
#'     geom_point()
#'
#' # Compare states
#' states = c("New York", "California", "Nevada",
#'            "Texas", "Georgia", "Florida")
#' ST = res %>%
#'           dplyr::filter(admin1 %in% states & admin_level==1) %>%
#'           dplyr::mutate(dow = lubridate::wday(date, label=TRUE))
#' lmfit = lm(m50_index ~ dow + admin1, data = ST)
#' ST$m50_index_regressed = residuals(lmfit)
#'
#' ggplot(ST, aes(x=date, y=m50_index_regressed)) +
#'     geom_smooth() +
#'     geom_point() +
#'     facet_wrap('admin1', nrow=2) +
#'     ggtitle('Mobility index differences across states')
#' 
#' 
#'
#' @family data-import
#' @family mobility
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
