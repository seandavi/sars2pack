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
    resp = as_tibble(resp)
    class(resp) = c('s2p_cmd',class(resp)) 
}

#' utility function to remove columns that contain `data.frame` type
#'
#' The dplyr::bind_rows function does not work with
#' `data.frame` columns, so simply remove them as needed.
#'
.remove_df_columns <- function(df) {
    df_cols = which(sapply(df, class)=='data.frame')
    df[, -c(df_cols)]
}


names_match_df <- function(countries, df, by.df = 'CountryRegion') {
    df[[by.df]][df[[by.df]]=='US'] = 'United States of America'
    df[[by.df]][df[[by.df]]=="United Kingdom of Great Britain and Northern Ireland"] = 'United Kingdom'
    countries$name[grep('Tanzania',countries$name)]='Tanzania'
    countries$name[grep('Great Britain and Northern Ireland',countries$name)]='United Kingdom'

                                        # fix Czechia
                                        # fix Brunei/Burundi
                                        # fix Swaziland/Eswatini
                                        # fix Kosovo/Comoros
                                        # double-check congo
                                        # fix Hong Kong/United Kingdom
                                        # fix maldova/maldives
    
    
    z = countries %>%
        tidyr::unnest(altSpellings) %>%
        dplyr::filter(nchar(altSpellings)>4)
    countries$altSpellings = countries$name
    countries = .remove_df_columns(countries)
    z = .remove_df_columns(z)
    z = dplyr::bind_rows(countries, z)
    z_index = sapply(df[[by.df]],function(name) {
        which.min(stringdist(name,z$altSpellings))
    })
    cbind(z[z_index,],df)
}

