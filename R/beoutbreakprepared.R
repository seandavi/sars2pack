#' United States state and county level data from USAFacts
#'
#' @importFrom lubridate mdy
#' @importFrom readr read_csv cols
#'
#' @source https://github.com/beoutbreakprepared/nCoV2019
#' @param quietly logical(1) defaults to TRUE.  If FALSE, warnings generated during
#' parsing will be displayed.  These often relate to nonstandard date values that
#' occur idiosyncratically.
#'
#' @note This is individual level data, collected upstream of
#' this package from diverse sources.  Date values in particular
#' can be non-standard.  If you wish to introduce corrections for 
#' poorly formated data, see the argument to `read.csv` in the source
#' code of this function and acquire the table manually.  
#' @return
#' 
#' @examples
#' res = beoutbreakprepared_data()
#' colnames(res)
#' head(res)
#'
#' @family data-import
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


