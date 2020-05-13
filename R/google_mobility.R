#' Google mobility dataset
#'
#' From the Google website: These Community Mobility Reports aim to
#' provide insights into what has changed in response to policies
#' aimed at combating COVID-19. The reports chart movement trends over
#' time by geography, across different categories of places such as
#' retail and recreation, groceries and pharmacies, parks, transit
#' stations, workplaces, and residential.
#'
#' @importFrom tidyr pivot_longer
#' @importFrom readr read_csv
#' @importFrom dplyr mutate rename ends_with
#'
#' @param accept_terms default is TRUE, but please make sure that you
#'     and any downstream users are aware that they are accepting
#'     Google's terms of service. See the note below.
#' 
#' @details
#'
#' From Google:
#' 
#' What’s a Community Mobility Report?
#'
#' Each Community Mobility Report is broken down by location and
#' displays the percent change from baseline in visits to places like
#' grocery stores and parks.
#'
#'
#' @section Privacy:
#'
#' Google provides this explanation with regard to preserving privacy:
#'
#' The Community Mobility Reports were developed to be helpful while
#' adhering to our stringent privacy protocols and protecting people’s
#' privacy. No personally identifiable information, such as an
#' individual’s location, contacts or movement, will be made available
#' at any point.
#' 
#' Insights in these reports are created with aggregated, anonymized
#' sets of data from users who have turned on the Location History
#' setting, which is off by default. People who have Location History
#' turned on can choose to turn it off at any time from their Google
#' Account and can always delete Location History data directly from
#' their Timeline.
#' 
#' We also use the same world-class anonymization technology used in
#' our products every day to keep your activity data private and
#' secure. This includes differential privacy, which adds artificial
#' noise to our datasets, enabling us to generate insights while
#' preventing the identification of any individual person.
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @source
#' - \url{https://www.google.com/covid19/mobility/}
#'
#' @note
#' Using this function implies that you agree to the Google terms of service:
#' \url{https://policies.google.com/terms}
#'
#'
#' @family data-import
#' @family mobility
#'
#' @examples
#'
#' res = google_mobility_data()
#' colnames(res)
#' head(res)
#' dplyr::glimpse(res)
#'
#' # analyze the "admin levels" available for each
#' # country:
#'
#' admin_by_country = res %>%
#'     dplyr::group_by(iso2c) %>%
#'     dplyr::filter(date == max(date))
#' admin_by_country = table(admin_by_country$admin_level, admin_by_country$iso2c)/length(unique(res$places_category))
#' admin_by_country
#'
#' # Italy mobility over time
#' # Note day-of week effect in plot
#'
#' library(ggplot2)
#' 
#' res %>%
#' ## Italy, whole country(admin == 0)
#'     dplyr::filter(iso2c == "IT" & admin_level==0) %>%
#'     ggplot(aes(x=date,y=percent_change_from_baseline,color = places_category)) +
#'     geom_line() +
#'     ggtitle('Google mobility metric for Italy') +
#'     theme(legend.position='bottom')
#'
#' 
#' @export
google_mobility_data <- function(accept_terms = TRUE) {
    rpath = s2p_cached_url('https://www.gstatic.com/covid19/mobility/Global_Mobility_Report.csv')
    .admin_level = function(admin1, admin2) {
        admin_level=rep(0,length(admin1))
        admin_level[!is.na(admin1)] = 1
        admin_level[!is.na(admin2)] = 2
        admin_level
    }
    dat = readr::read_csv(rpath, col_types = cols(), guess_max=200000)
    dat %>%
        dplyr::rename(iso2c = .data$country_region_code,
                      admin1 = .data$sub_region_1,
                      admin2 = .data$sub_region_2) %>%
        dplyr::mutate(admin_level = .admin_level(.data$admin1, .data$admin2)) %>%
        tidyr::pivot_longer(cols = dplyr::ends_with('_percent_change_from_baseline'), values_to = 'percent_change_from_baseline', names_to = 'places_category') %>%
        dplyr::mutate(places_category = sub('_percent_change_from_baseline','', .data$places_category))

}
    
