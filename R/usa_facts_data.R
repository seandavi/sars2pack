#' retrieve time series dataset from USA Facts
#'
#' This always does a web call. The assumption here is that
#' the user is online and that github is up and that URLs are
#' stable.
#' 
#' @importFrom dplyr bind_rows
#' @importFrom lubridate mdy
#'
#' @note Uses https://usafacts.org/visualizations/coronavirus-covid-19-spread-map/ as data
#' source, then modifies column names and munges to long form table.
#' 
#' @return an object of class `s2p_long_df` that inherits from tbl_df
#'
#' @examples
#' res = usa_facts_data()
#' colnames(res)
#' head(res)
#'
#' @family data-import
#' @seealso jhu_data()
#' 
#' @export
usa_facts_data = function() {
    dat = readr::read_csv('https://raw.github.com/nytimes/covid-19-data/master/us-counties.csv')
    confirmed = dat[,1:5]
    confirmed$subset = 'confirmed'
    deaths = dat[,c(1:4,6)]
    deaths$subset='deaths'
    ret = dplyr::bind_rows(confirmed,deaths)
    colnames(ret)[2] = 'County'
    ret$date = lubridate::mdy(ret$date)
    ret
}
