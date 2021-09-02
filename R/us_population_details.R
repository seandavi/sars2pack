#' Retrieve United States Population data from the US Census Bureau
#'
#' Get data from the US Census Bureau Population Estimates APIs.
#'
#' @param key a us census API key. See the help for \code{\link[tidycensus]{get_estimates}}
#'   for setting up. 
#' @param \dots Passed along to \code{\link[tidycensus]{get_estimates}}. Typical 
#'   arguments would be something like `(geography='county', product='population', year=2019)`.
#' 
#' @seealso \code{link[tidycensus]{get_estimates}}
#'
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @return a `data.frame`
#'
#' @examples
#' res = us_population_details(geography='county', 
#'   product='population', year=2019)
#' head(res)
#'
#' @export
us_population_details <- function(key = Sys.getenv('CENSUS_API_KEY'), ...) {
  if(!requireNamespace("tidycensus")) {
    message("The tidycensus package is required for this ")
    message("functionality. Please install it first.")
    stop()
  }
  tidycensus::get_estimates(...)
}
