
#' generic for simpler plotter for R0.sR
#' @param x R0.sR instance
#' @param xscale character code for x axis scale
#' @param TD.split logical
#' @param \dots passed to base::plot
#' 
#' @return none, used for side effects
#' 
#' @export
plot2 = function(x, xscale="w", TD.split=FALSE, ...) UseMethod("plot2")

#' version of R0:::plot.R0.sR that does not use dev.new
#' @param x instance of R0.sR
#' @param xscale character(1) scale to be used on x axis (d = daily, w=weekly, f=fortnightly, m=monthly)
#' @param TD.split logical(1) "to force the display of both R(t) and the epidemic curve in the same window for TD method"
#' @param \dots passed to base::plot
#' 
#' @return none, used for side effects
#' 
#' @export
plot2.R0.sR = function (x, xscale = "w", TD.split = FALSE, ...) 
{
    if (!is(x,"R0.sR")) {
        stop("'x' must be of class 'R0.sR'")
    }
    if (xscale != "d" & xscale != "w" & xscale != "f" & xscale != 
        "m") {
        stop("Invalid scale parameter.")
    }
    if (exists("EG", where = x$estimates)) {
        plot(x$estimates$EG, xscale = xscale, ...)
    }
    if (exists("ML", where = x$estimates)) {
        plot(x$estimates$ML, xscale = xscale, ...)
    }
    if (exists("AR", where = x$estimates)) {
        plot(x$estimates$AR, xscale = xscale, ...)
    }
    if (exists("TD", where = x$estimates)) {
        plot(x$estimates$TD, xscale = xscale, TD.split = TD.split, 
            ...)
    }
    if (exists("SB", where = x$estimates)) {
        plot(x$estimates$SB, xscale = xscale, ...)
    }
}

#' generic for simpler plotter for plotfit for R0.sR
#' @param x R0.sR instance
#' @param all logical(1)
#' @param xscale character code for x axis scale
#' @param SB.dist logical(1)
#' @param \dots passed to base::plot
#' 
#' @return none, used for side effects
#' 
#' @export
plotfit2 = function(x, all=TRUE, xscale="w", SB.dist=TRUE, ...) UseMethod("plotfit2")

#' version of R0:::plotfit.R0.sR that does not use dev.new
#' @param x instance of R0.sR
#' @param all logical(1)
#' @param xscale character(1) scale to be used on x axis (d = daily, w=weekly, f=fortnightly, m=monthly)
#' @param SB.dist logical(1)
#' @param \dots passed to base::plot
#' 
#' @return none, used for side effects
#' 
#' @export
plotfit2.R0.sR = function (x, all = TRUE, xscale = "w", SB.dist = TRUE, ...) 
{
    if (!is(x,"R0.sR")) {
        stop("'x' must be of class 'sR'")
    }
    if (xscale != "d" & xscale != "w" & xscale != "f" & xscale != 
        "m") {
        stop("Invalid scale parameter.")
    }
    if (exists("EG", where = x$estimates)) {
        plotfit(x$estimates$EG, xscale = xscale, ...)
    }
    if (exists("ML", where = x$estimates)) {
        plotfit(x$estimates$ML, xscale = xscale, ...)
    }
    if (exists("TD", where = x$estimates)) {
        plotfit(x$estimates$TD, xscale = xscale, ...)
    }
    if (exists("SB", where = x$estimates)) {
        plotfit(x$estimates$SB, xscale = xscale, SB.dist = SB.dist, 
            ...)
    }
}

fix_slash_dates = function(x) gsub("/", "-", x) # ok if they are already non-slash

#' supersimple series extraction
#' @importFrom magrittr "%>%"
#' @param province character(1) must be found in dataset ProvinceState field, "" is typical for data aggregated only at country level, and that is the default
#' @param country character(1) must be found in CountryRegion field
#' @param dataset data.frame as returned by jhu_data()
#'
#' @return
#' A `data.frame` with two columns
#' 
#' @export
get_series = function(province="", country,
                      dataset=try(jhu_data())) { #sars2pack::mar19df) {
  if (inherits(dataset, "try-error")) stop("could not get data from jhu_data()")
  stopifnot(all(c("ProvinceState", "CountryRegion") %in% colnames(dataset)))
  stopifnot(country %in% dataset$CountryRegion)
  ans = dataset %>% dplyr::filter(.data$CountryRegion==country)
  if(!is.na(province)) {
      ans = ans %>% dplyr::filter(.data$ProvinceState==province)
  }
  ans[,-c(1,2,3,4)]
}

#' supersimple series plotter
#' @importFrom lubridate as_date mdy
#' @param province character(1) must be found in dataset ProvinceState field, "" is typical for data aggregated only at country level, and that is the default
#' @param country character(1) must be found in CountryRegion field
#' @param dataset data.frame as returned by fetch_JHU_Data
#' @param \dots passed to base::plot
#' 
#' @return none, used for side effects
#' 
#' @note An effort is made to change dates used as column names to lubridate date objects
#' that are respected in plotting.
#' @examples
#' #plot_series(country="Italy")
#' @export
plot_series = function(province="", country, dataset=try(jhu_data()), ...) {
 if (inherits(dataset, "try-error")) stop("could not get data from fetch_JHU_Data()")
 ser = get_series(province=province, country=country, dataset=dataset)
 dates = lubridate::as_date(mdy(fix_slash_dates(names(dataset)[-c(1,2,3,4)])))
 plot(dates, ser, main=paste(province, country), ...)
}



#' estimate R0
#'
#' @param x a data.frame with incidences
#'
#' @return a data.frame
#'
#' @export
estimate_R <- function(x, ...) UseMethod('estimate_R', x)

#' @export
estimate_R.data.frame <- function(x, ...) {
    x = x %>% group_by(date) %>%
        summarise(count = sum(count)) %>%
        arrange(date)
    res = trim_leading_values(c(x$count[1],diff(x$count)))
    res[res<0]=0
    dates = x$date[(nrow(x) -  length(res)):nrow(x)]
    return(estimate.R(epid = res, ...))
}
