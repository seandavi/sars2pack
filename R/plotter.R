
#' generic for simpler plotter for R0.sR
#' @param x R0.sR instance
#' @param xscale character code for x axis scale
#' @param TD.split logical
#' @param \dots passed to base::plot
#' @export
plot2 = function(x, xscale="w", TD.split=FALSE, ...) UseMethod("plot2")

#' version of R0:::plot.R0.sR that does not use dev.new
#' @param x instance of R0.sR
#' @param xscale character(1) scale to be used on x axis (d = daily, w=weekly, f=fortnightly, m=monthly)
#' @param TD.split logical(1) "to force the display of both R(t) and the epidemic curve in the same window for TD method"
#' @param \dots passed to base::plot
#' @export
plot2.R0.sR = function (x, xscale = "w", TD.split = FALSE, ...) 
{
    if (class(x) != "R0.sR") {
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

