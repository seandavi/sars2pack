#' convenience function for summarizing data.frame columns
#'
#' This function takes a data.frame and returns a simple
#' summary of the columns and their content as a data.frame.
#'
#'
#' @param df a data.frame object
#' 
#' @param dates_as_char logical() whether to treat date columns
#'     as character
#'
#' @return
#' a `tibble` with two columns, `name` and `column_details`.
#' The name column is the column name. The `column_details`
#' column is a list with five elements:
#' - min: the minumum value (including for dates and character)
#' - max: the maximum value (including for dates and character)
#' - class: the class of the column
#' - sample_values: up to five randomly-sampled values
#'
#' @examples
#' data(iris)
#' cs = column_summaries(iris)
#' head(cs)
#' str(cs$column_details)
#' 
#' @export
column_summaries <- function(df, dates_as_char = TRUE) {
    .one_col = function(one) {
        cl = class(one)
        min = tryCatch(min(one, na.rm=TRUE), error=function(e) NA)
        max = tryCatch(max(one, na.rm=TRUE), error=function(e) NA)
        uniq = unique(one)
        samp = sample(uniq, min(length(uniq), 6))
        if(dates_as_char & cl == "Date") {
            min = as.character(min)
            max = as.character(max)
            samp = as.character(samp)
        }
        list(min = min, max = max, class = cl, nrows=nrow(df), sample_values = samp)
    }
    ret = lapply(df, .one_col)
    names(ret) = NULL
    ret = tibble::tibble(name = names(df), column_details = ret)
    attr(ret, 'class') = c('column_details', class(ret))
    ret
}
        
