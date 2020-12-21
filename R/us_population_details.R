#' Retrieve United States Population data from the US Census Bureau
#'
#' Get data from the US Census Bureau Population Estimates APIs.
#'
#' @param \dots Passed along to \code{\link[tidycensus]{get_estimates}}.
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' res = us_population_details(geometry='state',year=2019)
#' head(res)
#'
#' @export
us_population_details <- function(...) {
  if(!requireNamespace("tidycensus")) {
    message("The tidycensus package is required for this ")
    message("functionality. Please install it first.")
    stop()
  }
  tidycensus::get_estimates(...)
}
