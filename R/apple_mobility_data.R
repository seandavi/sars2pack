#' Access Apple mobility data
#'
#' From Apple's website:
#' "Learn about COVID‑19 mobility trends in countries/regions and cities. Reports are published daily and reflect requests for directions in Apple Maps. Privacy is one of our core values, so Maps doesn’t associate your data with your Apple ID, and Apple doesn’t keep a history of where you’ve been."
#'
#'
#' @details
#'
#' The CSV file and charts on this site show a relative volume of
#' directions requests per country/region or city compared to a
#' baseline volume on January 13th, 2020.
#' 
#' We define our day as midnight-to-midnight, Pacific time. Cities
#' represent usage in greater metropolitan areas and are stably
#' defined during this period. In many countries/regions and cities,
#' relative volume has increased since January 13th, consistent with
#' normal, seasonal usage of Apple Maps. Day of week effects are
#' important to normalize as you use this data.
#' 
#' Data that is sent from users’ devices to the Maps service is
#' associated with random, rotating identifiers so Apple doesn’t have
#' a profile of your movements and searches. Apple Maps has no
#' demographic information about our users, so we can’t make any
#' statements about the representativeness of our usage against the
#' overall population.
#'
#' These data are available from a URL that changes daily. The parent
#' page is the place to check to see what is going on if there are problems.
#'
#' @references
#'
#' - https://www.apple.com/covid19/mobility
#'
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @note
#' Apple requires that all users agree to their terms of use.
#' See \url{https://www.apple.com/covid19/mobility}.
#' 
#' @examples
#' res = apple_mobility_data()
#' colnames(res)
#' head(res)
#' table(res$transportation_type)
#'
#' require(ggplot2)
#' res %>%
#'     dplyr::filter(region %in% c('Russia','New York City','Italy')) %>%
#'     mutate(date=date+1) %>%
#'     ggplot(aes(x=date)) +
#'         geom_line(aes(y=mobility_index,color=transportation_type)) +
#'         scale_x_date(date_breaks = '1 week', date_labels='%b-%d') +
#'         facet_grid(rows=vars(region)) +
#'         ggtitle('Changes in Apple Mobility Index over time')
#'
#' regs_of_interest = c('Seattle', 'New York City',
#'                      'Chicago', 'Italy',
#'                      'Russia', 'UK',
#'                      'Brazil'))
#' res %>%
#'     dplyr::filter(region %in% regs_of_interest) %>%
#'     ggplot(aes(x=date, y=region, fill=mobility_index)) +
#'         geom_tile() +
#'         facet_grid(rows=vars(transportation_type)) +
#'         ggtitle('Changes in Apple Mobility Index over time')
#' 
#' if(require(viridis)) {
#' res %>%
#'     dplyr::filter(region %in% regs_of_interest) %>%
#'     ggplot(aes(x=date, y=region, fill=mobility_index)) +
#'         geom_tile() +
#'         facet_grid(rows=vars(transportation_type)) +
#'         scale_fill_viridis() +
#'         ggtitle('Changes in Apple Mobility Index over time')
#' }
#'
#' @family data-import
#' 
#' @export
apple_mobility_data = function() {
    url = 'https://covid19-static.cdn-apple.com/covid19-mobility-data/2006HotfixDev12/v1/en-us/applemobilitytrends-2020-04-21.csv'
    rpath = s2p_cached_url(url)
    dat = readr::read_csv(rpath, col_types = cols()) %>%
        tidyr::pivot_longer(
                   cols = -c('geo_type','region','transportation_type'),
                   names_to = "date",
                   values_to = "mobility_index"
               ) %>%
        dplyr::mutate(date = lubridate::ymd(date))
    dat
}
    
