#' Kaiser Family Foundation US County-level ICU bed data
#'
#' @source
#' - \url{https://khn.org/news/as-coronavirus-spreads-widely-millions-of-older-americans-live-in-counties-with-no-icu-beds/}
#' - \url{https://khn.org/wp-content/uploads/sites/2/2020/03/KHN-ICU-bed-county-analysis_2.zip}
#' 
#' @importFrom readxl read_xlsx
#'
#' @family data-import
#' @family healthcare-systems
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
    tmpd = tempdir()
    url = 'https://khn.org/wp-content/uploads/sites/2/2020/03/KHN-ICU-bed-county-analysis_2.zip'
    rpath = s2p_cached_url(url)
    dat2 = utils::unzip(rpath, overwrite=TRUE, exdir=tmpd)
    dat3 = readxl::read_xlsx(dat2[1])
    colnames(dat3)[c(1,2)] = c('fips','county')
    dat3
}
