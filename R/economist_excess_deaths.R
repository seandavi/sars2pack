#' Excess deaths during covid for US and selected countries
#'
#' Return the data behind The Economist’s tracker for [covid-19 excess
#' deaths](https://www.economist.com/graphic-detail/2020/04/16/tracking-covid-19-excess-deaths-across-countries)
#' (which is free to read)
#'
#' @source
#' - \url{https://github.com/TheEconomist/covid-19-excess-deaths-tracker}
#'
#' @references
#' - \url{https://www.economist.com/graphic-detail/2020/04/16/tracking-covid-19-excess-deaths-across-countries}
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @family data-import
#' @family excess-deaths
#'
#' @examples
#' res = economist_excess_deaths()
#' colnames(res)
#' dplyr::glimpse(res)
#' res
#' unique(res$country)
#'
#' @export
economist_excess_deaths = function() {
    repo = 'TheEconomist/covid-19-excess-deaths-tracker'
    paths = c('output-data/excess-deaths')
    get_urls = function(repo, path) {
        res = ls_github(repo, path)
        res %>% dplyr::filter(type=='file' & grepl('csv$',name)) %>%
            .$download_url
    }
    urls = c(sapply(paths, function(x) get_urls(repo, x)))
    urls
    res = sapply(urls, s2p_cached_url)
    reader = function(x) {
        res = readr::read_csv(x,col_types=readr::cols())[,1:11]
        res$region_code=as.character(res$region_code)
        res$expected_deaths=suppressWarnings(as.numeric(res$expected_deaths))
        res
    }
    res = lapply(res, reader)
    dplyr::bind_rows(res)
}

