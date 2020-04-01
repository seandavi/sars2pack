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
#' @importFrom readr read_csv
#' @importFrom dplyr select_
#'
#' @return A tidy `tbl_df`
#'
#' @examples
#' covidtracker_data()
#'
#' @family data-import 
#' 
#' @export
covidtracker_data <- function() {
    res = readr::read_csv('http://covidtracking.com/api/states/daily.csv')
    ret = res %>%
        ## this little trick lets us use a vector
        ## of names in select statement.
        dplyr::select_(quote(.covidtracker_cols_to_keep))
    ret$date = lubridate::as_date(as.character(res$date))
    ret$fips = integer_to_fips(as.numeric(ret$fips))
    ret
}
