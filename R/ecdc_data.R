#' Daily COVID-19 deaths and confirmed cases from the European CDC
#'
#'  
#' @importFrom readr read_csv
#' @importFrom dplyr rename select mutate `%>%` group_by arrange
#' @importFrom lubridate dmy
#' @importFrom tidyr pivot_longer
#' 
#' @details
#'
#' From the [ECDC website](https://www.ecdc.europa.eu/en/covid-19/data-collection)
#' last accessed April 24, 2020:
#' 
#' Since the beginning of the coronavirus pandemic, ECDC’s Epidemic
#' Intelligence team has been collecting the number of COVID-19 cases
#' and deaths, based on reports from health authorities
#' worldwide. This comprehensive and systematic process is carried out
#' on a daily basis. To insure the accuracy and reliability of the
#' data, this process is being constantly refined. This helps to
#' monitor and interpret the dynamics of the COVID-19 pandemic not
#' only in the European Union (EU), the European Economic Area (EEA),
#' but also worldwide.
#' 
#' Every day between 6.00 and 10.00 CET, a team of epidemiologists
#' screens up to 500 relevant sources to collect the latest
#' figures. The data screening is followed by ECDC’s standard epidemic
#' intelligence process for which every single data entry is validated
#' and documented in an ECDC database. An extract of this database,
#' complete with up-to-date figures and data visualisations, is then
#' shared on the ECDC website, ensuring a maximum level of
#' transparency.
#'
#' ECDC receives regular updates from EU/EEA countries through the
#' Early Warning and Response System (EWRS), The European Surveillance
#' System (TESSy), the World Health Organization (WHO) and email
#' exchanges with other international stakeholders. This information
#' is complemented by screening up to 500 sources every day to collect
#' COVID-19 figures from 196 countries. This includes websites of
#' ministries of health (43% of the total number of sources), websites
#' of public health institutes (9%), websites from other national
#' authorities (ministries of social services and welfare,
#' governments, prime minister cabinets, cabinets of ministries,
#' websites on health statistics and official response teams) (6%),
#' WHO websites and WHO situation reports (2%), and official
#' dashboards and interactive maps from national and international
#' institutions (10%). In addition, ECDC screens social media accounts
#' maintained by national authorities, for example Twitter, Facebook,
#' YouTube or Telegram accounts run by ministries of health (28%) and
#' other official sources (e.g. official media outlets) (2%). Several
#' media and social media sources are screened to gather additional
#' information which can be validated with the official sources
#' previously mentioned. Only cases and deaths reported by the
#' national and regional competent authorities from the countries and
#' territories listed are aggregated in our database.
#'
#' 
#' @author Sean Davis <seandavi@gmail.com>
#'
#'
#' 
#' @source
#' - \url{https://www.ecdc.europa.eu/en/covid-19}
#'
#' @family data-import
#'
#' @examples
#' ecdc = ecdc_data()
#' colnames(ecdc)
#' dplyr::glimpse(ecdc)
#'
#' @family data-import
#' @family case-tracking
#' 
#' @export
ecdc_data <- function() {
    fpath = s2p_cached_url('https://opendata.ecdc.europa.eu/covid19/casedistribution/csv')
    ret = readr::read_csv(fpath, col_types=readr::cols())
    ret %>%
        dplyr::rename(c(date='dateRep',
                        location_name='countriesAndTerritories',
                        iso2c='geoId',
                        iso3c='countryterritoryCode',
                        continent='continentExp',
                        confirmed='cases',
                        population_2019='popData2019')) %>%
        tidyr::pivot_longer(cols = confirmed:deaths,names_to='subset',values_to = 'count') %>%
        dplyr::select(-c(.data$day,
                         .data$month,
                         .data$year)) %>%
        dplyr::mutate(date=lubridate::dmy(.data$date)) %>%
        dplyr::group_by(.data$location_name,.data$subset) %>%
        dplyr::arrange(.data$date) %>%
        dplyr::mutate(count= cumsum(.data$count))
}
