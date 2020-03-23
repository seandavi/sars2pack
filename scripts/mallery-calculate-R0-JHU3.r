

> ## Demo from RO implementors
> library(R0)
Loading required package: MASS
> 
> # Generating an epidemic with given parameters
> mGT <- generation.time("gamma", c(3,1.5))
> mEpid <- sim.epid(epid.nb=1, GT=mGT, epid.length=30, family="poisson", R0=1.67, peak.value=500)
> mEpid <- mEpid[,1]
> # Running estimations
> est <- estimate.R(epid=mEpid, GT=mGT, methods=c("EG","ML","TD"))
Waiting for profiling to be done...
Warning messages:
1: In est.R0.TD(epid = c(1, 1, 1, 1, 1, 3, 1, 2, 1, 6, 2, 6, 4, 12,  :
  Simulations may take several minutes.
2: In est.R0.TD(epid = c(1, 1, 1, 1, 1, 3, 1, 2, 1, 6, 2, 6, 4, 12,  :
  Using initial incidence as initial number of cases.
> 
> # Model estimates and goodness of fit can be plotted
> plot(est)
> plotfit(est)
# Sensitivity analysis for the EG estimation; influence of begin/end dates
s.a <- sensitivity.analysis(res=est$estimates$EG, begin=1:15, end=16:30, sa.type="time")
# This sensitivity analysis can be plotted
plot(s.a)

# Set up the R environment with the necessary packages
install.packages(c("dplyr", "R0", "magrittr", "RCurl"))

# RUN PATTERN DEVELOPED BY C. MOREFIELD and ABSTRACTED by J. Mallery
# Load libraries
library(R0)
library(RCurl)
library(data.table)

fetch_JHU_Data <- function() {
	csv <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
	data <- read.csv(text = csv, check.names = F)
	names(data)[1] <- "ProvinceState"
	names(data)[2] <- "CountryRegion"
	numberColumns <- length(names(data))
	data.table(data) }
	
prepare_dates <- function (date_vector)	{as_date(mdy(date_vector))}

fetch_JHU_Dates <- function() {
	rawdat = RCurl::getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv")
	curdata = read.csv(text=rawdat, stringsAsFactors=FALSE, check.names=FALSE)
	date_vector <- names(curdata)[-c(1:4)]
	prepare_dates(date_vector )
	}
		
trimLeading <- function(x, value=0) {
	w <- which.max(cummax(x != value))
	x[seq.int(w, length(x))] }
       
extract_country_data <- function (name, data) {
	cdata <- data[CountryRegion == name] 
	cdata}

extract_ProvinceState_data <- function (name, data) {data[ProvinceState == name] }

diff_data <- function (cdata) {
	cdata <- append(cdata[1], diff(cdata))
	cdata <- trimLeading(cdata, value = 0)
	cdata}

prepare_data <- function (cdata) {
	cdata <- cdata[,5:numberColumns] 
	names(cdata) <- NULL
	cdata <- unlist(c(cdata))
	cdata <- diff_data(cdata)
	cdata}

# Fetch the data
my_data <- fetch_JHU_Data()	
numberColumns <- length(names(my_data))	
my_dates <- fetch_JHU_Dates()

# SERIAL TIME INTERVAL
GT.cov2 <- generation.time("gamma", c(4.75, 3.96))
# GT.cov2 <- generation.time("gamma", c(5.8,.95)) # from DOI 10.7326/M20-0504

# EUROPE	
data.France <- extract_ProvinceState_data("France", my_data)
diff.France <- prepare_data(data.France)
R.France <- My_Estimate_R(my_dates,diff.France)
R.France 

epid.count <- prepare_data(extract_country_data("Germany", my_data))
R.Germany <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Germany

epid.count <- prepare_data(extract_country_data("Germany", my_data))
R.Germany <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Germany

epid.count <- prepare_data(extract_country_data("Italy", my_data))
R.Italy <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Italy

epid.count <- prepare_data(extract_country_data("Spain", my_data))
R.Spain <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Spain 

epid.count <- prepare_data(extract_ProvinceState_data("United Kingdom", my_data))
R.UK <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.UK

# MIDDLE EAST
epid.count <- prepare_data(extract_country_data("Iran", my_data))
R.Iran<- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Iran 

# ASIA
epid.count <- prepare_data(extract_country_data("Korea, South", my_data))
R.SouthKorea <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.SouthKorea

epid.count <- prepare_data(extract_country_data("Singapore", my_data))
R.Singapore <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Singapore

# US States and Regions

epid.count <- prepare_data(extract_ProvinceState_data("Illinois", my_data))
R.Illinois <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Illinois

epid.count <- prepare_data(extract_ProvinceState_data("New York", my_data))
R.NewYork <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.NewYork

epid.count <- prepare_data(extract_ProvinceState_data("Massachusetts", my_data))
R.Massachusetts <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Massachusetts

epid.count <- prepare_data(extract_ProvinceState_data("California", my_data))
R.California <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.California

epid.count <- prepare_data(extract_ProvinceState_data("New Hampshire", my_data))
R.NewHampshire <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.NewHampshire


epid.count <- c(267, 99, 76, 126, 4, 71, 261, 172, 0, 362, 148)
R.Washington <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Washington

data.US <- c(2, 2, 5, 5, 5, 5, 5, 7, 8, 8, 11, 11, 11, 11, 11, 11, 11, 11, 12, 12, 13, 13, 13, 13, 13, 13, 13, 13, 15, 15, 15, 51, 51, 57, 58, 60, 68, 74, 98, 118, 149, 217, 262, 402, 518, 583, 959, 1281, 1663, 2179, 2727, 3499, 4632, 6421, 7783, 13677, 19100, 25489, 38757)

epid.count <- diff_data(data.US)
R.US <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.US

Data.Grafton.NH <- c(1,2,2,2,2,2,3,3,3,3,3,3,3,3,5,7,7,9,12,13)
epid.count <- diff_data(Data.Grafton.NH)
R.Grafton.NH <- estimate.R(epid.count, GT = GT.cov2, methods = c("EG"))
R.Grafton.NH 

# Vince Carey R Code to Estimate time dependent reproduction numbers 
# with the attached code you should be able to do
# %vjcair> Rscript pure.R | tail -1
# Waiting for profiling to be done...
# 4.920046 
suppressMessages({
suppressPackageStartupMessages({
ii = rownames(installed.packages())
if (!("BiocManager" %in% ii)) install.packages("BiocManager")
library(BiocManager)
if (!("R0" %in% ii)) BiocManager::install("R0")
library(R0)
if (!("lubridate" %in% ii)) BiocManager::install("lubridate")
library(lubridate)
})
})

#	c("1/22/20", "1/23/20", "1/24/20", "1/25/20", "1/26/20", "1/27/20", "1/28/20", "1/29/20", "1/30/20", "1/31/20", "2/1/20", "2/2/20", "2/3/20", "2/4/20", "2/5/20", "2/6/20", "2/7/20", "2/8/20", "2/9/20", "2/10/20", "2/11/20", "2/12/20", "2/13/20", "2/14/20", "2/15/20", "2/16/20", "2/17/20", "2/18/20", "2/19/20", "2/20/20", "2/21/20", "2/22/20", "2/23/20", "2/24/20", "2/25/20", "2/26/20", "2/27/20", "2/28/20", "2/29/20", "3/1/20", "3/2/20", "3/3/20", "3/4/20", "3/5/20", "3/6/20", "3/7/20", "3/8/20", "3/9/20", "3/10/20", "3/11/20", "3/12/20", "3/13/20", "3/14/20", "3/15/20", "3/16/20", "3/17/20", "3/18/20", "3/19/20", "3/20/20", "3/21/20")
datevec <- as_date(mdy(
	c( "1/24/20", "1/25/20", "1/26/20", "1/27/20", "1/28/20", "1/29/20", "1/30/20", "1/31/20", "2/1/20", "2/2/20", "2/3/20", "2/4/20", "2/5/20", "2/6/20", "2/7/20", "2/8/20", "2/9/20", "2/10/20", "2/11/20", "2/12/20", "2/13/20", "2/14/20", "2/15/20", "2/16/20", "2/17/20", "2/18/20", "2/19/20", "2/20/20", "2/21/20", "2/22/20", "2/23/20", "2/24/20", "2/25/20", "2/26/20", "2/27/20", "2/28/20", "2/29/20", "3/1/20", "3/2/20", "3/3/20", "3/4/20", "3/5/20", "3/6/20", "3/7/20", "3/8/20", "3/9/20", "3/10/20", "3/11/20", "3/12/20", "3/13/20", "3/14/20", "3/15/20", "3/16/20", "3/17/20", "3/18/20", "3/19/20", "3/20/20", "3/21/20", "3/22/20")
	))
cumevents <- data.US
names(cumevents) = datevec
plot(cumevents~as_date(ymd(names(cumevents))), main="US as of 3/22/2020 from JHU. World-o-Meters")
epid.count <- (diff(cumevents))
est1 = estimate.R(epid.count, GT = GT.cov2 , t = as_date(ymd(names(epid.count))),
  begin=1L, end=as.integer(length(epid.count)), methods=c("EG"))
cat(est1$estimates$EG$R, "\n")

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

as_vector = function(x) data.matrix(x)[1,,drop=TRUE]

my_plot <- function (title, cumulative_vector){}
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

data.Iran <- as_vector(get_series("", "Iran"))
diff.Iran <- diff_data(data.Iran)
R.Iran <- My_Estimate_R (GT.cov2, diff.Iran)
R.Iran

data.SouthKorea <- as_vector(get_series("", "Korea, South"))
diff.SouthKorea <- diff_data(data.SouthKorea)
R.SouthKorea <- My_Estimate_R (GT.cov2, diff.SouthKorea)
R.SouthKorea

data.Singapore <- as_vector(get_series("", "Singapore"))
diff.Singapore <- diff_data(data.Singapore)
R.Singapore <- My_Estimate_R (GT.cov2, diff.Singapore)
R.Singapore

# US States and Regions

data.NewYork <- as_vector(get_series("New York","US"))
diff.NewYork <- diff_data(data.NewYork)
R.NewYork <- My_Estimate_R (GT.cov2, diff.NewYork)
R.NewYork

data.Illinois <- as_vector(get_series("Illinois", "US"))
diff.Illinois <- diff_data(data.Illinois)
R.Illinois <- My_Estimate_R (GT.cov2, diff.Illinois)
R.Illinois

data.Massachusetts <- as_vector(get_series("Massachusetts", "US"))
diff.Massachusetts <- diff_data(data.Massachusetts)
R.Massachusetts <- My_Estimate_R (GT.cov2, diff.Massachusetts)
R.Massachusetts

data.California <- as_vector(get_series("California", "US"))
diff.California <- diff_data(data.California)
R.California <- My_Estimate_R (GT.cov2, diff.California)
R.California

data.NewHampshire <- as_vector(get_series("New Hampshire", "US"))
diff.NewHampshire <- diff_data(data.NewHampshire)
R.NewHampshire <- My_Estimate_R (GT.cov2, diff.NewHampshire)
R.NewHampshire



















































































