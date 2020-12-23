#' Global case tracking from the World Health Organization (WHO)
#'
#' Each row of data reports cumulative counts based on best reporting
#' up to the moment published. Cases and deaths are reported for all
#' affected countries.
#'
#' @source
#'   - \url{https://covid19.who.int/}
#'   - \url{https://covid19.who.int/WHO-COVID-19-global-data.csv}
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @family data-import
#' @family case-tracking
#'
#' @examples
#'
#' res = who_cases()
#' colnames(res)
#' dplyr::glimpse(res)
#'
#'
#'
#' @export
who_cases <- function() {
  data.table::fread(s2p_cached_url('https://covid19.who.int/WHO-COVID-19-global-data.csv')) %>%
    dplyr::select(-c("New_cases", "New_deaths")) %>%
    dplyr::rename(date='Date_reported',
                  country='Country',
                  iso2c = 'Country_code',
                  who_region = "WHO_region",
                  confirmed = "Cumulative_cases",
                  deaths = "Cumulative_deaths") %>%
    tidyr::pivot_longer(cols = "confirmed":"deaths",
                        names_to = 'subset',
                        values_to = 'count')

}
