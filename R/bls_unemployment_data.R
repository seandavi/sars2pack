# urls: 
# - https://download.bls.gov/pub/time.series/la/la.data.64.County
# - https://download.bls.gov/pub/time.series/la/la.data.65.City

bls_unemployment_data <- function() {
    url_county = 'https://download.bls.gov/pub/time.series/la/la.data.64.County'
    url_city   = 'https://download.bls.gov/pub/time.series/la/la.data.65.City'
    url_series = 'https://download.bls.gov/pub/time.series/la/la.series'
    url_footnotes = 'https://download.bls.gov/pub/time.series/la/la.footnote'
    # Series processing
    rpath_series = s2p_cached_url(url_series)
    series = readr::read_tsv(rpath_series, col_types = readr::cols()) %>% 
        dplyr::select(series_id,series_title) %>% 
        tidyr::separate(series_title, c('measure','location'), ': ') %>% 
        dplyr::mutate(seasonal_adj=grepl('(S)', location)) %>% 
        dplyr::mutate(location = sub(' \\([US]+\\)$','', location))
    rpath_footnotes = s2p_cached_url(url_footnotes)
    footnotes = readr::read_tsv(rpath_footnotes, col_types = readr::cols())
    rpath_county = s2p_cached_url(url_county)
    rpath_city   = s2p_cached_url(url_city)
    dat = dplyr::bind_rows(
        readr::read_tsv(rpath_county, col_types = readr::cols(),na = c('-','')) %>% 
            dplyr::mutate(location_type='county') %>%
            dplyr::left_join(series, 'series_id') %>%
            dplyr::mutate(location = sub(' County','',location)),
        readr::read_tsv(rpath_city, col_types = readr::cols(),na = c('-','')) %>%
            dplyr::mutate(location_type='city') %>% 
            dplyr::left_join(series, 'series_id') %>% 
            dplyr::mutate(location = sub(' city','',location))
    )
    # The fill below is to deal with District of Columbia (DC)
    # state is left empty
    dat %>% tidyr::separate(location, c('location', 'state'), ', ', fill='right')
}
