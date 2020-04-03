#' United States state and county level data from USAFacts
#'
#' @importFrom lubridate mdy
#' @importFrom readr read_csv cols
#'
#' @source https://github.com/beoutbreakprepared/nCoV2019
#'
#' @note
#'
#' 
#' @return
#'
#' 
#' @examples
#' res = beoutbreakprepared_data()
#' colnames(res)
#' head(res)
#'
#' @family data-import
#' 
#' @export
beoutbreakprepared_data = function() {
    fpath = s2p_cached_url('https://raw.githubusercontent.com/beoutbreakprepared/nCoV2019/master/latest_data/latestdata.csv')
    dat = readr::read_csv(fpath,
                          col_types = cols(),
                          guess_max = 50000
                          )
    date_cols = grep('date',colnames(dat),value=TRUE)
    browser()
    dat[[date_cols]] = lapply(date_cols,function(d) lubridate::as_date(gsub('\\.','-',dat[[d]])))
    dat
}


