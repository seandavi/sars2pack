#' simplify production of EG fit using eu_data_cache_data
#' @param gt output of R0::generation.time
#' @param filt an expression selecting a region, like nuts_3 == "Bergamo"
#' @param src instance of eu_data_cache_data(), which will be run if this is missing
#' @param start_date string in form yyyy-mm-dd
#' @param end_date string in form yyyy-mm-dd
#' @examples
#' gt = R0::generation.time("gamma", c(3.5, 4.8))
#' run1 = easyEG_eucache(gt, nuts_3=="Bergamo", start_date="2020-02-20", 
#'   end_date="2020-03-15")
#' plot(run1)
#' est_R0(run1)
#' low_R0(run1)
#' hi_R0(run1)
#' @export
easyEG_eucache = function(gt, filt, src, start_date, end_date) {
  if (missing(src)) src = eu_data_cache_data()
  f2 = rlang::enquo(filt)  # this allows very simple specification of limits
  dat = dplyr::filter(src, !!f2)
  if (any(duplicated(dat$date))) warning("duplicated dates")
  cum = make_cumulative_events( cases=dat$cases, dates=dat$date, 
     eventtype="confirmed", alpha3=NULL, ProvinceStateName=rlang::as_label(f2))
  inc = trim_between(form_incident_events(cum), start_date, end_date)
  R0 = .easyEG( inc, gt )
  ans = list(incid_events=inc, estimated_R0=R0, gt=gt,
     start=start_date, end=end_date, cum_events=cum)
  class(ans) = "easyEG"
  ans
}

#' plotter for easyEG run
#' @param x instance of S3 class easyEG
#' @export
plot.easyEG = function(x, y, ...) {
 opar = par(no.readonly=TRUE)
 on.exit(par(opar))
 par(mfrow=c(2,2))
 plot(x$cum_events)
 plot(x$incid_events)
 plot2(x$estimated_R0)
 plotfit2(x$estimated_R0)
}

.easyEG = function(inc, gt) {
     stopifnot(is(inc, "incident_events"))
     nt = length(inc$dates)
     R0::estimate.R( inc$count, GT=gt,
        t=inc$dates, begin=inc$dates[1], end=inc$dates[nt],
        methods="EG")
}

#' helper for easyEG, reach in to estimate structure
#' @parameter x result of R0::estimate.R
#' @export
est_R0 = function(x) {
  stopifnot(inherits(x, "easyEG"))
  x$estimated_R0$estimates$EG$R
}
#' helper for easyEG, reach in to estimate structure
#' @parameter x result of R0::estimate.R
#' @export
low_R0 = function(x) {
  stopifnot(inherits(x, "easyEG"))
  x$estimated_R0$estimates$EG$conf.int[1]
}
#' helper for easyEG, reach in to estimate structure
#' @parameter x result of R0::estimate.R
#' @export
hi_R0 = function(x) {
  stopifnot(inherits(x, "easyEG"))
  x$estimated_R0$estimates$EG$conf.int[2]
}

