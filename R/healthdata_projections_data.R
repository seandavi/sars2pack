#' healthdata.org covid19 morbidity and hospitalization estimates
#'
#' These are time-series data that forecaset the COVID-19 impact
#' on hospital bed-days, ICU-days, ventilator-days, and deaths by
#' US state and selected additional countries or regions. The data
#' are those used here \url{https://covid19.healthdata.org/projections}.
#'
#' @importFrom readr read_csv
#' @importFrom utils unzip
#' @importFrom tidyr pivot_wider separate
#' @importFrom dplyr select
#'
#' @seealso
#' - \url{http://www.healthdata.org/covid}
#' - \url{http://www.healthdata.org/covid/updates}
#' - \url{http://www.healthdata.org/covid/faqs}
#'
#' @references
#' - \url{https://www.medrxiv.org/content/10.1101/2020.03.27.20043752v1}
#' 
#' @source
#' - \url{https://ihmecovid19storage.blob.core.windows.net/latest/ihme-covid19.zip}
#' 
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @return data.frame with columns for:
#'
#' - location_name
#' - date
#' - metric: such as all beds needed
#' - mean, upper, lower: mean, upper
#'   confidence interval, lower confidence interval
#'
#' @examples
#' res = healthdata_projections_data()
#' colnames(res)
#' res[sample(1:nrow(res),6),]
#'
#' @family data-import
#' 
#' @export
healthdata_projections_data <- function() {
    tmpd = tempdir()
    destfile = file.path(tmpd,"projections.zip")
    rpath = "https://ihmecovid19storage.blob.core.windows.net/latest/ihme-covid19.zip"
    destfile = s2p_cached_url(rpath)
    unzip(destfile, exdir=tmpd)
    datafile = dir(tmpd, pattern='^Hospitalization_all_locs\\.csv$', recursive = TRUE, full.names=TRUE)[1]
    projections = readr::read_csv(datafile, col_types=cols(), guess_max=5000)
    projections = projections %>%
        dplyr::select(-V1) %>%
        tidyr::pivot_longer(cols=-c('location_name', 'date'),
                            names_to='metric', values_to='count') %>%
        tidyr::separate(metric, c('metric','quantity')) %>%
        tidyr::pivot_wider(names_from = quantity, values_from = count, values_fill = list(count=0))
    attr(projections, 'class') = c('covid_projections_df', class(projections))
    projections
}
