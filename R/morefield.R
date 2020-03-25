# THIS CODE IS MODIFIED FROM MOREFIELD/MALLERY WITH SOME ADDITIONAL OPTIONS
# ORIGINAL CODE IS IN SOURCE PACKAGE sars2pack/inst/original

# RUN PATTERN DEVELOPED BY C. MOREFIELD and ABSTRACTED by J. Mallery

#' simple function to munge JHU data into long-form tibble
#'
#' This function takes one of three subsets--confirmed,
#' deaths, recovered--and munges. 
#'
#' @param subset character(1) of Confirmed, Deaths, Recovered
#' 
#' @importFrom readr read_csv
#' @importFrom tidyr pivot_longer
#'
#' @return a long-form tibble
#'
#' @keywords internal
.munge_data_from_jhu <- function(subset) {
    stopifnot(
        subset %in% c('confirmed', 'deaths')
    )
    csv = suppressMessages(readr::read_csv(url(sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_%s_global.csv", subset))))
    csv = tidyr::pivot_longer(csv,-c('Province/State','Country/Region','Lat','Long'),names_to = 'date', values_to='count')
    names(csv)[1] <- "ProvinceState"
    names(csv)[2] <- "CountryRegion"
    csv$subset = tolower(subset)
    return(csv)
}

#' Global COVID-19 data from [JHU CSSEGIS](https://github.com/CSSEGISandData/COVID-19/)
#'
#' This function access and munges the cumulative time series confirmed and
#' deaths from the data in the repository for the 2019 Novel Coronavirus Visual
#' Dashboard operated by the Johns Hopkins University Center for
#' Systems Science and Engineering (JHU CSSE). Also, Supported by ESRI
#' Living Atlas Team and the Johns Hopkins University Applied Physics
#' Lab (JHU APL).
#'
#' @details
#' Data are updated daily by JHU. Each call to this function redownloads the data
#' from github. No data cleansing is performed. Data are downloaded and then munged
#' into long-form tidy `data.frame`.
#' 
#' @importFrom dplyr bind_rows
#' @importFrom lubridate mdy
#'
#' @note Uses https://raw.githubusercontent.com/CSSEGISandData/... as data
#' source, then modifies column names and munges to long form table.
#' 
#' @return
#' A tidy `data.frame` (actually, a `tbl_df`) with columns: 
#' 
#' - ProvinceState: <chr> Province or state. **Note**: 
#' - CountryRegion <chr> This is the main column for finding countries of interest
#' - Lat: <dbl> Latitude
#' - Long: <dbl> Longitude
#' - date: <date>
#' - count: <dbl> The cumulative count of cases for a given geographic area. 
#' - subset: <chr> either `confirmed` or `deaths`
#'
#' @note
#'
#' - US States are treated different from other countries, so are not directly included right now.
#' - Although numbers are meant to be cumulative, there are instances where a day's count might
#'   be less than the prior day due to a reclassification of a case. These are not currently corrected
#'   in the source data
#' 
#' @examples
#' res = jhu_data()
#' colnames(res)
#' head(res)
#'
#' @source
#' - \url{https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series}
#' 
#' @family data-import
#' 
#' @export
jhu_data <- function() {
    res = dplyr::bind_rows(lapply(c('confirmed', 'deaths'), .munge_data_from_jhu))
    res$date = lubridate::mdy(res$date)
    class(res) = c('s2p_long_df', class(res))
    return(res)
}
