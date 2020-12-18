#' Estimate the growth rate ratio
#'
#' Calculate the growth rate ratio as defined in Badr et al.
#'
#' @details
#' The Growth Rate Ratio is defined as the logarithmic rate of change
#' (number of newly reported cases)
#' over the previous Ws days relative to the logarithmic rate of change over
#' the longer Wl days. GR for any county j on a day t was calculated as follows:
#' where Cjt is the number of new cases reported in county j on a day t.
#'
#' @param v a numeric vector of new cases per day
#' @param Ws integer(1), the number of days to average for the shorter window
#' @param Wl integer(1), the number of days to average to the longer window
#' @param smooth_window integer(1), the size of the window to apply rolling mean
#'     smoothing to. The smoothing is applied *before* the summary process occurs
#'
#' @references
#' - \url{https://doi.org/10.1016/S1473-3099(20)30553-3}
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' nyt= nytimes_state_data() %>% dplyr::filter(fips=='00053' & subset=='confirmed') %>%
#'      add_incidence_column()
#'mgr = nyt %>% dplyr::pull(inc) %>% growth_rate_ratio()
#'
#' @export
growth_rate_ratio = function(v, Ws=3, Wl=7, smooth_window=7) {
  v = zoo::rollmean(v,7,na.pad=TRUE,align='right')
  threeday = log(zoo::rollmean(v,3,na.pad=TRUE, align='right'))
  sevenday = log(zoo::rollmean(v,7,na.pad=TRUE, align='right'))
  threeday/sevenday
}
