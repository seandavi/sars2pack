#' Testing and tracing statistics for United States from testandtrace.com
#'
#'
#' @details
#'
#' From the testandtrace website:
#'
#' 1. Countries with successful test and trace programs have less than 3% positive tests (meaning that they have enough testing capabilities to test aggressively). [Source](https://medium.com/@tomaspueyo/coronavirus-how-to-do-testing-and-contact-tracing-bde85b64072e)
#' 2. A state needs ~5-15 contact tracers per daily positive test (contact tracers interview infected patients about who they’ve had close contact with, and then call those people to help them get tested and quarantined). [Source](https://medium.com/@tomaspueyo/coronavirus-how-to-do-testing-and-contact-tracing-bde85b64072e)
#' 
#' Suggested Grading Scale: Conducted on a 6 point scale with a 6/6 meaning that a state meets the necessary testing availability and tracing team size benchmarks to successfully test and trace.
#'
#' Testing Grades:
#' - 3 points for under 3% positive tests
#' - 2 point for 3-5.5% positive tests
#' - 1 point for 5.5-8% positive tests
#' - 0 points if over 8% positive tests
#'
#' Tracing Grades:
#' - 3 points for 5-15+ tracers per daily positive case
#' - 2 points for 2.5-5 tracers per daily positive case
#' - 1 point for 1-2.5 tracers per daily positive case
#' - 0 points for under 1 tracer per daily positive case
#'
#' @references
#' - \url{https://medium.com/@tomaspueyo/coronavirus-how-to-do-testing-and-contact-tracing-bde85b64072e}
#' - \url{https://medium.com/@tomaspueyo/coronavirus-how-to-do-testing-and-contact-tracing-bde85b64072e}
#' - \url{https://testandtrace.com/state-data/}
#'
#' @source
#' - \url{https://github.com/covid-projections/covid-data-public/blob/master/data/test-and-trace/state_data.csv}
#'
#' @family data-import
#' @family case-tracking
#' 
#' @examples
#' TAndT = test_and_trace_data()
#' head(TAndT)
#' colnames(TAndT)
#' dplyr::glimpse(TAndT)
#'
#' nyt = nytimes_state_data() %>% dplyr::select(-state) %>%
#'     dplyr::filter(subset=='confirmed') %>%
#'     add_incidence_column(grouping_columns = 'fips')
#'     
#' testers = TAndT %>%
#'     dplyr::left_join(nyt, c('fips'='fips','date'='date')) %>%
#'     dplyr::mutate(tracers_per_new_case = contact_tracers_count/inc)
#'
#' testers %>% dplyr::filter(date==Sys.Date()-4) %>%
#'     ggplot(aes(x=reorder(iso2c,tracers_per_new_case),y=tracers_per_new_case)) +
#'     geom_bar(stat='identity') +
#'     coord_flip() +
#'     xlab('State or Jurisdiction') +
#'     ylab('Contract tracers per new case') +
#'     ggtitle(sprintf('Contract tracers per new case on %s', Sys.Date() - 4), 
#'             subtitle='Goal is 5-15 tracers per new case')
#'
#' @export
test_and_trace_data <- function() {
    url = 'https://github.com/covid-projections/covid-data-public/raw/main/data/test-and-trace/state_data.csv'
    rpath = s2p_cached_url(url)
    res = data.table::fread(rpath) %>%
        dplyr::rename(iso2c='state') %>%
        dplyr::mutate(fips=integer_to_fips(.data$fips))
    .simple_states = data.frame(iso2c = datasets::state.abb,
                                state = datasets::state.name,
                                region = datasets::state.region)
    res %>% dplyr::left_join(.simple_states, c('iso2c'='iso2c'))
}
