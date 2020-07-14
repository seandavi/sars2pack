#' ACAPS government measures catalogs worldwide COVID-19 government interventions
#'
#'
#' @details
#' The #COVID19 Government Measures Dataset puts together all the measures implemented by governments worldwide in response to the Coronavirus pandemic. Data collection includes secondary data review. The researched information available falls into five categories:
#'
#' - Social distancing
#' - Movement restrictions
#' - Public health measures
#' - Social and economic measures
#' - Lockdowns
#'
#' Each category is broken down into several types of measures.
#'
#' ACAPS government measures catalogs worldwide COVID-19 government interventionsACAPS consulted government, media, United Nations, and other organisations sources.
#'
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @references
#' - \url{https://www.acaps.org/covid19-government-measures-dataset}
#'
#' @family data-import
#' @family NPI
#'
#' @examples
#' res = acaps_government_measures_data()
#' head(res)
#' colnames(res)
#' dplyr::glimpse(res)
#'
#'
#' @export
acaps_government_measures_data <- function() {
  url1 = 'https://www.acaps.org/sites/acaps/files/resources/files/acaps_covid19_government_measures_dataset_0.xlsx'
  rpath = s2p_cached_url(url1)
  readxl::read_excel(rpath,sheet=2) %>%
    dplyr::rename_all(tolower) %>%
    dplyr::mutate(entry_date = lubridate::as_date(entry_date),
                  date_implemented = lubridate::as_date(date_implemented))
}
