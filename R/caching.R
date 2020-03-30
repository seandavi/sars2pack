#' get the BiocFileCache for sars2pack
#'
#' Set up or get location of BiocFileCache. By default,
#' this uses the name BiocFileCache.
#'
#' @param cache character(1), the path to the cache directory. See [BiocFileCache::BiocFileCache()].
#'
#' @keywords internal
s2p_get_cache <- function(cache = rappdirs::user_cache_dir(appname='sars2pack')) {
    BiocFileCache::BiocFileCache(cache=cache)
}

s2p_cached_url <- function(url, rname = url, ...) {
    bfc = s2p_get_cache()
    
    rid = bfcquery(bfc,rname,'rname')$rid
    # Not found
    if(!length(rid)) {
        rid = names(bfcadd(bfc, rname, url))
    }
    # if needs update, do the download
    if(!isFALSE(bfcneedsupdate(bfc, rid))) {
        bfcdownload(bfc, rid)
    }
    bfcrpath(bfc, rids = rid)
}
