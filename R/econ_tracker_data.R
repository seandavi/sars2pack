.fix_econ_tracker_dates = function(dat) {
  if(!is(dat,'data.table')) {
    stop("input is expected to be a data.table object")
  }
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day_endofweek,sep="-")))
  data.table::set(dat, j=c('year','month','day_endofweek'), value=NULL)
  dat
}


#' Econ tracker information
#' 
#' @name econtracker
#' 
#' @return data.frame
#' 
#' @references 
#' - \url{https://tracktherecovery.org/}
#' 
#' @source
#' - \url{https://github.com/OpportunityInsights/EconomicTracker}
#' 
#' @rdname econtracker
NULL


#' 
#' @rdname econtracker
#' 
#' 
#' 
#' @export
econ_tracker_county_geo = function() {
  url = "https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/GeoIDs%20-%20County.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath)
  dat$countyfips=integer_to_fips(dat$countyfips)
  dat$statefips = integer_to_fips(dat$statefips)
  dat
}

#' @rdname econtracker
#' @export
econ_tracker_city_geo = function(){
  url = "https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/GeoIDs%20-%20City.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath)
  dat$statefips = integer_to_fips(dat$statefips)
  dat
}

econ_tracker_state_geo = function(){
  url = "https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/GeoIDs%20-%20State.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath,na.strings = '.')
  dat$statefips = integer_to_fips(dat$statefips)
  dat
}

#' Econ Tracker Unemployment Insurance Claims
#' 
#' Unemployment insurance claims data from the [Department of Labor](https://oui.doleta.gov/unemploy/DataDashboard.asp) (national and state-level) and numerous individual state agencies (county-level).
#' 
#' @name econ_tracker_unemp_data
#' 
#' @details 
#' All datasets contain the following columns in addition to the location details. Dates specify the last day of the week ending
#' for the reported data.
#' 
#' - initclaims_rate_regular: Number of initial claims per 100 people in the 2019 labor force, Regular UI only
#' - initclaims_count_regular: Count of initial claims, Regular UI only
#' - initclaims_rate_pua: Number of initial claims per 100 people in the 2019 labor force, PUA (Pandemic Unemployment Assistance) only
#' - initclaims_count_pua: Count of initial claims, PUA (Pandemic Unemployment Assistance) only
#' - initclaims_rate_combined: Number of initial claims per 100 people in the 2019 labor force, combining Regular and PUA claims
#' - initclaims_count_combined: Count of initial claims, combining Regular and PUA claims
#' - contclaims_rate_regular: Number of continued claims per 100 people in the 2019 labor force, Regular UI only
#' - contclaims_count_regular: Count of continued claims, Regular UI only
#' - contclaims_rate_pua: Number of continued claims per 100 people in the 2019 labor force, PUA (Pandemic Unemployment Assistance) only
#' - contclaims_count_pua: Count of continued claims, PUA (Pandemic Unemployment Assistance) only
#' - contclaims_rate_peuc: Number of continued claims per 100 people in the 2019 labor force, PEUC (Pandemic Emergency Unemployment Compensation) only
#' - contclaims_count_peuc: Count of continued claims, PEUC (Pandemic Emergency Unemployment Compensation) only
#' - contclaims_rate_combined: Number of continued claims per 100 people in the 2019 labor force, combining Regular, PUA and PEUC claims
#' - contclaims_count_combined: Count of continued claims, combining Regular, PUA and PEUC claims
#' 
#' 
#' @family data-import
#' @family economics
#' 
#' @source \url{https://github.com/OpportunityInsights/EconomicTracker}
#' 
#' @references 
#' - \url{https://github.com/OpportunityInsights/EconomicTracker}
#' - \url{https://tracktherecovery.org/}
#' 
#' 
#' @examples
#' 
#' # City Level data
#' 
#' res = econ_tracker_unemp_city_data()
#' head(res)
#' 
#' 
#' @export
econ_tracker_unemp_city_data = function() {
  cities = econ_tracker_city_geo()
  url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/UI%20Claims%20-%20City%20-%20Weekly.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day_endofweek,sep="-")))
  data.table::set(dat, j=c('year','month','day_endofweek'), value=NULL)
  dat
}

#' @rdname econ_tracker_unemp_data
#' 
#' @examples
#' 
#' # County Level data
#' 
#' res = econ_tracker_unemp_county_data()
#' head(res)
#' 
#' 
#' @export
econ_tracker_unemp_county_data = function() {
  locs = econ_tracker_county_geo()
  setkey(locs,'countyfips')
  url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/UI%20Claims%20-%20County%20-%20Weekly.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day_endofweek,sep="-")))
  data.table::set(dat, j=c('year','month','day_endofweek'), value=NULL)
  data.table::set(dat, j='countyfips', value=integer_to_fips(dat[['countyfips']]))
  setkey(dat,'countyfips')
  dat[locs,all=TRUE]
}

#' @rdname econ_tracker_unemp_data
#' 
#' @examples
#' 
#' # State Level data
#' 
#' res = econ_tracker_unemp_state_data()
#' head(res)
#' 
#' 
#' @export
econ_tracker_unemp_state_data = function() {
  locs = econ_tracker_state_geo()
  setkey(locs,'statefips')
  url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/UI%20Claims%20-%20State%20-%20Weekly.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day_endofweek,sep="-")))
  data.table::set(dat, j=c('year','month','day_endofweek'), value=NULL)
  data.table::set(dat, j='statefips', value=integer_to_fips(dat[['statefips']]))
  setkey(dat,'statefips')
  dat[locs,all=TRUE]
}

#' @rdname econ_tracker_unemp_data
#' 
#' @examples 
#' 
#' # National Level data
#' 
#' res = econ_tracker_unemp_national_data()
#' head(res)
#' 
#' @export
econ_tracker_unemp_national_data = function() {
  url = "https://github.com/OpportunityInsights/EconomicTracker/raw/main/data/UI%20Claims%20-%20National%20-%20Weekly.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day_endofweek,sep="-")))
  data.table::set(dat, j=c('year','month','day_endofweek'), value=NULL)
  dat
}