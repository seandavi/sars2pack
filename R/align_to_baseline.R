#' Align case tracking locations (for example) to a common baseline
#'
#' When endeavoring to compare epidemic curves (cases vs date, for
#' example), particularly when making graphical displays, it is helpful
#' to set a "time baseline" that aligns where all the curves start.
#'
#' @details
#' This function takes this basic approach:
#'
#' 1. Filter all all data using the `filter_criteria`, expressed as a
#'    `dplyr::filter()` expression.
#' 2. Optionally group the dataset.
#' 3. Find the minimum date left after applying the filter criteria
#' 4. "Subtract" the minimum date (on a per group basis if grouping
#'    columns are used).
#'
#' The result is a plot that shifts all the curves to start at the "same"
#' starting time with respect to the "start" of the pandemic. For example,
#' for the COVID-19 pandemic, China started much earlier than the rest of
#' the world. To compare the time course of China versus other countries,
#' setting the time to the point where each country had 100 cases allows
#' direct comparison of the shapes of the countries' curves.
#'
#' @param df data.frame that includes a date column and at least one other column
#'     for filtering, typically a case count.
#'
#' @param filter_criteria an expression as would normally be specified
#'     directly to `dplyr::filter()`.
#'
#' @param date_column character(1) column name of the column for ordering
#'     the data to define a "beginning" of the curve. It is called a
#'     "date column", but anything with a natural ordering will likely work.
#'
#' @param group_vars optional character() column_name(s) that specify
#'     grouping done before calculating minimum `date`s. Concretely,
#'     if the goal is to compare several countries, then the group_vars='country'
#'     with a column in `df` called `country`.
#'
#' @return
#' A data.frame with a new column, `index`, that gives the
#' number of time intervals (typically days) from when the
#' baseline counts are first encountered, done by group.
#'
#' @family case-tracking
#' @family plotting
#' 
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' library(dplyr)
#' library(ggplot2)
#'
#' # use European CDC dataset
#' ecdc = ecdc_data()
#' head(ecdc)
#' dplyr::glimpse(ecdc)
#'
#' # get top 10 countries by cumulative
#' # number of deaths
#' top_10 = ecdc %>%
#'     filter(subset=='deaths') %>%
#'     dplyr::group_by(location_name) %>%
#'     dplyr::summarize(count = max(count)) %>%
#'     dplyr::arrange(dplyr::desc(count)) %>%
#'     head(10)
#'
#' top_10
#'
#' # limit ecdc data to "deaths" and
#' # top 10 countries
#'
#' ecdc_top10 = ecdc %>%
#'     dplyr::filter(subset=='deaths' & location_name %in% top_10[['location_name']])
#' plot_epicurve(ecdc_top10, color='location_name')
#'
#' ecdc_top10_baseline = align_to_baseline(ecdc_top10, count>100, group_vars='location_name')
#' 
#' plot_epicurve(ecdc_top10_baseline, date_column='index', color='location_name') +
#'     ggtitle('Deaths over time, aligned to date of 100 deaths per country') 
#' 
#' @export
align_to_baseline <- function(df, filter_criteria, date_column='date', group_vars) {
    filter_criteria = enquo(filter_criteria)
    date_column = sym(date_column)
    
    df1 = df %>% filter(!!filter_criteria)
    if(!is.null(group_vars)) {
        grouping = syms(group_vars)
        df1 = df1 %>% group_by(!!!grouping)
    }
    df1 %>% mutate(index = as.integer(!!date_column - min(!!date_column)))
}
