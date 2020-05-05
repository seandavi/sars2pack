#' convert an integer to fips
#'
#' The Federal Information Processing Standards (fips) codes
#' are available as 5-digit, 0-padded numbers. To standardize
#' these codes for joins across datasets, one may need to convert
#' raw integers (non-0-padded) to 5-digit numeric strings. This
#' function does that.
#'
#' @references
#' List of United States FIPS codes by county: \url{https://en.wikipedia.org/wiki/List_of_United_States_FIPS_codes_by_county}.
#'
#' @param integer vector of length 1 or more
#'
#' @return
#' character vector with each member a 0-padded representation of the original
#' integer value.
#'
#' @examples
#' integer_to_fips(50)
#' class(integer_to_fips(50))
#' nchar(integer_to_fips(50))==5
#' integer_to_fips(sample(1:50000,5))
#' 
#' @export
integer_to_fips <- function(v) {
    sprintf('%05d', v)
}

#' @describeIn integer_to_fips
#' 
#' @param fips character vector of county or state-level fips (5-digit zero-padded string)
#'   to be converted
#'   
#' @details A county-level fips code can be truncated to a state fips code since the 
#'   last two digits in the county fips code are the state fips code.
#'   
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @examples 
#' sl = county_to_state_fips('00050')
#' sl
#' sl_from_cy = county_to_state_fips('12350')
#' sl_from_cy
#' sl == sl_from_cy
#' 
#' @export
county_to_state_fips = function(fips) {
    if(!is.character(fips)) {
        stop("argument should be a character vector")
    }
    if(!all(nchar(fips)==5)) {
        stop("FIPS codes should all be 5-digit character strings")
    }
    return(paste0('000',substr(fips,1,2)))
}

