#' healthdata.org covid19 morbidity and hospitalization estimates
#'
#' These are time-series data that forecaset the COVID-19 impact
#' on hospital bed-days, ICU-days, ventilator-days, and deaths by
#' US state and selected additional countries or regions. The data
#' are those used here \url{https://covid19.healthdata.org/projections}.
#'
#' @importFrom readr read_csv
#' @importFrom utils unzip
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
#' @return data.frame after downloading data
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
    download.file("https://ihmecovid19storage.blob.core.windows.net/latest/ihme-covid19.zip", 
                  destfile=destfile,
                  method="curl",
                  extra='-L')
    unzip(destfile, exdir=tmpd)
    unzip_dir = dir(tmpd, pattern='.*\\.all', full.names=TRUE)[1]
    projections = readr::read_csv(file.path(unzip_dir, 'Hospitalization_all_locs.csv'))
    attr(projections, 'class') = c('covid_projections_df', class(projections))
    projections
}
