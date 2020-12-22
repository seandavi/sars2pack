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
  dat = data.table::fread(rpath)
  dat$statefips = integer_to_fips(dat$statefips)
  dat
}