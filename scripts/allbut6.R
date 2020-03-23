library(dplyr)
library(magrittr)
library(RCurl)
library(R0)
library(lubridate)

fetch_JHU_Data = function (as.data.frame = FALSE) 
{
    csv <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
    data <- read.csv(text = csv, check.names = F)
    names(data)[1] <- "ProvinceState"
    names(data)[2] <- "CountryRegion"
    numberColumns <- length(names(data))
    if (!as.data.frame) 
        return(data.table(data))
    data
}
get_series = function (province = "", country, dataset = try(fetch_JHU_Data(as.data.frame = TRUE))) 
{
    if (inherits(dataset, "try-error")) 
        stop("could not get data from fetch_JHU_Data()")
    stopifnot(all(c("ProvinceState", "CountryRegion") %in% colnames(dataset)))
    stopifnot(country %in% dataset$CountryRegion)
    ans = dataset %>% dplyr::filter(ProvinceState == province & 
        CountryRegion == country)
    ans[, -c(1:4)]
}
plot_series = function (province = "", country, dataset = try(fetch_JHU_Data(as.data.frame = TRUE)), 
    ...) 
{
    if (inherits(dataset, "try-error")) 
        stop("could not get data from fetch_JHU_Data()")
    ser = get_series(province = province, country = country, 
        dataset = dataset)
    dates = lubridate::as_date(mdy(fix_slash_dates(names(dataset)[-c(1:4)])))
    plot(dates, ser, main = paste(province, country), ...)
}

as_vector = function(x) data.matrix(x)[1,,drop=TRUE]

trimLeading <- function(x, value=0) {
	w <- which.max(cummax(x != value))
	x[seq.int(w, length(x))] }

diff_data <- function (cdata) {
	cdata <- append(cdata[1], diff(cdata))
	cdata <- trimLeading(cdata, value = 0)
	cdata}

my_plot <- function (title, cumulative_vector)
	plot(cumulative_vector~as_date(ymd(names(cumulative_vector))), main= title)

# cvec = as_vector(get_series(country="Italy"))
# ivec = diff(cvec)
# tivec = trimLeading(ivec)
# estimate.R(tivec, GT=generation.time("gamma", c(3.5,4.8)), methods="EG")
# estimate.R(incidence_vector, GT = generation_time , t = as_date(myd(names(tivec))), begin=1L, end=as.integer(length(incidence_vector)), methods=c("EG"))}	
# estimate.R(incidence_vector, GT=generation_time, methods="EG")
# 	estimate.R(incidence_vector, GT = generation_time , t = as_date(myd(names(tivec))), begin=1L, end=as.integer(length(incidence_vector)), methods=c("EG"))

# pass in the time vector and diff data	
My_Estimate_R <- function (generation_time, incidence_vector) {
		estimate.R(incidence_vector, GT = generation_time , t = as_date(myd(names(incidence_vector))), begin=1L, end=as.integer(length(incidence_vector)), methods=c("EG"))
	}

# SCRIPTS FOR ESTIMATING VARIOUS REGIONS

GT.cov2 <- generation.time("gamma", c(4.75, 3.96))

data.France <- as_vector(get_series("France", "France"))
diff.France <- diff_data(data.France)
R.France <- My_Estimate_R (GT.cov2, diff.France)
R.France

data.Germany <- as_vector(get_series("", "Germany"))
diff.Germany <- diff_data(data.Germany)
R.Germany <- My_Estimate_R (GT.cov2, diff.Germany)
R.Germany

data.Italy <- as_vector(get_series("", "Italy"))
diff.Italy <- diff_data(data.Italy)
R.Italy <- My_Estimate_R (GT.cov2, diff.Italy)
R.Italy

data.Spain <- as_vector(get_series("", "Spain"))
diff.Spain <- diff_data(data.Spain)
R.Spain <- My_Estimate_R (GT.cov2, diff.Spain)
R.Spain

data.UK <- as_vector(get_series("United Kingdom",  "United Kingdom",))
diff.UK <- diff_data(data.UK)
R.UK <- My_Estimate_R (GT.cov2, diff.UK)
R.UK

# Middle East

#data.Iran <- as_vector(get_series("", "Iran"))
#diff.Iran <- diff_data(data.Iran)
#R.Iran <- My_Estimate_R (GT.cov2, diff.Iran)
#R.Iran

data.SouthKorea <- as_vector(get_series("", "Korea, South"))
diff.SouthKorea <- diff_data(data.SouthKorea)
R.SouthKorea <- My_Estimate_R (GT.cov2, diff.SouthKorea)
R.SouthKorea

data.Singapore <- as_vector(get_series("", "Singapore"))
diff.Singapore <- diff_data(data.Singapore)
R.Singapore <- My_Estimate_R (GT.cov2, diff.Singapore)
R.Singapore

# US States and Regions

#data.NewYork <- as_vector(get_series("New York","US"))
#diff.NewYork <- diff_data(data.NewYork)
#R.NewYork <- My_Estimate_R (GT.cov2, diff.NewYork)
#R.NewYork

#data.Illinois <- as_vector(get_series("Illinois", "US"))
#diff.Illinois <- diff_data(data.Illinois)
#R.Illinois <- My_Estimate_R (GT.cov2, diff.Illinois)
#R.Illinois

#data.Massachusetts <- as_vector(get_series("Massachusetts", "US"))
#diff.Massachusetts <- diff_data(data.Massachusetts)
#R.Massachusetts <- My_Estimate_R (GT.cov2, diff.Massachusetts)
#R.Massachusetts

#data.California <- as_vector(get_series("California", "US"))
#diff.California <- diff_data(data.California)
#R.California <- My_Estimate_R (GT.cov2, diff.California)
#R.California

#data.NewHampshire <- as_vector(get_series("New Hampshire", "US"))
#diff.NewHampshire <- diff_data(data.NewHampshire)
#R.NewHampshire <- My_Estimate_R (GT.cov2, diff.NewHampshire)
#R.NewHampshire



































