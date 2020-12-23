#' United States social distancing policies for COVID-19
#' 
#' An updated, curated set of social distancing and non-pharmaceutical interventions
#' for states in the United States and District of Columbia.
#' 
#' @importFrom readr read_csv
#' @importFrom dplyr select starts_with
#' 
#' @source 
#' - https://github.com/COVID19StatePolicy/SocialDistancing/
#' 
#' 
#' @section Kudos:
#' - Joe Wasserman: \url{http://www.joewasserman.com/}
#' 
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @family data-import
#' @family NPI
#' 
#' @examples 
#' res = us_state_distancing_policy()
#' colnames(res)
#' library(dplyr)
#' dplyr::glimpse(res)
#' summary(res)
#' 
#' @export
us_state_distancing_policy = function() {
    rpath = s2p_cached_url('https://raw.githubusercontent.com/COVID19StatePolicy/SocialDistancing/master/data/USstatesCov19distancingpolicyBETA.csv')
    res = data.table::fread(rpath)
    res %>% dplyr::select(-dplyr::starts_with('X')) %>%
        dplyr::mutate(
            DateIssued = lubridate::ymd(.data$DateIssued),
            DateEnacted = lubridate::ymd(.data$DateEnacted),
            DateEnded = lubridate::ymd(.data$DateEnded),
            DateExpiry = lubridate::ymd(.data$DateExpiry),
            LastUpdated = lubridate::ymd(.data$LastUpdated),
            Mandate = as.logical(.data$Mandate),
            StateFIPS = integer_to_fips(.data$StateFIPS),
            StateWide = as.logical(.data$StateWide),
        ) %>%
        dplyr::rename(
            "state" = 'StateName',
            "iso2c"  = 'StatePostal'
        ) %>%
        dplyr::rename_with(tolower)
}
