get_region = function(x) UseMethod("get_region")
get_region.covid_events = function(x) {
  al3 = attr(x, "alpha3")
  provst = attr(x, "ProvinceState")
  reg = NULL
  if (!isTRUE(is.na(provst)) & !is.null(provst) & !is.null(al3)) reg = paste(provst, al3, sep=" ")
  else if (!isTRUE(is.na(provst)) & !is.null(provst)) reg = provst
  else if (!is.null(al3)) reg = al3
  if (is.null(reg)) region_name = "missing"
  reg
}

#' print for a covid_events instance
#' @param x covid_events instance
#' @param \dots not used
#' @export
print.covid_events = function(x, ...)  {
 region_name = get_region(x)
 cat(sprintf("%s event data for %s, %s to %s", attr(x, "dtype"),
   region_name, min(x$dates), max(x$dates)), "\n")
 cat("use plot() to visualize.\n")
}

#' trim early part of series, generic
#' @param x covid_events instance
#' @param date string representing date in yyyy-mm-dd form
#' @export
trim_from = function(x, date) UseMethod("trim_from")

#' trim part of series, generic
#' @param x covid_events instance
#' @param date1 string representing date in yyyy-mm-dd form
#' @param date2 string representing date in yyyy-mm-dd form
#' @export
trim_between = function(x, date1, date2) UseMethod("trim_between")

#' trim early part of series
#' @param x covid_events instance
#' @param date string representing date in yyyy-mm-dd form
#' @export
trim_from.covid_events = function(x, date = "2020-02-15") {
  st = lubridate::as_date(date)
  ok = which(x$dates >= st)
  x$dates = x$dates[ok]
  x$count = x$count[ok]
  x
}

#' focus on segment of series delimited by two dates
#' @param x covid_events instance
#' @param date1 string representing date in yyyy-mm-dd form
#' @param date2 string representing date in yyyy-mm-dd form
#' @export
trim_between.covid_events = function(x, date1 = "2020-02-15", date2="2020-03-15") {
  st = lubridate::as_date(date1)
  en = lubridate::as_date(date2)
  ok = which(x$dates >= st & x$dates <= en)
  x$dates = x$dates[ok]
  x$count = x$count[ok]
  x
}

# not clear why plot method not getting emitted by devtools::document NAMESPACE building

#' plot for covid_events
#' @rawNamespace S3method(plot,covid_events)  
#' @param x covid_events instance
#' @param main defaults to NULL, can be character(1)
#' @param ylab defaults to NULL, can be character(1)
#' @param xlab defaults to NULL, can be character(1)
#' @param \dots not used
#' @export
plot.covid_events = function (x, main=NULL, ylab=NULL, xlab=NULL,  ...) {
  region_name = get_region(x)
  if (is.null(main)) main = paste0(attr(x, "dtype"), 
            " events for ", region_name)
  if (is.null(ylab)) ylab = paste0(attr(x, "dtype"))
  if (is.null(xlab)) xlab = "Date"
  plot(x$dates, x$count, main=main, ylab=ylab, xlab=xlab, ...)
}

#' constructor for covid_events
#' @param src as retrieved with enhanced_jhu_data
#' @param eventtype character(1) 'confirmed' or 'deaths'
#' @param alpha3 character(1) code for country
#' @param ProvinceStateName character(1) for province, default to NULL; use NA for multiregion like GBR
#' @examples
#' dat = enriched_jhu_data()
#' cchn = cumulative_events_ejhu(dat, alpha3="CHN", ProvinceStateName="Hubei")
#' ichn = form_incident_events(cchn)
#' plot(cchn$count[-1], ichn$count, log="xy", xlab="cumulative", ylab="new", 
#'  main="Hubei province") # like https://youtu.be/54XLXg4fYsc
#' @export
cumulative_events_ejhu = function(src, eventtype = "confirmed", 
   alpha3="USA", ProvinceStateName=NULL) {
 cur = src %>% filter(subset == eventtype &
                alpha3Code == alpha3 )
 if (!is.null(ProvinceStateName) & !isTRUE(is.na(ProvinceStateName))) # i.e. not multiprovince like GBR
   cur = cur %>% filter(ProvinceState == ProvinceStateName)
 if (isTRUE(is.na(ProvinceStateName))) cur = cur %>% filter(isTRUE(is.na(ProvinceState)))
 cumul = cur$count
 dates = cur$date
 ans = list(count=cumul, dates=dates)
 attr(ans, "alpha3") = alpha3
 attr(ans, "ProvinceState") = ProvinceStateName
 attr(ans, "dtype") = "cumulative"
 class(ans) = c("cumulative_events", "covid_events")
 ans
}

#' transform cumulative data to daily incidence
#' @param cum cumulative events instance
#' @examples
#' suppressWarnings({dat = enriched_jhu_data()})
#' cusa = cumulative_events_ejhu(dat, eventtype="confirmed",
#'  alpha3="USA")
#' cusa
#' cusa = trim_from(cusa, "2020-03-01")
#' iusa = form_incident_events(cusa)
#' plot(iusa)
#' gt = R0::generation.time("gamma", c(3.5, 4.8))
#' est1 = R0::estimate.R( iusa$count, GT=gt,
#'    t=iusa$dates, begin=iusa$dates[1], end=iusa$dates[length(iusa$dates)],
#'    methods="EG")
#' est1
#' plot2(est1)
#' plotfit2(est1)
#' @export
form_incident_events = function(cum) {
 stopifnot(inherits(cum, "cumulative_events"))
 ans = list(count=diff(cum$count), dates=cum$dates[-1])
 attributes(ans) = attributes(cum)
 attr(ans, "dtype") = "incident"
 class(ans) = c("incident_events", "covid_events")
 ans
}
