#' United States county and state level data from the New York Times
#'
#' Each row of data reports cumulative counts based on best reporting
#' up to the moment published. The NYT states that it may revise
#' earlier entries in the data when they receive new information.
#'
#' @details
#'
#' From the NYTimes github README:
#'
#' The New York Times is releasing a series of data files with
#' cumulative counts of coronavirus cases in the United States, at the
#' state and county level, over time. We are compiling this time
#' series data from state and local governments and health departments
#' in an attempt to provide a complete record of the ongoing outbreak.
#' 
#' Since late January, The Times has tracked cases of coronavirus in
#' real time as they were identified after testing. Because of the
#' widespread shortage of testing, however, the data is necessarily
#' limited in the picture it presents of the outbreak.
#' 
#' We have used this data to power our maps and reporting tracking the
#' outbreak, and it is now being made available to the public in
#' response to requests from researchers, scientists and government
#' officials who would like access to the data to better understand
#' the outbreak.
#' 
#' The data begins with the first reported coronavirus case in
#' Washington State on Jan. 21, 2020. We will publish regular updates
#' to the data in this repository.
#' 
#' @importFrom dplyr bind_rows
#' @importFrom lubridate ymd
#' @importFrom readr read_csv cols
#'
#' @note See \url{https://github.com/nytimes/covid-19-data#geographic-exceptions}. Also,
#'     This dataset contains county data with "holes" in reporting, dates with no
#'     reported results. Also, records with "Unknown" county are removed since
#'     these records appear to NOT be cumulative data, but incidence data? 
#' 
#' 
#' 
#' @section Licensing:
#'
#' The NYTimes provides a license that states:
#'
#' In general, we are making this data publicly available for broad,
#' noncommercial public use including by medical and public health
#' researchers, policymakers, analysts and local news media.
#' 
#' If you use this data, you must attribute it to “The New York Times”
#' in any publication. If you would like a more expanded description
#' of the data, you could say “Data from The New York Times, based on
#' reports from state and local health agencies.”
#'
#' If you use it in an online presentation, we would appreciate it if
#' you would link to our U.S. tracking page at
#' \url{https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html}.
#'
#' 
#' @source
#'   - \url{https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv}
#'   - \url{https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv}
#' 
#' @return a five-column (for states) or six-column (for counties) tibble
#'   - date: observation date
#'   - county: county (or sometimes city), see \url{https://github.com/nytimes/covid-19-data/} for details
#'   - state: present in both the state and county data. Note that simply aggregating by state will
#'     sometimes overcount when working with the `county` level data. See \url{https://github.com/nytimes/covid-19-data/} for details.
#'   - fips: The Federal Information Processing Standard Publication 6-4 (FIPS 6-4)
#'     was a five-digit Federal Information Processing Standards code which uniquely
#'     identified counties and county equivalents in the United States, certain U.S.
#'     possessions, and certain freely associated states.
#'   - count: number of cases (cumulative)
#'   - subset: `deaths` or `confirmed`
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' # state data
#' res = nytimes_state_data()
#' colnames(res)
#' dplyr::glimpse(res)
#'
#' # county data
#' res = nytimes_county_data()
#' colnames(res)
#' dplyr::glimpse(res)
#'
#'  
#' @family data-import
#' @family case-tracking
#' 
#' @seealso jhu_data(), usa_facts_data()
#'
#' @export
nytimes_county_data = function() {
    rpath = s2p_cached_url('https://raw.github.com/nytimes/covid-19-data/master/us-counties.csv')
    dat = readr::read_csv(rpath, col_types=cols())
    confirmed = dat[,1:5]
    confirmed$subset = 'confirmed'
    deaths = dat[,c(1:4,6)]
    deaths$subset='deaths'
    colnames(deaths)[5]='count'
    colnames(confirmed)[5]='count'
    ret = dplyr::bind_rows(confirmed,deaths)
    colnames(ret)[2] = 'county'
    ret$date = lubridate::ymd(ret$date)
    ret = ret[ret$county!='Unknown',] # these appear to be non-cumulative, so remove
    ret$fips = integer_to_fips(as.numeric(ret$fips))
    ret
}

#' @rdname nytimes_county_data
#'
#' @importFrom readr read_csv cols
#' @importFrom dplyr bind_rows
#' @importFrom lubridate ymd
#'
#' @export
nytimes_state_data = function() {
    rpath = s2p_cached_url('https://raw.github.com/nytimes/covid-19-data/master/us-states.csv')
    dat = readr::read_csv(rpath, col_types=cols())
    confirmed = dat[,1:4]
    confirmed$subset = 'confirmed'
    deaths = dat[,c(1:3,5)]
    deaths$subset='deaths'
    colnames(deaths)[4]='count'
    colnames(confirmed)[4]='count'
    ret = dplyr::bind_rows(confirmed,deaths)
    ret$date = lubridate::ymd(ret$date)
    ret$fips = integer_to_fips(as.numeric(ret$fips))
    ret
}
