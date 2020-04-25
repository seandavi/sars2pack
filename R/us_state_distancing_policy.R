#' United States social distancing policies for COVID-19
#' 
#' An updated, curated set of social distancing and non-pharmaceutical interventions
#' for a subset of the states in the United States.
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
#' 
#' @examples 
#' res = us_state_distancing_policy()
#' colnames(res)
#' library(dplyr)
#' dplyr::glimpse(res)
#' 
#' @export
us_state_distancing_policy = function() {
    rpath = s2p_cached_url('https://raw.githubusercontent.com/COVID19StatePolicy/SocialDistancing/master/data/USstatesCov19distancingpolicy.csv')
    res = readr::read_csv(rpath,col_types = cols())
    res %>% dplyr::select(-dplyr::starts_with('X'))
}
