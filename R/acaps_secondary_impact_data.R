#' ACAPS secondary effects of COVID-19
#' 
#' The objective of the dataset is to provide information for decision makers to improve their efforts in addressing the wider effects of the COVID-19 pandemic.
#' 
#' @details
#' 
#' The ACAPS COVID-19 Analytical Framework, together with the data collected for the Government Measures dataset, provided the foundation for the Secondary Impacts Analytical Framework and dataset. The dataset will track secondary impacts across a wide range of relevant themes such as economy, health, migration and education.
#' 
#' Around 80 impact indicators, anticipated to be impacted by COVID-19, have been identified and organised across 4 pillars and 13 thematic blocks. 
#' 
#' The data collection is ongoing and will be conducted on a country-level. Eventually, data will identify the secondary impacts of the COVID-19 pandemic in more than 190 countries. Data comes from a range of available sources including international organisations, research centres and media analysis.
#' 
#' The data collection is supported by a group of student volunteers from various universities worldwide. Volunteers receive training on the analytical framework and indicators to ensure coherent data. Additional guidance on analytical and data collection techniques are also provided by an ACAPS analyst team which supervises the data entered. This model has already been successfully implemented in the ACAPS Government Measures project.
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @return a data.frame
#' 
#' @references 
#' - https://www.acaps.org/secondary-impacts-covid-19
#' 
#' @family data-import
#' @family economics
#' @family social
#' 
#' @examples 
#' 
#' res = acaps_secondary_impact_data()
#' 
#' head(res)
#' dplyr::glimpse(res)
#' dim(res)
#' 
#' @export
acaps_secondary_impact_data = function() {
  url = 'https://www.acaps.org/sites/acaps/files/resources/files/acaps_covid19_secondary_impacts_beta.xlsx'
  rpath = s2p_cached_url(url)
  dat = readxl::read_excel(rpath) %>%
    dplyr::rename_with(function(z) gsub(" ", "_", tolower(z))) %>%
    dplyr::mutate(date=lubridate::dmy(.data$source_date,quiet = TRUE))
  dat
}

