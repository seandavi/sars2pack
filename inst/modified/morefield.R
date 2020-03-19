
# RUN PATTERN DEVELOPED BY C. MOREFIELD and ABSTRACTED by J. Mallery

fetch_JHU_Data <- function() {
	csv <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
	data <- read.csv(text = csv, check.names = F)
	names(data)[1] <- "ProvinceState"
	names(data)[2] <- "CountryRegion"
	numberColumns <- length(names(data))
	data.table(data) }
	
trimLeading <- function(x, value=0) {
	w <- which.max(cummax(x != value))
	x[seq.int(w, length(x))] }

extract_country_data <- function (name, data) {
	cdata <- data[CountryRegion == name] 
	cdata}

extract_ProvinceState_data <- function (name, data) {data[ProvinceState == name] }

prepare_data <- function (cdata) {
	cdata <- cdata[,5:numberColumns] 
	names(cdata) <- NULL
	cdata <- unlist(c(cdata))
	cdata <- append(cdata[1], diff(cdata))
	cdata <- trimLeading(cdata, value = 0) 
	cdata}

