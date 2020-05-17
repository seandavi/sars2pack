#' provide vector of contiguous US state names and DC
#' @export
contig_states_dc = function() c("Alabama", "Arizona", "Arkansas", "California", "Colorado", 
"Connecticut", "Delaware", "District of Columbia", "Florida", 
"Georgia", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", 
"Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", 
"Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", 
"Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", 
"New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", 
"Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
"Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", 
"West Virginia", "Wisconsin", "Wyoming")

#' provide vector of contiguous US state names and DC, abbr
#' @export
contig_states_twolet = function() {
c("AL", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", 
"ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", 
"MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", 
"ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", 
"VT", "VA", "WA", "WV", "WI", "WY")
}

# from https://worldpopulationreview.com/states/
pops = c(California = 39937489, Texas = 29472295, Florida = 21992985, 
`New York` = 19440469, Pennsylvania = 12820878, Illinois = 12659682, 
Ohio = 11747694, Georgia = 10736059, `North Carolina` = 10611862, 
Michigan = 10045029, `New Jersey` = 8936574, Virginia = 8626207, 
Washington = 7797095, Arizona = 7378494, Massachusetts = 6976597, 
Tennessee = 6897576, Indiana = 6745354, Missouri = 6169270, Maryland = 6083116, 
Wisconsin = 5851754, Colorado = 5845526, Minnesota = 5700671, 
`South Carolina` = 5210095, Alabama = 4908621, Louisiana = 4645184, 
Kentucky = 4499692, Oregon = 4301089, Oklahoma = 3954821, Connecticut = 3563077, 
Utah = 3282115, Iowa = 3179849, Nevada = 3139658, Arkansas = 3038999, 
`Puerto Rico` = 3032165, Mississippi = 2989260, Kansas = 2910357, 
`New Mexico` = 2096640, Nebraska = 1952570, Idaho = 1826156, 
`West Virginia` = 1778070, Hawaii = 1412687, `New Hampshire` = 1371246, 
Maine = 1345790, Montana = 1086759, `Rhode Island` = 1056161, 
Delaware = 982895, `South Dakota` = 903027, `North Dakota` = 761723, 
Alaska = 734002, `District of Columbia` = 720687, Vermont = 628061, 
Wyoming = 567025)


make_cumul_events = function(count, dates, 
    alpha3="USA", source="NYT", regtag=NA) {
    ans = list(count = count, dates = dates)
    attr(ans, "ProvinceState") = regtag
    attr(ans, "source") = source
    attr(ans, "alpha3") = alpha3
    attr(ans, "dtype") = "cumulative"
    class(ans) = c("cumulative_events", "covid_events")
    ans 
}

form_inc_state = function(src, regtag) {
 fullsumm = src %>% 
  dplyr::select(state,date,count) %>% group_by(date) %>% 
   summarise(count=sum(count))  # counts by date collapsed over states
 thecum = make_cumul_events(count=fullsumm$count, dates=fullsumm$date, regtag=regtag)
 form_incident_events(thecum)
}

form_inc_nation = function(src, regtag) {
 fullsumm = src %>% 
  dplyr::select(date,count) %>% group_by(date) %>% 
   summarise(count=sum(count))  # counts by date 
 thecum = make_cumul_events(count=fullsumm$count, dates=fullsumm$date, regtag=regtag)
 form_incident_events(thecum)
}

#' Use Rob Hyndman's forecast package to estimate drift in ARIMA models
#' @import forecast
#' @importFrom lubridate as_date
#' @param src a tibble as returned by nytimes_state_data() or jhu_us_data()
#' @param state.in character(1) state name
#' @param MAorder numeric(1) order of moving average component
#' @param trend character(1) if "linear" differencing order for ARIMA=1, else 2
#' @param basedate character(1) used by lubridate::as_date to filter away all earlier records
#' @param lookback_days numeric(1) only uses this many days from most recent in src
#' @param ARorder order of autoregressive component
#' @return instance of S3 class Arima_sars2pack
#' @examples
#' nyd = nytimes_state_data()
#' lkny = Arima_by_state(nyd)
#' lkny
#' plot(lkny)
#' usd = jhu_us_data()
#' lkny2 = Arima_by_state(usd)
#' lkny2
#' plot(lkny2)
#' @export
Arima_by_state = function(src, state.in="New York", MAorder=2, 
   trend="linear", basedate="2020-03-15", lookback_days=29, ARorder=0) {
   cbyd = dplyr::filter(src, date >= basedate & subset=="confirmed" & state==state.in) 
   ibyd = form_inc_state(cbyd, regtag=state.in)
   .Arima_inc(ibyd, state.in=state.in, MAorder=MAorder,
      trend=trend, basedate=basedate, lookback_days=lookback_days, ARorder=ARorder)
   }

#' Use Rob Hyndman's forecast package to estimate drift in ARIMA models
#' @param ejhu a tibble as returned by `enriched_jhu_data()`
#' @param alp3 character(1) alpha3Code value for country
#' @param MAorder numeric(1) order of moving average component
#' @param trend character(1) if "linear" differencing order for ARIMA=1, else 2
#' @param basedate character(1) used by lubridate::as_date to filter away all earlier records
#' @param lookback_days numeric(1) only uses this many days from most recent in ejhu
#' @param ARorder order of autoregressive component
#' @return instance of S3 class Arima_sars2pack
#' @examples
#' ej = enriched_jhu_data()
#' lkus = Arima_nation(ej)
#' lkus
#' plot(lkus)
#' @export
Arima_nation = function(ejhu, alp3="USA", MAorder=2,
   trend="linear", basedate="2020-03-15", lookback_days=29, ARorder=0) {
   cbyd = dplyr::filter(ejhu, date >= basedate & subset=="confirmed" & alpha3Code==alp3)
   ibyd = form_inc_nation(cbyd, regtag=alp3)
   .Arima_inc(ibyd, state.in=alp3, MAorder=MAorder,
      trend=trend, basedate=basedate, lookback_days=lookback_days, ARorder=ARorder)
   }

.Arima_inc = function(ibyd, state.in="New York", MAorder=2, 
   trend="linear", basedate="2020-03-15", lookback_days=29, ARorder=0) {
   iuse = trim_from(ibyd, basedate)
   full29 = tail(ibyd$count,lookback_days)
   dates29 = tail(ibyd$date,lookback_days)
   nlb=lookback_days-1
   time = (0:nlb)/nlb
#
# interactive selection of quadratic or linear trend, MA order 
#
   difforder = ifelse(trend=="linear", 1, 2)
   MAord2use = MAorder
#
# full basis matrix, which is filtered below to reduce trig order or trend type

   origin = max(ibyd$date)-lookback_days+1
   time.from.origin = as.numeric(dates29-origin)
   tsfull = ts(full29, freq=1)
   Arima.full = Arima(tsfull, order=c(ARorder,difforder,MAord2use), include.drift=TRUE)
   pr = fitted.values(forecast(Arima.full))
   ans = list(fit=Arima.full, pred=pr, tsfull=tsfull, dates29=dates29, time.from.origin=time.from.origin,
        call=match.call(),
        state=state.in, origin=as_date(origin))
   class(ans) = "Arima_sars2pack"
   ans
}

#' @export
print.Arima_sars2pack = function(x, ...) {
 cat("Arima_sars2pack instance for", x$state, "\n  computed", date(),  "\n")
 cat("  call was: ")
 print(x$call)
 cat("  Model estimates: \n")
 summary(x$fit)
}

#' @export
plot.Arima_sars2pack = function(x, y, ...) {
 y_ = x$tsfull
 x_ = x$origin+x$time.from.origin
 plot(x_, y_, pch=19, xlab="date", ylab="incidence", ...)
 lines(x$origin+x$time.from.origin, x$pred)
 slo = coef(x$fit)["drift"]
 y1 = x$pred[29]
 y0 = y1 + slo*(-as.numeric(x$origin)-28) # x$time.from.origin[29] = 28
 abline(y0, slo, lty=2)
 se = sqrt(x$fit$var.coef["drift", "drift"])
 y1b = slo*(14+as.numeric(x$origin))+y0
 y0p = y1b + (slo+1.96*se)*(-as.numeric(x$origin)-14) # x$time.from.origin[1] = 0
 y0m = y1b + (slo-1.96*se)*(-as.numeric(x$origin)-14) # x$time.from.origin[1] = 0
 abline(y0p, slo+1.96*se, lty=3)
 abline(y0m, slo-1.96*se, lty=3)
}

#' fit ARIMA model to US data dropping one state
#' @param src_us tibble for national level data like that of enriched_jhu_data()
#' @param src_st tibble for state level data like that of nytimes_state_data()
#' @param state.in character(1) state name
#' @param MAorder numeric(1) order of moving average component
#' @param trend character(1) if "linear" differencing order for ARIMA=1, else 2
#' @param basedate character(1) used by lubridate::as_date to filter away all earlier records
#' @param lookback_days numeric(1) only uses this many days from most recent in src
#' @param ARorder order of autoregressive component
#' @return instance of S3 class Arima_sars2pack
#' @note Apparent discrepancies in counts in vicinity of April 15 between
#' NYT and JHU for full US incidence lead us to employ the two sources
#' for the example.  If NYT alone is used, summing to obtain USA
#' overall, the resulting USA incidence trend is
#' extravagantly variable.
#' @examples
#' ej = enriched_jhu_data()
#' usa_full = Arima_nation(ej)
#' plot(usa_full)
#' nyd = nytimes_state_data()
#' drny = Arima_drop_state(ej, nyd)
#' drny
#' plot(drny)
#' opar = par(no.readonly=TRUE)
#' par(mar=c(4,3,2,2), mfrow=c(1,2))
#' plot(usa_full, main="all states", ylim=c(17000,38000))
#' plot(drny, main="excluding NY", ylim=c(17000,38000))
#' par(opar)
#' @export
Arima_drop_state = function(src_us, src_st, state.in="New York", MAorder=2, 
   trend="linear", basedate="2020-03-15", lookback_days=29, ARorder=0) {
   nat = Arima_nation(src_us, MAorder=MAorder, trend=trend, basedate=basedate,
         lookback_days=lookback_days, ARorder=ARorder)
   st = Arima_by_state(src_st, state.in=state.in, MAorder=MAorder, trend=trend, basedate=basedate,
         lookback_days=lookback_days, ARorder=ARorder)
   cbyd_shim = dplyr::filter(src_st,  # shim
            date >= basedate & subset=="confirmed" & state==state.in)
   ibyd_shim = form_inc_state(cbyd_shim, regtag=state.in)
   ibyd_shim$count = as.numeric(nat$tsfull)-as.numeric(st$tsfull)
   .Arima_inc(ibyd_shim, state.in=state.in, MAorder=MAorder,
      trend=trend, basedate=basedate, lookback_days=lookback_days, ARorder=ARorder)
   }

#' full incidence for contiguous states
#' @inheritParams Arima_drop_state
#' @param contig_vec character() vector of tokens for subsetting src
#' @examples
#' usd = usa_facts_data()
#' cont = Arima_contig_states(usd)
#' cont
#' plot(cont)
#' @export
Arima_contig_states = function(src, state.in="All contig", MAorder=2, 
   trend="linear", basedate="2020-03-15", lookback_days=29, ARorder=0,
   contig_vec = contig_states_twolet()) {
   cbyd = dplyr::filter(src, date >= basedate & 
       subset=="confirmed" & state %in% contig_vec)
   ibyd = form_inc_state(cbyd, regtag=state.in)
   .Arima_inc(ibyd, state.in="all", MAorder=MAorder,
      trend=trend, basedate=basedate, lookback_days=lookback_days, ARorder=ARorder)
   }
