#' Vaccine allocations and administrations in the United States
#' 
#' This data resource captures vaccine allocations, doses administered,
#' and the number of people (as opposed to doses) to which they have
#' been administered. As of December, 2020, this dataset is not complete.
#' 
#' @source 
#' - \url{https://github.com/govex/COVID-19/tree/master/data_tables/vaccine_data}
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
#' table(vacc$unit)
#' table(vacc$status)
#' table(vacc$entity)
#' 
#' us_pop = us_population_details(geography='state', product='population', year=2019)
#' us_pop = us_pop[us_pop$variable=='POP',]
#' vacc = vacc[vacc$variable=='people_admin_first-dose',]
#' vac_pop = merge(us_pop,vacc,by.x="NAME",by.y="province_state")
#'
#' if(require('ggplot2')) {
#'   ggplot(vac_pop, aes(x=date,y=count/value*100000, color=stabbr)) +
#'     geom_line() + ggtitle("Number of first vaccine doses delivered by state",'Cumulative counts') +
#'     xlab("Date") +
#'     ylab("Number of people vaccinated/100k population")
#' }
#'
#' @export
cci_us_vaccine_data = function() {
    url = 'https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/raw_data/vaccine_data_us_state_timeline.csv'
    rpath = s2p_cached_url(url)
    dat = data.table::fread(rpath)
    storage.mode(dat$people_total_2nd_dose)="integer"
    data.table::setnames(dat, names(dat), tolower(names(dat)))
    data.table::setnames(dat, c('people_total', 'people_total_2nd_dose'),
                         c('people_admin_first-dose','people_admin_second-dose'))
    dat[['date']]=lubridate::mdy(dat$date,quiet = TRUE)
    dat[, dashboard_available := NULL]
    dat = data.table::melt(dat,id=1:3, value.name='count')
    dat[, c("unit","status","entity"):= data.table::tstrsplit(variable,'_')]
    dat[!is.na(dat$count)][]
}