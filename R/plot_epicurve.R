#' Plot a (set of) epidemic curve(s)
#' 
#' `plot_epicurve` is a simplifying wrapper around ggplot to 
#' produce curves of cumulative cases versus time. The input
#' data frame should contain at least:
#' 
#' - a date column (or any data type that has a natural time order); this will become the x-axis
#' - a cumulative `count` column; this will become the y-axis
#'
#' An additional common use case is to provide a grouping variable
#' in the data.frame; specifying `color=...` will draw group-specific
#' curves on the same plot. See examples. 
#' 
#' @importFrom dplyr %>% group_by_ summarize filter
#' @importFrom ggplot2 ggplot aes_string geom_line scale_y_log10
#' 
#' @param df a data frame with columns that include at 
#' least a date column and an integer count column
#' @param filter_expression an expression that is passed directly to `dplyr::filter()`. This 
#'     parameter is a convenience feature since the filtering could also be done easily
#'     outside this function.
#' @param date_column character(1) the column name of the `date` type column
#' @param case_column character(1) the column name of the `count of cases` column
#' @param log logical(1) TRUE for log10 based y-scale, FALSE for linear
#' @param ... passed to `ggplot2::aes_string()`, useful providing colors or
#'     line types to separate out datasets. 
#' 
#' @examples 
#' library(dplyr)
#' 
#' 
#' jhu = jhu_data() %>% 
#'     filter(CountryRegion=='China' & subset=='confirmed') %>% 
#'     group_by(CountryRegion,date) %>% summarize(count=sum(count))
#'
#' head(jhu)
#' 
#' jhu %>% plot_epicurve(log=FALSE)
#'
#' # add a title
#' library(ggplot2)
#' jhu %>% plot_epicurve() + ggtitle('Cumulative cases for China')
#'
#' # Work with testing data
#' cc = covidtracker_data() %>%
#'     dplyr::mutate(total_tests = positive+negative) %>%
#'     dplyr::filter(total_tests>0)
#' head(cc)
#'
#' plot_epicurve(cc, case_column='total_tests', color='state', log=FALSE) +
#'     ggtitle('Total tests by state') +
#'     ggplot2::theme(legend.position='bottom')
#'
#' # get tests per 100k population
#' # use the tidycensus package to get
#' # population data
#' if(require(tidycensus)) {
#'     pop = tidycensus::get_estimates(geography='state',product='population') %>%
#'         dplyr::filter(variable=='POP')
#'     head(pop)
#'     # fix GEOID column to be 5-digit fips
#'     pop$GEOID=integer_to_fips(as.integer(pop$GEOID))
#'     cc_pop = merge(cc,pop, by.x='fips', by.y='GEOID', all.x=FALSE, all.y=FALSE)
#'     cc_pop = cc_pop %>% mutate(tests_per_100k = total_tests/value * 100000)
#'     plot_epicurve(cc_pop, case_column='tests_per_100k', color='state', log=FALSE) +
#'         ggtitle('Total tests per 100,000 people') +
#'         ggplot2::theme(legend.position='bottom')
#' }
#' 
#' @family plotting
#' @family case-tracking
#' 
#' 
#' @export
plot_epicurve <- function(df,
                          filter_expression,
                          date_column = 'date', case_column = 'count', 
                          ..., log=TRUE) {
    if(log) {
        df = df[df[[case_column]]>0,]
    }
    if(!missing(filter_expression)) {
        df = df %>% dplyr::filter(!!enquo(filter_expression))
    }
    p = ggplot(df, aes_string(x=date_column, y=case_column, ...))
    p = p + geom_line()
    if(log) {
        p = p + scale_y_log10()
    }
    p
}
