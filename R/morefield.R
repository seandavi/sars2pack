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

#' retrieve time series dataset from CSSEGIS
#'
#' This always does a web call. The assumption here is that
#' the user is online and that github is up and that URLs are
#' stable.
#' 
#' @importFrom dplyr bind_rows
#' @importFrom lubridate mdy
#'
#' @note Uses https://raw.githubusercontent.com/CSSEGISandData/... as data
#' source, then modifies column names and munges to long form table.
#' 
#' @return an object of class `s2p_long_df` that inherits from tbl_df
#'
#' @examples
#' res = jhu_data()
#' colnames(res)
#' head(res)
#' 
#' @export
jhu_data <- function() {
    res = dplyr::bind_rows(lapply(c('confirmed', 'deaths'), .munge_data_from_jhu))
    res$date = lubridate::mdy(res$date)
    class(res) = c('s2p_long_df', class(res))
    return(res)
}

#' extract a set of rows with specific CountryRegion 
#' @param name character(1) row selection
#' @param df a data.frame with field `CountryRegion`
#'
#' @return a filtered data.frame
#' 
#' @export
extract_country_data <- function (data, name) {
	df %>% dplyr::filter(CountryRegion == name)
}

#' extract a sub data.table (row) with specific ProvinceState
#' @param name character(1) row selection
#' @param df a data.frame with field `ProvinceState`
#'
#' @return a filtered data.frame
#'
#' @examples
#' jhu_data() %>% extract_ProvinceState_data("Maryland")
#' 
#' @export
extract_ProvinceState_data <- function (df, name) {
    df %>% dplyr::filter(ProvinceState==name)
}

