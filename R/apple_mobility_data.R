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
#' @param agree_to_terms logical, when TRUE, implies that the user
#'     has agreed to Apple's terms of use. See references and note.
#' @param max_tries integer, the number of tries to attempt downloading
#' @param message_url logical, output a message with the URL for the day
#'     since Apple changes it daily.
#' 
#' @references
#'
#' - \url{https://www.apple.com/covid19/mobility}
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @importFrom RSelenium rsDriver
#' @importFrom readr read_csv
#' @importFrom wdman phantomjs
#' @importFrom dplyr `%>%` mutate
#' @importFrom tidyr pivot_longer
#' 
#' @note
#' Apple requires that all users agree to their terms of use.
#' See \url{https://www.apple.com/covid19/mobility}.
#' 
#' @examples
#' 
#' res = apple_mobility_data()
#' colnames(res)
#' head(res)
#' table(res$transportation_type)
#'
#' require(ggplot2)
#' 
#' pl = res %>%
#'     dplyr::filter(region %in% c('Russia','New York City','Italy')) %>%
#'     ggplot(aes(x=date)) +
#'         geom_line(aes(y=mobility_index,color=transportation_type)) +
#'         scale_x_date(date_breaks = '1 week', date_labels='%b-%d') +
#'         facet_grid(rows=vars(region)) +
#'         ggtitle('Changes in Apple Mobility Index over time')
#' pl
#' 
#' regs_of_interest = c('Seattle', 'New York City',
#'                      'Chicago', 'Italy',
#'                      'Russia', 'UK',
#'                      'Brazil')
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
#' if(require(plotly)) {
#'     ggplotly(pl)
#' }
#'
#' 
#' @family data-import
#' @family mobility
#' 
#' @export
apple_mobility_data = function(agree_to_terms=TRUE, max_tries=3,
                               message_url=FALSE) {
    ## apple uses javascript to change the download
    ## URL every day to force users to examine terms
    ## The code below uses webdriver to render the
    ##
    stopifnot(agree_to_terms)
    #pjs = RSelenium::phantom(port = 4444L)
    # wait for phantomjs server to start
                                        # Sys.sleep(5)
    rD <- wdman::phantomjs(verbose = FALSE)
    Sys.sleep(4)
    remDr = RSelenium::remoteDriver(port=4567L,
        browserName='phantomjs',remoteServerAddr='localhost')
    remDr$open(silent = TRUE)
    dat = NULL
    tries = 1
    ## Error handling for download--apple seems to need this sometimes
    while(is.null(dat) & tries<max_tries) {
        remDr$navigate("https://www.apple.com/covid19/mobility")
        download_elem = remDr$findElement("css selector", 'div.download-button-container a')
        dat = try({
            surl = download_elem$getElementAttribute('href')
            if(length(surl)<1) {
                next
            }
            surl = surl[[1]]
            dat = readr::read_csv(surl, col_types = cols()) %>%
                tidyr::pivot_longer(
                    cols = dplyr::starts_with('20'),
                    names_to = "date",
                    values_to = "mobility_index"
                ) %>%
                dplyr::mutate(date = lubridate::ymd(date))
            if(message_url) message(sprintf("Download url: %s",surl))
            dat
        },
            silent=TRUE
        )
        if(inherits(dat, 'try-error') | is.null(dat)) {
            Sys.sleep(1)
            tries = tries + 1
        }
    }
    remDr$close()
    rD$stop()
    ## rpath = s2p_cached_url(url) ## TODO: fix caching to use only one url

    dat
}
    
