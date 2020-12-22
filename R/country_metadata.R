#' Get basic country data
#'
#' This function uses the rest api here
#' \url{https://restcountries.eu/rest/v2/all'}
#' to get country metadata. 
#' 
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @seealso \url{https://restcountries.eu/rest/v2/all}
#' 
#' @return a data.frame
#' 
#' @examples
#' cmd = country_metadata()
#' colnames(cmd)
#' sapply(cmd, class)
#'
#' head(cmd)
#' 
#' @export
country_metadata <- function() {
    resp = httr::GET('https://restcountries.eu/rest/v2/all')
    resp = httr::content(resp, type='raw')
    resp = jsonlite::fromJSON(rawToChar(resp))
    resp = tibble::as_tibble(resp)
    class(resp) = c('s2p_cmd',class(resp))
    resp
}

