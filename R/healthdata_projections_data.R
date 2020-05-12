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
#' dplyr::glimpse(res)
#' summary(res)
#'
#' #plot the predictions
#'
#' regs_of_interest = 'Georgia'
#' library(ggplot2)
#' pl = res %>%
#'     dplyr::filter(location_name %in% regs_of_interest) %>%
#'     ggplot(aes(x=date)) + geom_line(aes(y=mean, color=metric))
#'
#' # plot the "mean" prediction
#' pl
#'
#' # add 95% confidence bounds
#' pl + geom_ribbon(aes(ymin=lower, ymax=upper, fill=metric), alpha=0.25)
#'
#' regs_of_interest = c('New York', 'Italy')
#' pl = res %>%
#'     dplyr::filter(location_name %in% regs_of_interest) %>%
#'     ggplot(aes(x=date)) + geom_line(aes(y=mean, color=metric)) +
#'     facet_grid(rows = vars(location_name))
#' pl
#' 
#' @family data-import
#' @family healthcare-system
#' @family projections
#' 
#' @export
healthdata_projections_data <- function() {
    rpath = "https://ihmecovid19storage.blob.core.windows.net/latest/ihme-covid19.zip"
    destfile = s2p_cached_url(rpath)
    tmpd = tempdir()
    unzip(destfile, exdir=tmpd)
    datafile = dir(tmpd, pattern='^Hospitalization_all_locs\\.csv$', recursive = TRUE, full.names=TRUE)[1]
    projections = readr::read_csv(datafile, col_types=cols(), guess_max=5000)
    projections = projections %>%
        dplyr::select(c(dplyr::ends_with(c('mean','upper','lower')),
                        'location_name','date')) %>%
        tidyr::pivot_longer(cols=c(dplyr::ends_with(c('mean','upper','lower'))),
                            names_to='metric', values_to='count') %>%
        tidyr::separate(metric, into=c('metric','quantity'), sep="_", extra='merge') %>%
        tidyr::pivot_wider(names_from = quantity, values_from = count, values_fill = list(count=0))
    attr(projections, 'class') = c('covid_projections_df', class(projections))
    projections
}

healthdata_mobility_data <- function() {
    rpath = "https://ihmecovid19storage.blob.core.windows.net/latest/ihme-covid19.zip"
    destfile = s2p_cached_url(rpath)
    tmpd = tempdir()
    unzip(destfile, exdir=tmpd)
    datafile = dir(tmpd, pattern='^Hospitalization_all_locs\\.csv$', recursive = TRUE, full.names=TRUE)[1]
    projections = readr::read_csv(datafile, col_types=cols(), guess_max=5000)
    projections = projections %>%
        dplyr::select(c(dplyr::starts_with('mobility'),
                        'location_name','date'))
    attr(projections, 'class') = c('covid_projections_df', class(projections))
    projections
}

healthdata_testing_data <- function() {
    rpath = "https://ihmecovid19storage.blob.core.windows.net/latest/ihme-covid19.zip"
    destfile = s2p_cached_url(rpath)
    tmpd = tempdir()
    unzip(destfile, exdir=tmpd)
    datafile = dir(tmpd, pattern='^Hospitalization_all_locs\\.csv$', recursive = TRUE, full.names=TRUE)[1]
    projections = readr::read_csv(datafile, col_types=cols(), guess_max=5000)
    projections = projections %>%
        dplyr::select(c(dplyr::starts_with('total_tests'),
                        'location_name','date'))
    attr(projections, 'class') = c('covid_projections_df', class(projections))
    projections
}

