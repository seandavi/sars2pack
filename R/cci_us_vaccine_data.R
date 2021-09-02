#' Vaccine allocations and administrations in the United States
#' 
#' This data resource captures vaccine allocations, doses administered,
#' and the number of people (as opposed to doses) to which they have
#' been administered. As of December, 2020, this dataset is not complete.
#' 
#' @source 
#' - \url{https://github.com/govex/COVID-19/}
#' 
#' @import data.table
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @family data-import
#' @family vaccines
#' 
#' @return 
#' 
#' A `data.frame`
#' 
#' @examples 
#' 
#' vacc = cci_us_vaccine_data()
#' head(vacc)
#' 
#' 
#' us_pop = us_population_details(geography='state', product='population', 
#'   year=2019)
#' us_pop = us_pop[us_pop$variable=='POP',]
#' vac_pop = merge(us_pop,vacc,by.x="NAME",by.y="province_state")
#'
#' if(require('ggplot2')) {
#'   vac_pop[vac_pop$vaccine_type=='All' & vac_pop$stage_one_doses<1e7,] %>%
#'   ggplot(aes(x=date,y=stage_one_doses/value*100000, color=NAME)) +
#'     geom_line() + 
#'     ggtitle("Number of first vaccine doses delivered by state",'Cumulative counts') +
#'     xlab("Date") +
#'     ylab("Number of people vaccinated/100k population")
#' }
#'
#' @export
cci_us_vaccine_data = function() {
    url = 'https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/us_data/time_series/vaccine_data_us_timeline.csv'
    rpath = s2p_cached_url(url)
    dat = data.table::fread(rpath)
    data.table::setnames(dat, names(dat), tolower(names(dat)))
    dat[['date']]=lubridate::ymd(dat$date,quiet = TRUE)
    return(dat)
}