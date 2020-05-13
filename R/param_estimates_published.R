#' Published parameter estimates from the literature
#'
#' Published estimates of epidemiological characteristics from both
#' peer-reviewed and non-peer-reviewed resources, encoded by community
#' members and approved by authors. For complete information on each
#' estimate, see the actual dataset items.
#'
#' @importFrom readr read_csv
#' 
#' @source
#' - \url{https://github.com/midas-network/COVID-19/blob/master/parameter_estimates/2019_novel_coronavirus/estimates.csv}
#'
#' @references
#' - \url{https://midasnetwork.us/covid-19/}
#'
#' @family data-import
#'
#' @examples
#' library(dplyr)
#' params = param_estimates_published()
#' colnames(params)
#' head(params)
#' dplyr::glimpse(params)
#'
#' summary(params)
#' 
#' if(require(DT) & interactive()) {
#'     datatable(params)
#' }
#' 
#' @export
param_estimates_published <- function() {
    url = 'https://raw.githubusercontent.com/midas-network/COVID-19/master/parameter_estimates/2019_novel_coronavirus/estimates.csv'
    rpath = s2p_cached_url(url)
    dat = readr::read_csv(rpath, col_types = cols(), na=c('','Unspecified','NA'))
    dat
}
