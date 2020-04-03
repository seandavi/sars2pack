# From Charles Morefield
# Via biosecurity email list
# April 2, 2020
# 
# 
# Current status: a very simple downloader for covid-19 data and R estimator.
# A work in progress (clm apr 1 2020)
library(EpiEstim)
library(tidyverse)
library(lubridate)
library(readxl)
library(incidence)
#library(ggplot2)
#library(R0)
library(kableExtra)
library(knitr)

# A row of the input spreadsheet may have zeros at the start,
# which we eliminate using  little function called trimLeading.
trimLeading <- function(x, value=0) {
  w <- which.max(cummax(x != value))
  x[seq.int(w, length(x))]
  }

# Create the USAFacts URL where a Covid-19 dataset is stored with automatic updates every day
dataURL <- paste("https://static.usafacts.org/public/data/covid-19/covid_confirmed_usafacts.csv")
# Select a destination path and destination file
destfile <- "/Users/Chuck/Pandemic/rPandemicProject/PandemicData/covid_confirmed_usafacts.csv"
# Download data
download.file(dataURL, destfile)
# Insert entire csv file into an R object
USAfactsData <- as_tibble(read_csv(destfile), col_names = TRUE)
#NOTE: for NYC better to use NYC Health data instead
#countyfips <- 51510 # "countyFIPS" designation for Alexandria City VA
#countyfips <- 51013 # "countyFIPS" designation for Arlington VA
#countyfips <- 33009 # "countyFIPS" designation for Grafton County (Dartmouth)
#countyfips <- 9001 # "countyFIPS" designation for Fairfield County
#countyfips <- 13121 # "countyFIPS" designation for Fulton County (Atlanta)
#countyfips <- 12057 # "countyFIPS" designation for Hillsborough County (Tampa)
#countyfips <- 22071 # "countyFIPS" designation for Orleans Parish (New Orleans)
#countyfips <- 33017 # "countyFIPS" designation for Strafford County (Durham)
#countyfips <- 25025 # "countyFIPS" designation for Suffolk County (Boston)
#countyfips <- 11001 # "countyFIPS" designation for Washington DC
us_counties <- c(51510,51013,33009,9001,13121,12057,22071,33017,25025,11001)
names(us_counties) <- c("AlexandriaCity,VA", "Arlington,VA","Grafton(Hanover)","Fairfield(CT)","Fulton(Atlanta)",
                   "Hillsborough(Tampa)","OrleansParish","Strafford(Durham)","Suffolk(Boston)","Washington,DC")
MeanSI <- 3.96
StdSI  <- 4.75

# Define a custom R function compute_res_parametric_si using EpiEstim to compute R for a specific county and input SI
compute_res_parametric_si <- function(USAfactsData,countyfips,MeanSI,StdSI) {
# pull the designated row of the download (this ASSUMES only one row is pulled)
localCovidData <- as.vector(USAfactsData %>% filter(countyFIPS == countyfips))
localCovidData <- localCovidData[-c(1,2,3,4)] # Remove the first four metadata values leaving just the incidence values
for (k in 2:length(localCovidData)) {
   if (localCovidData[k] < localCovidData[k-1]) localCovidData[k-1] <- localCovidData[k]
}
# Change from cumulative to incidence count
i <- diff(as.numeric(localCovidData))
names(i) <- names(localCovidData[-1])
i <- trimLeading(i, value = 0) # Remove leading zeros from the row we just pulled
i[i < 0] <- 0 # Make sure there are no places where cum reports go down, day-by-day (=> DATA ERROR in database)
if (is.na(i[length(i)]) == TRUE) i <- i[-length(i)] # Remove last element if it is "NA"
#if (i[length(i)] == 0) i <- i[-length(i)] # If last raw report is unchanged then MAYBE data missing. Trim the last date??

# Finalize the incidence matrix "inc":
dates <- mdy(names(i))
I <- as.numeric(i)
inc <- tibble(dates,I)
# Set up the data structure needed as input to EpiEstim.
# We assume SI mean and s.d. will be input from the published literature, so si_distr is set to NULL.
localCovidData  <- list(inc,NULL)
names(localCovidData) <- c("incidence","si_distr")
# plot(as.incidence(localCovidData$incidence$I, dates = localCovidData$incidence$dates))
res_parametric_si <- estimate_R(localCovidData$incidence, method = "parametric_si",
                        config = make_config(list(mean_si = MeanSI, std_si = StdSI)))
res_parametric_si
}  # End of the custom function compute_res_parametric_si
county_res_parametric_si <- data.frame()
meanR <- c()
dateR <- c()
cumCases <- c()
modelR <- c()
meanSerInt <- c()
sdSerInt <- c()
sourceR <- c()
for (j in 1:length(us_counties)) {
   res_parametric_si <- compute_res_parametric_si(USAfactsData,countyfips = us_counties[j],MeanSI,StdSI)
   outputR <- res_parametric_si$R[,3]
   meanR <- c(meanR, outputR[length(outputR)])
   dateR <- c(dateR, res_parametric_si$dates[length(res_parametric_si$dates)])
   cumCases <- c(cumCases,sum(res_parametric_si$I))
   modelR <- c(modelR,"EpiEstim.parametric_si")
   meanSerInt <- c(meanSerInt,MeanSI)
   sdSerInt  <- c(sdSerInt,StdSI)
   sourceR <- c(sourceR,"usafacts.org")
#plot(county_res_parametric_si, legend = FALSE)
}
#names(meanR) <- names(us_counties)
dateR <- as.Date(dateR, origin="1970-01-01") # Convert integer date to standard nomenclature
outputTable_meanR <- as.data.frame(list(dateR,meanR,cumCases,modelR,meanSerInt,sdSerInt,sourceR))
rownames(outputTable_meanR) <- names(us_counties)
colnames(outputTable_meanR) <- c("Date","Mean R","cumCases","Package.Method (CRAN)","Mean SI","StdDev SI","Data Source")
kable(outputTable_meanR,align = "c",digits = 2, "pandoc")
