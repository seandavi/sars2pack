#' obtain input to rmeta meta.summaries, metaplot
#' @import rmeta
#' @param nyd tibble, data source assumed to be nytimes_state_data()
#' @param opt_parms list, such as that produced by `min_bic_all_states()`
#' @param \dots passed to `Arima_by_state`
#' @examples
#' \dontrun{
#' nyd = nytimes_state_data()
#' data(min_bic_2020_05_20)
#' m1 = run_meta(nyd, opt_parms=min_bic_2020_05_20)
#' rmeta::meta.summaries(m1$drifts, m1$se.drifts)
#' names(m1$drifts) = gsub(".drift", "", names(m1$drifts))
#' nyind = which(names(m1$drifts) %in% c("New York", "New Jersey"))
#' rmeta::meta.summaries(m1$drifts[-nyind], m1$se.drifts[-nyind])
#' o = order(m1$drifts)
#' rmeta::metaplot(m1$drifts[o], m1$se.drifts[o], labels=names(m1$drifts)[o], cex=.7, 
#'   xlab="Infection velocity (CHANGE in number of confirmed cases/day)", ylab="State")
#' segments(rep(-350,46), seq(-49,-4), rep(-50,46), seq(-49,-4), lty=3, col="gray")
#' }
#' @export
run_meta = function(nyd, opt_parms, ...) {
 allst = contig_states_dc()
 allarima = lapply(allst, function(x) {
   parms = opt_parms[[x]]
   Arima_by_state(nyd, x, ARorder=parms$opt["ARord"], MAorder=parms$opt["MAord"], ...)
   })
 names(allarima) = allst
 drifts = sapply(allarima, function(x) coef(x$fit)["drift"])
 searima = function(a) sqrt(a$fit$var.coef["drift", "drift"])
 se.drifts = sapply(allarima, searima)
 list(drifts=drifts, se.drifts=se.drifts)
}

