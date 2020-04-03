#' create cumulative_events instance for state data from NYT
#' @param src a tibble
#' @param eventtype character(1) 'confirmed' or 'deaths'
#' @param statename character(1) state name
#' @examples
#' nyt = nytimes_state_data()
#' mass = cumulative_events_nyt_state(nyt, eventtype = "confirmed",
#'    statename = "Massachusetts")
#' mass
#' imass = form_incident_events(trim_from(mass, "2020-03-01"))
#' plot(imass)
#' @export
cumulative_events_nyt_state = function (src, eventtype = "confirmed", 
      statename = "Massachusetts") {
    stopifnot(statename %in% src$state)
    cur = src %>% dplyr::filter(subset == eventtype & state == statename)
    cumul = cur$count
    dates = cur$date
    ans = list(count = cumul, dates = dates)
    attr(ans, "ProvinceState") = statename
    attr(ans, "source") = "NYT"
    attr(ans, "dtype") = "cumulative"
    class(ans) = c("cumulative_events", "covid_events")
    ans
}
