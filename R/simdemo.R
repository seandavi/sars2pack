#' set up a simulation as demonstrated by John C Mallery
#' @import R0
#' @param gt.type character(1) `type` setting for `R0:generation.time`
#' @param gt.val numeric() `val` setting for `R0:generation.time`
#' @param epid.nb numeric(1) passed to `R0:sim.epid`
#' @param epid.length numeric(1) passed to `R0:sim.epid`
#' @param family character(1) passed to `R0:sim.epid`
#' @param R0 numeric(1) passed to `R0:sim.epid`
#' @param peak.value numeric(1) passed to `R0:sim.epid`
#' @param begin numeric(1) passed to `R0::estimate.R`
#' @param end numeric(1) passed to `R0::estimate.R`
#' @return result of `estimate.R`
#' @examples
#' \dontrun{
#' d1 = demo_simulation()
#' # plot(d1) ## note: R0:::plot.R0.sR is very peculiar and runs dev.new()
#' plotfit(d1)  # same here but seems to have simpler behavior
#' # s.a <- sensitivity.analysis(res=d1$estimates$EG, begin=1:15, end=16:30, sa.type="time")
#' }
#' @export
demo_simulation = function(gt.type = "gamma", gt.val = c(3, 1.5), begin=1, end=30,
   epid.nb=1, epid.length=30, family="poisson", R0=1.67, peak.value=500) {
# Generating an epidemic with given parameters
mGT <- R0::generation.time(type=gt.type, val=gt.val)  # "gamma", c(3,1.5))
mEpid <- R0::sim.epid(epid.nb=epid.nb, GT=mGT, epid.length=epid.length, 
      family=family, R0=R0, peak.value=peak.value)
mEpid <- mEpid[,1]  # WHY? -- Vince
# Running estimations
estimate.R(epid=mEpid, GT=mGT, methods=c("EG","ML","TD"))
}

### END OF CODE FOR PACKAGE
#> 
#> # Model estimates and goodness of fit can be plotted
#> plot(est)
#> plotfit(est)
## Sensitivity analysis for the EG estimation; influence of begin/end dates
#s.a <- sensitivity.analysis(res=est$estimates$EG, begin=1:15, end=16:30, sa.type="time")
## This sensitivity analysis can be plotted
#plot(s.a)

