#' convert an integer to fips
#'
#' @param integer vector
#'
#' @export
integer_to_fips <- function(v) {
    sprintf('%05d', v)
}
