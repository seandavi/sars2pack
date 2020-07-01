#' Excess deaths tracking by Financial Times
#'
#' From the Financial Times: "'Excess mortality' refers to the difference between deaths from all causes during the pandemic and the historic seasonal average. For many of the jurisdictions shown here, this figure is higher than the official Covid-19 fatalities that are published by national governments each day. While not all of these deaths are necessarily attributable to the disease, it does leave a number of unexplained deaths that suggests that the official figures of deaths attributed may significant undercounts of the pandemic's impact."
#'
#' 
#' @details
#'
#' From the Financial Times github repository:
#' 
#' The data contains excess mortality data for the period covering the
#' 2020 Covid-19 pandemic. The data has been gathered from national,
#' regional or municipal agencies that collect death registrations and
#' publish official mortality statistics. These original data were
#' reshaped into a standardised format by Financial Times journalists
#' to allow cross-national comparisons, and have been used to inform
#' the FT’s reporting on the pandemic.  The repository contains the
#' excess mortality data for all known jurisdictions which publish
#' all-cause mortality data meeting the following criteria:
#'
#' - daily, weekly or monthly level of granularity
#' - includes equivalent historical data for at least one full year before 2020, and preferably at least five years (2015-2019)
#' includes data up to at least April 1, 2020
#' 
#' Most countries publish mortality data with a longer periodicity
#' (typically quarterly or even annually), a longer publication lag
#' time, or both. This sort of data is not suitable for ongoing
#' analysis during an epidemic and is therefore not included here.
#' 
#' @references
#' Coronavirus tracked: the latest figures as countries start to reopenFree to read, \url{https://www.ft.com/content/a26fbf7e-48f8-11ea-aeb3-955839e06441}
#'
#' @source
#' \url{https://github.com/Financial-Times/coronavirus-excess-mortality-data}
#'
#' @section License:
#' \url{https://creativecommons.org/licenses/by/4.0/}
#'
#' @author
#' Sean Davis <seandavi@gmail.com>
#'
#' @family data-import
#' @family excess-deaths
#'
#' @examples
#' res = financial_times_excess_deaths()
#'
#' head(res)
#' dplyr::glimpse(res)
#'
#' @export
financial_times_excess_deaths <- function() {
    url = 'https://github.com/Financial-Times/coronavirus-excess-mortality-data/raw/master/data/ft_excess_deaths.csv'
    rpath = s2p_cached_url(url)
    readr::read_csv(rpath, col_types=readr::cols())
}

