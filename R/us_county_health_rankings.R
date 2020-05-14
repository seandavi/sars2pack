#' United States county health rankings
#'
#' The County Health Rankings, a collaboration between the Robert Wood Johnson Foundation and the University of Wisconsin Population Health Institute, measure the health of nearly all counties in the nation and rank them within states. The Rankings are compiled using county-level measures from a variety of national and state data sources. 
#'
#' @importFrom dplyr %>% rename
#' @importFrom readr read_csv cols
#' @importFrom tidyr pivot_longer
#'
#' @details
#' 
#' The County Health Rankings gather data from around the nation that is comparable between counties,
#' within states. For most of their measures, county data is also comparable across state lines. However, for
#' a few of their measures, some caution must be exercised when making comparisons between counties in
#' different states. See references below for details.
#' 
#' @family data-import
#' 
#' @references
#' 
#' - \url{https://www.countyhealthrankings.org/sites/default/files/media/document/2020%20Analytic%20Documentation_0.pdf}
#' - \url{https://www.countyhealthrankings.org/sites/default/files/media/document/2020%20Comparability%20across%20states.pdf}
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @examples 
#' ret = us_county_health_rankings()
#' head(ret)
#' colnames(ret)
#' 
#' 
#' @export
us_county_health_rankings = function() {
    url = 'https://www.countyhealthrankings.org/sites/default/files/media/document/analytic_data2020.csv'
    rpath = s2p_cached_url(url)
    dat = readr::read_csv(rpath, skip=1, col_types = cols(), guess_max=10000)
    dat1 = readr::read_csv(rpath, col_types = cols(), n_max=1)
    colnames(dat)[8:ncol(dat)]=colnames(dat1)[8:ncol(dat1)]
    dat = tidyr::pivot_longer(dat, cols = -c(statecode:county_ranked), 
                              names_to='variable',values_to='value')
    dat$county_ranked = as.logical(dat$county_ranked)
    dat %>% dplyr::rename(fips='fipscode')
}
