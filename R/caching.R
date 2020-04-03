#' get the BiocFileCache for sars2pack
#'
#' Set up or get location of BiocFileCache. By default,
#' this uses the name BiocFileCache.
#'
#' @importFrom BiocFileCache BiocFileCache bfcneedsupdate bfcupdate bfcadd bfcquery bfcrpath
#' 
#' @param cache character(1), the path to the cache directory. See [BiocFileCache::BiocFileCache()].
#'
#' @keywords internal
s2p_get_cache <- function(cache = rappdirs::user_cache_dir(appname='sars2pack')) {
    BiocFileCache::BiocFileCache(cache=cache)
}

#' @importFrom BiocFileCache bfcneedsupdate bfcdownload bfcadd bfcquery bfcrpath
#' 
s2p_cached_url <- function(url, rname = url, ask_on_update=FALSE, ...) {
    bfc = s2p_get_cache()
    
    rid = bfcquery(bfc,rname,'rname')$rid
    # Not found
    if(!length(rid)) {
        rid = names(bfcadd(bfc, rname, url))
    }
    # if needs update, do the download
    if(!isFALSE(bfcneedsupdate(bfc, rid))) {
        bfcupdate(bfc, rid, ask=FALSE)
    }
    bfcrpath(bfc, rids = rid)
}
