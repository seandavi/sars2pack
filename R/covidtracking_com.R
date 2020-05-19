.covidtracker_cols_to_keep = c(
    "date",
    "state",
    "positive",
    "negative",
    "pending",
    "hospitalized",
    "death",
    "dateChecked",
    "fips"
)
#' US State-level data including test results
#'
#' Get data from the COVID tracking project
#' \url{https://covidtracking.com/} including daily historical data on
#' testing results, hospitalizations, and deaths.
#'
#' @details
#'
#' From the COVID Tracking Project website:
#'
#' The COVID Tracking Project collects information from 50 US states,
#' the District of Columbia, and 5 other US territories to provide the
#' most comprehensive testing data we can collect for the novel
#' coronavirus, SARS-CoV-2. We attempt to report positive and negative
#' results, pending tests, and total people tested for each state or
#' district currently reporting that data.
#'
#' @seealso
#' - \url{https://covidtracking.com/about-tracker/}
#' - \url{https://covidtracking.com/notes/}
#' 
#' @importFrom readr read_csv cols
#' @importFrom dplyr select
#'
#' @return A tidy `tbl_df`
#'
#' @examples
#' library(dplyr)
#' library(ggplot2)
#' 
#' res = covidtracker_data()
#' colnames(res)
#' dim(res)
#' dplyr::glimpse(res)
#'
#' # Hospitalizations by day in Maryland
#' covidtracker_data() %>%
#'     dplyr::filter(state=='MD') %>%
#'     add_incidence_column(count_column='hospitalized') %>%
#'     ggplot(aes(x=date,y=inc)) + geom_smooth() +
#'     ylab("New Hospitalizations per day") +
#'     ggtitle('Hospitalizations in Maryland', subtitle = 'From covidtracker')
#' 
#'
#' @family data-import
#' @family case-tracking
#' 
#' @export
covidtracker_data <- function() {
    rpath = 'http://covidtracking.com/api/v1/states/daily.csv'
    fname = s2p_cached_url(rpath)
    res = readr::read_csv(fname, col_types=cols())
    ret = res %>%
        ## this little trick lets us use a vector
        ## of names in select statement.
        dplyr::select(.covidtracker_cols_to_keep)
    ret$date = lubridate::as_date(as.character(res$date))
    coltypes = sapply(ret,class)
    ret[,coltypes=='numeric'] = lapply(ret[,coltypes=='numeric'],as.integer)
    ret$fips = integer_to_fips(as.numeric(ret$fips))
    ret
}
