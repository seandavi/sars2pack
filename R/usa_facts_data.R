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
    confirmed = readr::read_csv('https://static.usafacts.org/public/data/covid-19/covid_confirmed_usafacts.csv')
    confirmed$subset = 'confirmed'
    deaths = readr::read_csv('https://static.usafacts.org/public/data/covid-19/covid_deaths_usafacts.csv')
    deaths$subset = 'deaths'
    ret = dplyr::bind_rows(confirmed,deaths)
    colnames(ret)[2] = 'County'
    ret = tidyr::pivot_longer(ret,cols=-c(countyFIPS:stateFIPS,subset),names_to='date',values_to='count')
    ret$date = lubridate::mdy(ret$date)
    ret
}
