#' United States Employment Data from Econ Tracker and Opportunity Insights
#' 
#' 
#' Number of active employees, aggregating information from multiple data providers. This series is based on firm-level payroll data from Paychex and Intuit, worker-level data on employment and earnings from Earnin, and firm-level timesheet data from Kronos.
#' 
#' @details
#' Data Sources: Paychex, Intuit, Earnin, Kronos
#' 
#' Breakdowns are by:
#' 
#' ## Wages
#' 
#' - High Income (wage greater than $60,000 per year)
#' - Middle Income (wage between $27,000 per year and $60,000 per year)
#' - Low Income (wage less than $27,000 per year)
#' 
#' ## Industry by [NAICS supersector](https://www.bls.gov/sae/additional-resources/naics-supersectors-for-ces-program.htm).
#' 
#' - Professional and Business Services
#' - Education and Health Services
#' - Retail and Transportation
#' - Leisure and Hospitality
#' 
#' @return 
#' 
#' a data.table with geographic details and a variable column with the following values representing the reported value: 
#' 
#' - emp_combined: Employment level for all workers.
#' - emp_combined_inclow: Employment level for workers in the bottom quartile of the income distribution (incomes approximately under $27,000).
#' - emp_combined_incmiddle: Employment level for workers in the middle two quartiles of the income distribution (incomes approximately $27,000 to $60,000).
#' - emp_combined_inchigh: Employment level for workers in the top quartile of the income distribution (incomes approximately over $60,000).
#' - emp_combined_ss40: Employment level for workers in trade, transportation and utilities (NAICS supersector 40).
#' - emp_combined_ss60: Employment level for workers in professional and business services (NAICS supersector 60).
#' - emp_combined_ss65: Employment level for workers in education and health services (NAICS supersector 65).
#' - emp_combined_ss70: Employment level for workers in leisure and hospitality (NAICS supersector 70).
#' 
#' 
#' @note
#'
#' For low income workers, the change in employment is calculated using Paychex and Earnin data. For medium and high income workers, the change in employment is calculated using Paychex and Intuit data.
#' 
#' In order to provide closer to real time data, we forecast the most recent employment measures beyond those available in the combined Earnin, Intuit, and Paychex dataset alone. To do so, we leverage two sources of higher frequency data: Kronos timestamp data and the Paychex weekly pay cycle sample. Using this higher frequency data we forecast more recent changes in employment using a distributed lag model, constructed by regressing a given week’s employment measure on the corresponding week’s Kronos measure, as well as its current and 3 previous lagged weeks’ Paychex weekly pay cycle measure. For more details, please refer to the appendix of the accompanying paper
#' 
#' @name econ_tracker_employment
#' @author Sean Davis <seandavi@gmail.com>
#' @family data-import
#' @family economics
#' 
#' @examples 
#' 
#' res = econ_tracker_city_data()
#' res
#' 
#' @export
econ_tracker_employment_city_data = function() {
  locs = econ_tracker_city_geo()
  setkey(locs,'cityid')
  url = "https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/Employment%20Combined%20-%20City%20-%20Daily.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
  data.table::set(dat, j=c('year','month','day'), value=NULL)
  setkey(dat,'cityid')
  .melt_econ_tracker_employment(locs[dat,all=TRUE])
}

#' @rdname econ_tracker_employment
#' 
#' @examples 
#' res = econ_tracker_county_data()
#' res
#' 
#' 
#' @export
econ_tracker_employment_county_data = function() {
  locs = econ_tracker_county_geo()
  setkey(locs,'countyfips')
  url = "https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/Employment%20Combined%20-%20County%20-%20Daily.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
  data.table::set(dat, j=c('year','month','day'), value=NULL)
  data.table::set(dat, j='countyfips', value=integer_to_fips(dat[['countyfips']]))
  setkey(dat,'countyfips')
  .melt_econ_tracker_employment(locs[dat,all=TRUE])
}

#' @rdname econ_tracker_employment
#' 
#' @examples 
#' res = econ_tracker_employment_state_data()
#' res
#' 
#' @export
econ_tracker_employment_state_data = function() {
  locs = econ_tracker_state_geo()
  setkey(locs,'statefips')
  url = "https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/Employment%20Combined%20-%20State%20-%20Daily.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
  data.table::set(dat, j=c('year','month','day'), value=NULL)
  data.table::set(dat, j='statefips', value=integer_to_fips(dat[['statefips']]))
  setkey(dat,'statefips')
  .melt_econ_tracker_employment(locs[dat,all=TRUE])
}

#' @rdname econ_tracker_employment
#' 
#' @examples 
#' res = econ_tracker_employment_national_data()
#' res
#' 
#' ggplot(res, aes(x=date,y=value,color=variable,lty=variable_type)) + 
#'     geom_line() + 
#'     ggtitle('Proportion of workforce employed in the United States', 
#'             subtitle='Broken down by industry and income level, normalized to January 2020') +
#'     ylab('Proportion of workforce') 
#' 
#' @export
econ_tracker_employment_national_data = function() {
  url = "https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/Employment%20Combined%20-%20National%20-%20Daily.csv"
  rpath = s2p_cached_url(url)
  dat = data.table::fread(rpath, na.strings = '.')
  data.table::set(dat, j="date", value=data.table::as.IDate(paste(dat$year,dat$month,dat$day,sep="-")))
  data.table::set(dat, j=c('year','month','day'), value=NULL)
  data.table::set(dat, j=c('emp_combined_advance'), value=NULL)
  .melt_econ_tracker_employment(dat)
}


#' Convert employment data to long form
#' 
#' Also adds columns to make data easier to 
#' filter.
#' 
#' @param dtable a `data.table` object
#' 
#' @returns a long-form `data.table`
#' 
#' @keywords internal
.melt_econ_tracker_employment = function(dtable) {
  cols_to_stack = grep('emp_combined',colnames(dtable))
  tmp = data.table::melt(dtable, measure.vars=cols_to_stack)
  tmp[, variable := sub('emp_combined[_]?','',tmp[['variable']])]
  tmp[variable=='', variable:='everyone']
  tmp[, variable_type := "total"]
  tmp[grepl('^ss',variable), variable_type := 'NAICS']
  tmp[grepl('^inc',variable), variable_type := 'wages']
}
