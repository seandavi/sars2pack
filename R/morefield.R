
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

