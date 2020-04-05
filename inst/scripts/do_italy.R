library(dplyr)
library(magrittr)
library(RCurl)
library(R0)
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
trimLeading = function (x, value = 0) 
{
    w <- which.max(cummax(x != value))
    x[seq.int(w, length(x))]
}
as_vector = function(x) data.matrix(x)[1,,drop=TRUE]
cvec = as_vector(get_series(country="Italy"))
ivec = diff(cvec)
tivec = trimLeading(ivec)
estimate.R(tivec, GT=generation.time("gamma", c(3.5,4.8)), methods="EG")


