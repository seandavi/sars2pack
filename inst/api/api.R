require(EpiEstim)
library(sars2pack)
require(jsonlite)
require(urltools)
require(dplyr)
jhu_us = jhu_us_data()
names(jhu_us)[names(jhu_us)=='Combined_Key'] = 'location_key'
usa_facts = usa_facts_data()
usa_facts$location_key = paste(usa_facts$county, usa_facts$state, sep=",")
eu_data_cache = eu_data_cache_data() %>% dplyr::mutate(location_key=paste(nuts_1,nuts_2,nuts_3,country, sep=',')) 

estim_Rt = function(df, mean_si, std_si, count_col = 'count', date_col = 'date') {
    counts =  c(df[['count']][1], diff(df[[count_col]]))
    counts[counts<0] = 0
    incid.filt = data.frame(I = counts, dates=df[[date_col]])
    epiestim = EpiEstim::estimate_R(
                             incid.filt, method = "parametric_si",
                             config = EpiEstim::make_config(list(
                                                    mean_si = 3.96, std_si = 4.75)))
    class(epiestim) = "list"
    epiestim
}

#' available datasets
#'
#' @serializer unboxedJSON
#' @get /datasets
function() {
    list(results=list("jhu_us","usa_facts","eu_data_cache"))
}



#' Get available locations from jhu_us_data
#' @serializer unboxedJSON
#' @get /jhu_us/locations
function() {
    resdf = unique(jhu_us[,c('iso3','fips','county', 'state', 'Lat', 'Long', 'Population', 'location_key')])
    list(results=resdf)
}

#' Get R(t) estimate by location_key
#'
#' @param location_key character `string` representing a single Location_Key from
#'   locations endpoint
#' @param mean_si `number` using the parametric si method from the EpiEstim package, this
#'   is the parameter for mean
#' @param std_si `number` std dev for parametric si calculation
#'
#' @return list with a number of useful elements
#' 
#' @json
#' @get /jhu_us/estimate
function(location_key=NA, mean_si=NA, std_si=NA) {
    alocation_key = url_decode(location_key)
    print(alocation_key)
    stopifnot(alocation_key %in% jhu_us$location_key)
    config = EpiEstim::make_config(list(mean_si=mean_si, std_si = std_si))
    incid_df = jhu_us %>%
        dplyr::filter(location_key == alocation_key & subset=='confirmed') %>%
            dplyr::arrange(date)
    print(incid_df)
    estim_Rt(incid_df, mean_si, std_si, 'count', 'date')
}

#' Get available locations from usa_facts
#' @serializer unboxedJSON
#' @get /usa_facts/locations
function() {
    list(results=unique(usa_facts[,c('county_fips','state_fips','state', 'county', 'location_key')]))
}

#' Get R(t) estimate by location_key
#'
#' @param location_key character `string` representing a single location_key from
#'   locations endpoint
#' @param mean_si `number` using the parametric si method from the EpiEstim package, this
#'   is the parameter for mean
#' @param std_si `number` std dev for parametric si calculation
#'
#' @return list with a number of useful elements
#' 
#' @json
#' @get /usa_facts/estimate
function(location_key=NA, mean_si=NA, std_si=NA) {
    alocation_key = url_decode(location_key)
    stopifnot(alocation_key %in% eu_data_cache$location_key)
    config = EpiEstim::make_config(list(mean_si=mean_si, std_si = std_si))
    incid_df = usa_facts %>% dplyr::filter(location_key == alocation_key & subset=='confirmed') %>%
        dplyr::arrange(date)
    estim_Rt(incid_df, mean_si, std_si, 'count', 'date')
}

#' Get available locations from eu_data_cache
#' @serializer unboxedJSON
#' @get /eu_data_cache/locations
function() {
    list(results=unique(eu_data_cache[,c('country','nuts_1','nuts_2','nuts_3','location_key')]))
}

#' Get R(t) estimate by location_key
#'
#' @param location_key character `string` representing a single location_key from
#'   locations endpoint
#' @param mean_si `number` using the parametric si method from the EpiEstim package, this
#'   is the parameter for mean
#' @param std_si `number` std dev for parametric si calculation
#'
#' @return list with a number of useful elements
#' 
#' @json
#' @get /eu_data_cache/estimate
function(location_key=NA, mean_si=NA, std_si=NA) {
    alocation_key = url_decode(location_key)
    stopifnot(alocation_key %in% eu_data_cache$location_key)
    config = EpiEstim::make_config(list(mean_si=mean_si, std_si = std_si))
    incid_df = eu_data_cache %>% dplyr::filter(location_key == alocation_key) %>%
        dplyr::arrange(date) %>% dplyr::mutate(count=cases)
    estim_Rt(incid_df, mean_si, std_si, 'count', 'date')
}
