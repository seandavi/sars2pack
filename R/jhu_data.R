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
#' @importFrom readr read_csv cols
#' @importFrom tidyr pivot_longer
#'
#' @return a long-form tibble
#'
#' @keywords internal
.munge_data_from_jhu <- function(subset) {
    stopifnot(
        subset %in% c('confirmed', 'deaths', 'recovered')
    )
    url = sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_%s_global.csv", subset)
    rpath = s2p_cached_url(url)
    csv = readr::read_csv(rpath, col_types=cols(), guess_max=5000)
    csv = tidyr::pivot_longer(csv,-c('Province/State','Country/Region','Lat','Long'), names_to = 'date', values_to='count')
    names(csv)[1] <- "ProvinceState"
    names(csv)[2] <- "CountryRegion"
    csv$subset = tolower(subset)
    return(csv)
}

#' Global COVID-19 data from [JHU CSSEGIS](https://github.com/CSSEGISandData/COVID-19/)
#'
#' This function access and munges the cumulative time series confirmed,
#' deaths and recovered from the data in the repository for the 2019 Novel Coronavirus Visual
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
#' - ProvinceState:  Province or state. **Note**: 
#' - CountryRegion:  This is the main column for finding countries of interest
#' - Lat:  Latitude
#' - Long:  Longitude
#' - date:  Date
#' - count:  The cumulative count of cases for a given geographic area. 
#' - subset: either `confirmed`, `deaths`, or `recovered`.
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
#' dplyr::glimpse(res)
#' 
#' @source
#' - \url{https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series,mGT, method=c('EG','TD'))}
#' 
#' @family data-import
#' 
#' @export
jhu_data <- function() {
    res = dplyr::bind_rows(lapply(c('confirmed', 'deaths', 'recovered'), .munge_data_from_jhu))
    res$date = lubridate::mdy(res$date)
    return(res)
}

#' simple function to munge JHU US counties data into long-form tibble
#'
#' This function takes one of two subsets--confirmed,
#' deaths--and munges. 
#'
#' @param subset character(1) of Confirmed, Deaths
#' 
#' @importFrom readr read_csv cols
#' @importFrom tidyr pivot_longer
#'
#' @return a long-form tibble
#'
#' @keywords internal
.munge_us_data_from_jhu <- function(subset) {
    stopifnot(
        subset %in% c('confirmed', 'deaths')
    )
    csv = readr::read_csv(url(sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_%s_US.csv", subset)),col_types=cols())
    if (is.null(csv[["Population"]])) csv[["Population"]] <- NA_integer_
    csv = tidyr::pivot_longer(csv,-c("UID", "iso2", "iso3", "code3", "FIPS", "Admin2", "Province_State",  "Country_Region", "Lat", "Long_", "Combined_Key", "Population"), names_to = 'date', values_to='count')
    names(csv)[names(csv)=='FIPS'] <- 'fips'
    csv$fips = integer_to_fips(csv$fips)
    names(csv)[names(csv)=='Admin2'] <- 'county'
    names(csv)[names(csv)=='Province_State'] <- 'state'
    names(csv)[names(csv)=='Country_Region'] <- 'country'
    names(csv)[names(csv)=='Long_'] <- "Long"
    csv$subset = tolower(subset)
    return(csv)
}

#' US counties COVID-19 data from [JHU CSSEGIS](https://github.com/CSSEGISandData/COVID-19/)
#'
#' This function access and munges the cumulative time series of confirmed,
#' and deaths from the US data in the repository for the 2019 Novel Coronavirus Visual
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
#' - UID:  Universal Identifier
#' - iso2:  ISO 3166-1 alpha-2 code
#' - iso3:  ISO 3166-1 alpha-3 code
#' - code3
#' - fips:  Federal Information Processing Standard Publication code
#' - county:  County
#' - state:  Province or state.
#' - country:  US
#' - Lat:  Latitude
#' - Long:  Longitude
#' - Combined_Key:  Comma-separated combination of columns `Admin2`, `ProvinceState`, and `CountryRegion`
#' - date:  Date
#' - count:  The cumulative count of cases for a given geographic area. 
#' - subset:  either `confirmed` or `deaths`
#'
#' @note
#'
#' - Although numbers are meant to be cumulative, there are instances where a day's count might
#'   be less than the prior day due to a reclassification of a case. These are not currently corrected
#'   in the source data
#' 
#' @examples
#' res = jhu_data()
#' colnames(res)
#' head(res)
#' dplyr::glimpse(res)
#' 
#' table(res$state)
#'
#' 
#' @source
#' - \url{https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series}
#' 
#' @family data-import
#' 
#' @export
jhu_us_data <- function() {
    res = dplyr::bind_rows(lapply(c('confirmed', 'deaths'), .munge_us_data_from_jhu))
    res$date = lubridate::mdy(res$date)
    return(res)
}
