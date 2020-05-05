#' gather US states confirmed cases from multiple sources
#'
#' This is a convenience function to combine results from
#' sources providing US state-level datasets. A primary use
#' case is to provide fodder for comparison and quality control
#' over all the available datasets.
#'
#' @family case-tracking
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' cus = combined_us_cases_data()
#' head(cus)
#' unique(cus$dataset)
#' plot_epicurve(cus, filter_expression = state == 'GA',color='dataset') +
#'     ggtitle('Cumulative confirmed cases in Georgia')
#'
#' plot_epicurve(cus, filter_expression = state == 'GA' & incidence>10,
#'     case_column='incidence', color='dataset', log=FALSE) +
#'     ggtitle('Daily confirmed cases in Georgia') + geom_smooth(alpha=0.25)
#'
#' @export
combined_us_cases_data = function() {

    jhu = jhu_us_data() %>% filter(!is.na(county) & subset=='confirmed') %>%
        mutate(fips = county_to_state_fips(fips)) %>%
        group_by(fips,date) %>% summarize(count=sum(count)) %>%
        select(date,fips,count) %>%
        add_incidence_column(incidence_col_name = 'incidence',grouping_columns = c('fips'))

    covidtracker = covidtracker_data() %>% select(date,fips,positive) %>%
        rename(count='positive') %>% 
        add_incidence_column(incidence_col_name = 'incidence',grouping_columns = c('fips'))

    nytimes = nytimes_state_data() %>% 
        filter(subset=='confirmed') %>%
        select(date,fips,count) %>%
        add_incidence_column(incidence_col_name = 'incidence',grouping_columns = c('fips'))

    fips_to_states = covidtracker_data() %>% select(state,fips) %>%
        unique()

    us_states = bind_rows(list(jhu=jhu, covidtracker= covidtracker, nytimes=nytimes),.id='dataset') %>%
        right_join(fips_to_states,by=c('fips'='fips'))

    us_states
}
