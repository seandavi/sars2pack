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
#' @family non-pharmaceutical-interventions
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
    rpath = s2p_cached_url('https://raw.githubusercontent.com/COVID19StatePolicy/SocialDistancing/master/data/USstatesCov19distancingpolicy.csv')
    res = readr::read_csv(rpath,col_types = cols())
    res %>% dplyr::select(-dplyr::starts_with('X')) %>%
        dplyr::mutate(
            DateIssued = lubridate::ymd(DateIssued),
            DateEnacted = lubridate::ymd(DateEnacted),
            DateEnded = lubridate::ymd(DateEnded),
            DateExpiry = lubridate::ymd(DateExpiry),
            LastUpdated = lubridate::ymd(LastUpdated),
            Mandate = as.logical(Mandate),
            StateFIPS = integer_to_fips(StateFIPS),
            StateWide = as.logical(StateWide),
            Mandate = as.logical(Mandate)
        ) %>%
        dplyr::rename(
            state = 'StateName',
            iso2c  = 'StatePostal'
        )
}
