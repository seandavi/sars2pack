#' Plot a (set of) epidemic curve(s)
#' 
#' `plot_epicurve` is a simplifying wrapper around ggplot to 
#' produce curves of cumulative cases versus time. The input
#' data frame should contain at least:
#' 
#' - a date column (or any data type that has a natural time order); this will become the x-axis
#' - a cumulative `count` column; this will become the y-axis
#' 
#' @importFrom dplyr %>% group_by_ summarize filter
#' @importFrom ggplot2 ggplot aes_string geom_line scale_y_log10
#' 
#' @param df a data frame with columns that include at 
#' least a date column and an integer count column
#' @param date_column character(1) the column name of the `date` type column
#' @param case_column character(1) the column name of the `count of cases` column
#' @param log logical(1) TRUE for log10 based y-scale, FALSE for linear
#' @param ... passed to ggplot2::aes
#' 
#' @examples 
#' library(dplyr)
#' jhu = jhu_data() %>% 
#'     filter(CountryRegion=='China' & subset=='confirmed') %>% 
#'     group_by(CountryRegion,date) %>% summarize(count=sum(count)) 
#'     
#' jhu %>% plot_epicurve(log=FALSE)
#' 
#' 
#' @export
plot_epicurve <- function(df, date_column = 'date', case_column = 'count', 
                          ..., log=TRUE, shift = FALSE) {
    if(log) {
        df = df %>% dplyr::filter(count>0)
    }
    p = ggplot(df, aes_string(x=date_column, y=case_column, ...))
    p = p + geom_line()
    if(log) {
        p = p + scale_y_log10()
    }
    p
}
