#' Individual-level data contributed from around the world
#'
#' @importFrom lubridate mdy
#' @importFrom readr read_csv cols
#'
#' @source https://github.com/beoutbreakprepared/nCoV2019
#' @param quietly logical(1) defaults to TRUE.  If FALSE, warnings generated during
#' parsing will be displayed.  These often relate to nonstandard date values that
#' occur idiosyncratically.
#' 
#' @section Citation:
#' misc{kraemer2020epidemiological,
#' author =       {nCoV-2019 Data Working Group},
#' title =        {{Epidemiological Data from the nCoV-2019 Outbreak: Early
#'     Descriptions from Publicly Available Data}},
#' howpublished = {Accessed on yyyy-mm-dd from
#'    \url{http://virological.org/t/epidemiological-data-from-the-ncov-2019-outbreak-early-descriptions-from-publicly-available-data/337}},
#' year =         2020
#' }
#'
#' @note This is individual level data, collected from diverse sources. Data may be messy
#' and we have made limited attempts at clean up. 
#' 
#' @return
#' tidy data.frame of content
#' 
#' @examples
#' res = beoutbreakprepared_data()
#' colnames(res)
#' head(res)
#'
#' @family data-import
#' @family case-tracking
#' @family individual-cases
#' 
#' @export
beoutbreakprepared_data = function(quietly=TRUE) {
    fpath = s2p_cached_url('https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/latest_data/latestdata.csv')
    dat = readr::read_csv(fpath,
                          col_types = cols(),
                          # needed for col types to be correct
                          guess_max = 50000)
    date_cols = grep('date',colnames(dat),value=TRUE)
    oldw = options()$warn
    on.exit(options(warn=oldw))  # this could be conditional
    if (quietly) options(warn=-1)
    dat[,c(date_cols)] = lapply(date_cols,function(d) lubridate::as_date(gsub('\\.','-',dat[[d]])))
    dat
}


