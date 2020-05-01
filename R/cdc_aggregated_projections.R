#' Projected deaths from COVID-19 models
#' 
#' The US CDC gathers projections from several groups around
#' the world and aggregates them into a single data resource. 
#' See the reference below for details of the models.
#' 
#' These models are not updated daily but more like weekly.
#' This function will attempt to grab the latest version. 
#' 
#' @importFrom xml2 read_html 
#' @importFrom rvest html_nodes html_attr
#' @importFrom readr read_csv
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @family data-import
#' @family projections
#' 
#' @references 
#' - \url{https://www.cdc.gov/coronavirus/2019-ncov/covid-data/forecasting-us.html}
#' 
#' @examples 
#' res = cdc_aggregated_projections()
#' head(res)
#' dplyr::glimpse(res)
#' 
#' # available models
#' table(res$model)
#' 
#' # projection targets
#' table(res$target)
#' 
#' min(res$forecast_date)
#' max(res$target_week_end_date)
#'
#' library(dplyr)
#' library(ggplot2)
#' 
#' # FACET view
#' res_ny = res %>%
#'     dplyr::filter(location_name=='New York' & grepl('cum death', target)) %>%
#'     dplyr::filter(model!='UMass-MechBayes')
#' res_ny %>%
#'     dplyr::filter(location_name=='New York') %>%
#'     ggplot(aes(x=model, y=point, color=model)) +
#'     geom_errorbar(aes(ymin= quantile_0.025, ymax =  quantile_0.975)) +
#'     facet_wrap(facets='target_week_end_date') +
#'     geom_point() +
#'     labs(y='Projected Deaths') +
#'     theme_bw() +
#'     theme(axis.text.x=element_blank()) +
#'     ggtitle('Projected New York deaths for week ending')
#' #'
#' # combined view
#' pd <- position_dodge(width = 3) # use this to offset points and error bars
#' res_ny %>%
#'     ggplot(aes(x=target_week_end_date, y=point, color=model)) +
#'     geom_errorbar(aes(ymin= quantile_0.025, ymax =  quantile_0.975), position=pd) +
#'     geom_point(position=pd) +
#'     labs(y='Projected Deaths') +
#'     geom_line(position=pd) +
#'     theme_bw() +
#'     theme(legend.position='bottom') +
#'     ggtitle('Projected New York deaths for week ending')
#' 
#' 
#' @export
cdc_aggregated_projections <- function() {
    path = xml2::read_html("https://www.cdc.gov/coronavirus/2019-ncov/covid-data/forecasting-us.html") %>%
        rvest::html_nodes("a") %>% 
        rvest::html_attr('href') %>% 
        grep('model-data.csv$',.,value=TRUE)
    url = file.path('https://www.cdc.gov', path)
    rpath = s2p_cached_url(url)
    res = readr::read_csv(rpath, col_types = cols())
    res
}
