#' Add daily incidence to cumulative case counts data.frame
#'
#' For a data.frame that includes cumulative case counts over time
#' +/- extra columns for location, etc., this function adds an
#' extra column corresponding to the daily incidence counts.
#' 
#' @details
#' Multiple datasets conform to the cumulative counts form, with a
#' `date` and `count` column of cumulative cases over time. Other
#' columns may be present.
#'
#' This function summarizes by the `grouping_columns` and then
#' within each group, subtracts the previous day's counts. The result
#' is the new case count for each day.
#'
#' @param df a data.frame with at least two columns representing a `date` or
#'     at least ordered quantity and a cumulative `count` column. These
#'     types of data often arise from one of the case-count type datasets.
#'
#' @param grouping_columns character() vector with the column names to use
#'     for grouping when calculating the incidence data. See examples for
#'     details. **Be very careful to include the appropriate columns in
#'     grouping, or results will be misleading**.
#'
#' @param incidence_col_name character(1) giving the desired column name
#'     to add
#'
#' @param count_column character(1) giving the column name of the cumulative
#'     counts in the dataset
#'
#' @param data_column  character(1) giving the column name of date column
#'     in the dataset
#'
#' 
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @family epicurve
#' @seealso jhu_data(), covidtracker_data(), jhu_us_data() and others for
#'     datasets that are appropriate for passing into here. 
#'
#'
#' @examples
#' library(ggplot2)
#' library(dplyr)
#'
#' j = jhu_data()
#' head(j)
#' colnames(j)
#'
#' add_incidence_column(j, grouping_columns=c('CountryRegion','ProvinceState'))
#'
#' # get top 10 countries by cumulative
#' # number of cases
#' j_top_10 = j %>%
#'     filter(subset=='deaths') %>%
#'     dplyr::group_by(CountryRegion) %>%
#'     dplyr::summarize(count = max(count)) %>%
#'     dplyr::arrange(dplyr::desc(count)) %>%
#'     head(10)
#'
#' j_top_10
#'
#' # The JHU data divides some countries into
#' # regions, so we can collapse to regions
#' # by simply summing over date/country
#' j = j %>% filter(CountryRegion %in% j_top_10[['CountryRegion']] & subset=='deaths') %>%
#'     dplyr::group_by(date, CountryRegion) %>%
#'     dplyr::summarize(count = sum(count))
#'
#' j
#'
#' # Add an incidence column to the cumulative dataset
#' j_inc = add_incidence_column(j, grouping_columns='CountryRegion')
#'
#' j_inc
#'
#' j_inc %>%
#'     dplyr::filter(count>0) %>%
#'     plot_epicurve(color='CountryRegion', case_column='inc') +
#'         geom_smooth() +
#'         ggtitle('Daily death counts in the top 10 most infected countries')
#'
#'
#' # Hospitalizations by day in Maryland
#' covidtracker_data() %>%
#'     filter(state=='MD') %>%
#'     add_incidence_column(count_column='hospitalized') %>%
#'     ggplot(aes(x=date,y=inc)) + geom_smooth() +
#'     ylab("New Hospitalizations per day") +
#'     ggtitle('Hospitalizations in Maryland', subtitle = 'From covidtracker')
#' 
#' 
#' 
#' @export
add_incidence_column <- function(df, date_column='date', count_column='count',
                                 incidence_col_name='inc',
                                 grouping_columns = c()) {

    df1 = df %>%
        dplyr::arrange_(date_column)
    if(!(all(c(grouping_columns,date_column, count_column) %in% colnames(df)))) {
        stop('Columns in date_column, count_column, grouping_columns must be included in:\n %s',paste(colnames(df),collapse=', '))
    }
    if(length(grouping_columns)>0) {
        df1 = df1 %>% dplyr::group_by_at(grouping_columns)
    }
    df1 = df1 %>% dplyr::mutate(inc = get(count_column) - dplyr::lag(get(count_column),
                                                                     order_by = get(date_column)))
    colnames(df1)[colnames(df1)=='inc']=incidence_col_name
    df1
}
