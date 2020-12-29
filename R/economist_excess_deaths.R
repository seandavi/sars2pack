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
#' @return a data.frame
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
    path = c('output-data/excess-deaths')
    get_urls = function(repo, path) {
        res = ls_github(repo, path)
        res %>% dplyr::filter(.data$type=='file' & grepl('csv$',.data$name)) %>%
            dplyr::pull(.data$download_url)
    }
    urls = get_urls(repo, path)
    urls
    res = vapply(urls, s2p_cached_url,'filename')
    reader = function(x) {
        res = data.table::fread(x)
        keep_cols = seq_len(11)
        res = res[,..keep_cols]
        res$region_code=as.character(res$region_code)
        res$expected_deaths=suppressWarnings(as.numeric(res$expected_deaths))
        res
    }
    res = lapply(res, reader)
    dplyr::bind_rows(res)
}

