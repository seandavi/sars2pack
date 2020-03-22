
# RUN PATTERN DEVELOPED BY C. MOREFIELD and ABSTRACTED by J. Mallery

#' retrieve confirmed case csv file from CSSEGIS (?)
#' @importFrom utils read.csv
#' @import data.table
#' @importFrom RCurl getURL
#' @import R0
#' @param as.data.frame logical(1) if TRUE return data.frame otherwise, data.table
#' @note Uses https://raw.githubusercontent.com/CSSEGISandData/... as data source, then modifies column names
#' @return instance of data.table by default; returns data.frame if `as.data.frame` is TRUE
#' @export
fetch_JHU_Data <- function(as.data.frame=FALSE) {
	csv <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
	data <- read.csv(text = csv, check.names = F)
	names(data)[1] <- "ProvinceState"
	names(data)[2] <- "CountryRegion"
	numberColumns <- length(names(data))
	if (!as.data.frame) return(data.table(data))
        data
}


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
#' 
.munge_data_from_jhu <- function(subset) {
    stopifnot(
        subset %in% c('Confirmed', 'Deaths', 'Recovered')
    )
    csv = suppressMessages(readr::read_csv(url(sprintf("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-%s.csv", subset))))
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
    res = dplyr::bind_rows(lapply(c('Confirmed', 'Deaths', 'Recovered'), .munge_data_from_jhu))
    res$date = lubridate::mdy(res$date)
    class(res) = c('s2p_long_df', class(res))
    return(res)
}

#' trim leading repeats of given value
#' @param x vector of same type as `value`
#' @param value entity whose repeats are to be removed
#' @examples
#' dat = c(0,0,3,0,4)
#' trimLeading(dat, value=0)
#' @export
trimLeading <- function(x, value=0) {
	w <- which.max(cummax(x != value))
	x[seq.int(w, length(x))] }

## NOTA BENE -- THIS IS GETTING DICEY, MAKES
## ASSUMPTIONS ABOUT FIELD NAMES IN `data` and uses
## data.table idiom where this is not really necessary
## A functional approach would probably be more reliable
## and maintainable in general

#' extract a sub data.table (row) with specific CountryRegion 
#' @param name character(1) row selection
#' @param data a data.table with field `CountryRegion`
extract_country_data <- function (name, data) {
	cdata <- data[CountryRegion == name] 
	cdata}

#' extract a sub data.table (row) with specific ProvinceState
#' @param name character(1) row selection
#' @param data a data.table with field `CountryRegion`
extract_ProvinceState_data <- function (name, data) {
       data[ProvinceState == name] 
}

#' prepare data using data.table idiom, unlist, trimLeading etc.
#' @param cdata presumably a data.table
#' @export
prepare_data <- function (cdata) {
        numberColumns = length(names(cdata))
	cdata <- cdata[,5:numberColumns] 
	names(cdata) <- NULL
	cdata <- unlist(c(cdata))
	cdata <- append(cdata[1], diff(cdata))
	cdata <- trimLeading(cdata, value = 0) 
	cdata
       }

