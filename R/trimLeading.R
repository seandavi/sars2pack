#' trim leading repeats of a given value from a vector
#'
#' @param x vector of the same type as `value`
#' @param value value of which to remove leading repeats
#'
#' @author Charles Morefield
#' 
#' @examples
#' trim_leading_values(c(0,0,0,1,2,3))
#' trim_leading_values(c('a','a','d','e'), 'a')
#'
#' @export
trim_leading_values <- function(x, value = 0) {
    w <- which.max(cummax(x != value))
    x[seq.int(w, length(x))]
}
