#' Kaiser Family Foundation US County-level ICU bed data
#'
#' @source
#' - \url{https://khn.org/news/as-coronavirus-spreads-widely-millions-of-older-americans-live-in-counties-with-no-icu-beds/}
#' - \url{https://khn.org/wp-content/uploads/sites/2/2020/03/KHN-ICU-bed-county-analysis_2.zip}
#' 
#' @importFrom readxl read_xlsx
#'
#' @family data-import
#'
#' @examples
#' res = kff_icu_beds()
#' colnames(res)
#' head(res)
#' dplyr::glimpse(res)
#' summary(res)
#' 
#' @export
kff_icu_beds <- function() {
    rpath = 'https://khn.org/wp-content/uploads/sites/2/2020/03/KHN-ICU-bed-county-analysis_2.zip'
    z = s2p_cached_url(rpath)
    dat2 = unzip(z)
    dat3 = readxl::read_xlsx(dat2[1])
    colnames(dat3)[1:2] = c('fips','county')
    dat3
}
