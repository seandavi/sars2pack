#' United States state and county level data from USAFacts
#'
#' A single dataset from USAFacts that has state and county
#' data included.
#'
#' @details
#'
#' From the USAFacts website:
#'
#' Methodology: This interactive feature aggregates data from the Centers for Disease Control and Prevention (CDC), state- and local-level public health agencies. County-level data is confirmed by referencing state and local agencies directly.
#'
#' The data for all states was last updated on March 27, 2020, at 7:00 AM Pacific/10:00 AM Eastern Time. We've noted below when we last checked data from the states.
#' 
#' The 21 cases confirmed on the Grand Princess cruise ship on March 5 and 6 are attributed to the state of California, but not to any counties. The national numbers also include the 45 people with coronavirus repatriated from the Diamond Princess.
#' 
#' USAFacts attempts to match each case with a county, but some cases counted at the state level are not allocated to counties due to lack of information.
#' 
#' Because of the frequency with which we are currently updating this data, they may not reflect the exact numbers reported state and local government organizations or the news media. Numbers may also fluctuate as agencies update their own data. At present, we are working on ensuring that we can provide this data with the most up-to-date information possible.
#'
#' 
#' @importFrom dplyr bind_rows
#' @importFrom lubridate mdy
#' @importFrom readr read_csv cols
#'
#' @source \url{https://usafacts.org/visualizations/coronavirus-covid-19-spread-map/}
#'
#' @note Uses https://usafacts.org/visualizations/coronavirus-covid-19-spread-map/ as data
#' source, then modifies column names and munges to long form table.
#' 
#' @return
#'
#' a tidy data tibble with columns:
#'
#'   - fips
#'   - county
#'   - state (two-letter abbreviation)
#'   - subset: `deaths` or `confirmed`
#'   - date: observation date
#'   - count: case count for that date on that local
#'
#' @section Licensing:
#'
#' From the folks at USAFacts
#' 
#' Want to use USAFacts county-level COVID-19 data? Download it
#' here. The data is available under a Creative Commons license. We
#' simply request that you cite USAFacts as the data provider and link
#' back to this page. Don’t forget to share what you've created with
#' the USAFacts data. Please tag @usafacts on social media and use the
#' hashtag #MadewithUSAFacts. We'll reshare the posts with the
#' data-loving community.
#' 
#' @examples
#' res = usa_facts_data()
#' colnames(res)
#' head(res)
#' # dataset inclusion as of this build
#' max(res$date)
#'
#' @family data-import
#' @seealso jhu_data()
#' 
#' @export
usa_facts_data = function() {
    confirmed_path = s2p_cached_url('https://static.usafacts.org/public/data/covid-19/covid_confirmed_usafacts.csv')
    confirmed = readr::read_csv(confirmed_path,
                                col_types = cols())
    confirmed$subset = 'confirmed'
    deaths_path = s2p_cached_url('https://static.usafacts.org/public/data/covid-19/covid_deaths_usafacts.csv')
    deaths = readr::read_csv(deaths_path,
                             col_types=cols())
    deaths$subset = 'deaths'
    ret = dplyr::bind_rows(confirmed,deaths)
    colnames(ret)[2] = 'county'
    colnames(ret)[3] = 'state'
    colnames(ret)[1] = 'fips'
    ret = ret[-4]
    ret$fips = integer_to_fips(ret$fips)
    ret = tidyr::pivot_longer(ret,cols=-c(fips,state,county,subset),names_to='date',values_to='count')
    ret$date = lubridate::mdy(ret$date)
    ret
}
