#' United States Consumer Spending
#' 
#' Aggregated and anonymized purchase data from consumer credit and debit card spending. Spending is reported based on the ZIP code where the cardholder lives, not the ZIP code where transactions occurred.
#' 
#' @details 
#' Data are Seasonally adjusted change since January 2020. Data is indexed in 2019 and 2020 as the change relative to the January index period. We then seasonally adjust by dividing year-over-year, which represents the difference between the change since January observed in 2020 compared to the change since January observed since 2019. We account for differences in the dates of federal holidays between 2019 and 2020 by shifting the 2019 reference data to align the holidays before performing the year-over-year division.
#' 
#' Geographies: National, State, County, Metro
#' 
#' ## Breakdowns:
#' 
#' ### By Industry. Industries are constructed by grouping merchant codes that are used by Affinity Solutions to identify the category of merchant and merchant activity.
#'
#' - Apparel and General Merchandise
#' - Entertainment and Recreation
#' - Grocery
#' - Health Care
#' - Resturants and Hotels
#' - Transportation
#' 
#' ### By Consumer Zip Code Income. Transactions are linked to zip codes where the consumer lives and zip codes are classified into income categories based on measurements of median household income and population provided by the American Community Survey (2014 - 2018).
#' 
#' - High Income (median household income greater than $78,000 per year)
#' - Middle Income (median household income between $46,000 per year and $78,000 per year)
#' - Low Income (median household income less than $46,000 per year)
#' 
#' ### Column descriptions
#' 
#' - spend_all: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in all merchant category codes (MCC), 7 day moving average.
#' - spend_acf: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in accomodation and food service (ACF) MCCs, 7 day moving average, 7 day moving average.
#' - spend_aer: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in arts, entertainment, and recreation (AER) MCCs, 7 day moving average.
#' - spend_apg: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in general merchandise stores (GEN) and apparel and accessories (AAP) MCCs, 7 day moving average.
#' - spend_grf: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in grocery and food store (GRF) MCCs, 7 day moving average.
#' - spend_hcs: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in health care and social assistance (HCS) MCCs, 7 day moving average.
#' - spend_tws: Seasonally adjusted credit/debit card spending relative to January 4-31 2020 in transportation and warehousing (TWS) MCCs, 7 day moving average.
#' - spend_all_inchigh: Seasonally adjusted credit/debit card spending by consumers living in ZIP codes with high (top quartile) median income, relative to January 4-31 2020 in all merchant category codes (MCC), 7 day moving average.
#' - spend_all_incmiddle: Seasonally adjusted credit/debit card spending by consumers living in ZIP codes with middle (middle two quartiles) median income, relative to January 4-31 2020 in all merchant category codes (MCC), 7 day moving average.
#' - spend_all_inclow: Seasonally adjusted credit/debit card spending by consumers living in ZIP codes with low (bottom quartiles) median income, relative to January 4-31 2020 in all merchant category codes (MCC), 7 day moving average.
#' - spend_all_q2: Seasonally adjusted credit/debit card spending by consumers living in ZIP codes in the second quartile (i.e. second lowest) of median incomes, relative to January 4-31 2020 in all merchant category codes (MCC), 7 day moving average.
#' - spend_all_q3: Seasonally adjusted credit/debit card spending by consumers living in ZIP codes in the third quartile (i.e. second highest) of median incomes, relative to January 4-31 2020 in all merchant category codes (MCC), 7 day moving average.
#' 
#' 
#' @references 
#' - \url{https://opportunityinsights.org/wp-content/uploads/2020/05/tracker_paper.pdf}
#' 
#' @note The raw data contains discontinuous breaks caused by entry or exit of credit card providers from the sample. In order to reliably identify and correct these breaks, we require at least 3 weeks of data. The most recent 3 weeks of data are therefore marked 'provisional' and are subject to non-negligible changes as new data is posted. For breaks found prior to the last 3 weeks, we correct for it using a method outlined in the paper. Otherwise we substitute the national mean for more recent breaks while we gather enough data to implement the corrections outlined in the paper. Additionally, at the county-level when are there more than one structural breaks the data is too noisy to correct for these breaks and counties with multiple breaks are dropped from the sample. Lastly, Affinity Solutions suppresses any cut of the data with fewer than five transactions. For more details refer to the accompanying paper.
#' @author Sean Davis <seandavi@gmail.com>
#' @source
#' - Affinity Solutions via Opportunity Insight econ tracker
#' - Update Frequency: Weekly
#' 
#' @name econ_tracker_consumer_spending
#' 
#' @family data-import
#' @family econonics
#' 
#' @export
econ_tracker_consumer_spending_city_data = function() {
    locs = econ_tracker_city_geo()
    setkey(locs,'cityid')
    url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/Affinity%20-%20City%20-%20Daily.csv"
    rpath = s2p_cached_url(url)
    dat = data.table::fread(rpath, na.strings = '.')
    data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
    data.table::set(dat, j=c('year','month','day'), value=NULL)
    setkey(dat,'cityid')
    locs[dat,all=TRUE]
}

#' @rdname econ_tracker_consumer_spending
#' @export
econ_tracker_consumer_spending_county_data = function() {
  locs = econ_tracker_county_geo()
  setkey(locs,'countyfips')
  url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/Affinity%20-%20County%20-%20Daily.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
  data.table::set(dat, j=c('year','month','day'), value=NULL)
  data.table::set(dat, j='countyfips', value=integer_to_fips(dat[['countyfips']]))
  setkey(dat,'countyfips')
  locs[dat,all=TRUE]
}

#' @rdname econ_tracker_consumer_spending
#' @export
econ_tracker_consumer_spending_state_data = function() {
  locs = econ_tracker_state_geo()
  setkey(locs,'statefips')
  url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/Affinity%20-%20State%20-%20Daily.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
  data.table::set(dat, j=c('year','month','day'), value=NULL)
  data.table::set(dat, j='statefips', value=integer_to_fips(dat[['statefips']]))
  setkey(dat,'statefips')
  locs[dat,all=TRUE]
}

#' @rdname econ_tracker_consumer_spending
#' @export
econ_tracker_consumer_spending_national_data = function() {
  url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/Affinity%20-%20National%20-%20Daily.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
  data.table::set(dat, j=c('year','month','day'), value=NULL)
  dat
}
