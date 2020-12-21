#' generic cumulative_events generator
#' @param cases numeric vector
#' @param dates vector
#' @param eventtype character(1) should be "confirmed" or "deaths"
#' @param alpha3 character(1) country code not checked
#' @param ProvinceStateName character(1) 
#' @examples
#' ec = jhu_data()
#' ber = ec[which(ec$nuts_3 == "Bergamo"),]
#' mber = make_cumulative_events( cases = ber$cases, dates = ber$date, 
#'   eventtype = "confirmed", alpha3 = "ITA", ProvinceStateName = "Bergamo")
#' plot(mber)
#' @export
make_cumulative_events = function( cases, dates, eventtype, alpha3, ProvinceStateName) {
 stopifnot (length(cases) == length(dates))
 ans = list(count=cases, dates=dates)
 attr(ans, "alpha3") = alpha3
 attr(ans, "ProvinceState") = ProvinceStateName
 attr(ans, "dtype") = eventtype
 class(ans) = c("cumulative_events", "covid_events")
 ans
}

