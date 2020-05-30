#' produce an MCMC-based EpiEstim R[t] estimate on the 29-day series
#' @import EpiEstim
#' @import shinytoastr
#' @param aout instance of 'Arima_sars2pack' S3 class
#' @note Simply uses the tsfull and dates29 components to call EpiEstim::estimate_R
#' @examples
#' nyd = nytimes_state_data()
#' ny = Arima_by_state(nyd, state.in="New York")
#' ee = est_Rt(ny)
#' od = options()$digits
#' options(digits=3)
#' tail(ee$R)
#' options(digits=od)
#' @export
est_Rt = function(aout) {
 source(system.file("MCMCsupport/code.R", package="sars2app"))
 run_ee(aout)
}
