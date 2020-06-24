#' OECD International unemployment statistics
#' 
#' The Organisation for Economic Co-operation and Development (OECD) is an international organisation
#' and collects and reports broadly on economic and social factors.
#'
#' @details 
#' 
#' Unemployment rate is the number of unemployed people as a percentage of the labour force, where the 
#' latter consists of the unemployed plus those in paid or self-employment. Unemployed people are those 
#' who report that they are without work, that they are available for work and that they have taken 
#' active steps to find work in the last four weeks. When unemployment is high, some people become 
#' discouraged and stop looking for work; they are then excluded from the labour force. This implies 
#' that the unemployment rate may fall, or stop rising, even though there has been no underlying 
#' improvement in the labour market.
#'
#' @source 
#' \url{https://data.oecd.org/unemp/unemployment-rate.htm}
#'
#' @family data-import
#' @family economy
#'
#' @references 
#' OECD (2020), Unemployment rate (indicator). doi: 10.1787/997c8750-en (Accessed on 05 June 2020)
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples 
#' unemp = oecd_unemployment_data()
#' unemp
#' dplyr::glimpse(unemployment)
#' summary(unemp)
#' 
#' 
#' library(ggplot2)
#' us_month_unemp = unemp %>% 
#'     dplyr::filter(iso3c=='USA' & frequency=='month')
#' p1 = ggplot(us_month_unemp,aes(x=date,y=value,color=subject)) + geom_line()
#' p2 = dplyr::filter(us_month_unemp,date>'2019-11-01') %>%
#'     ggplot(aes(x=date,y=value,color=subject)) + 
#'     geom_line() + theme(legend.position='none')
#'     
#' p1 + annotation_custom(ggplotGrob(p2), 
#'                        xmin = as.Date("1960-01-01"), xmax = as.Date("1990-01-01"), 
#'                        ymin = 10, ymax = 16)
#' 
#' @export
oecd_unemployment_data = function() {
    frequencies = c(A='annual',Q='quarter',M='month')
    fix_frequencies = function(f) {
        frequencies[f]
    }
    fix_dates = function(d) {
        lubridate::as_date(lubridate::parse_date_time(d,orders=c('y', 'y-m', 'y-q')))
    }
    rpath = s2p_cached_url('https://stats.oecd.org/sdmx-json/data/DP_LIVE/.UNEMP.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en')
    res = readr::read_csv(rpath, guess_max = 5000, col_types = readr::cols()) %>%
        dplyr::rename_all(tolower) %>%
        dplyr::mutate(date=fix_dates(.data$time)) %>%
        dplyr::select(-.data$time) %>%
        dplyr::rename(iso3c=.data$location) %>%
        dplyr::mutate(frequency = fix_frequencies(.data$frequency))%>%
        dplyr::mutate_at(vars(.data$indicator,.data$subject),tolower) %>%
        dplyr::mutate(country=countrycode::countrycode(.data$iso3c,
                                                       origin ='iso3c',
                                                       destination = 'country.name',
                                                       warn = FALSE,
                                                       nomatch = ''
                                                    )) %>% 
        dplyr::mutate(region=countrycode::countrycode(.data$iso3c,
                                                       origin ='iso3c',
                                                       destination = 'region',
                                                       warn = FALSE,
                                                       nomatch = ''
                                                      )) 
    res
}
