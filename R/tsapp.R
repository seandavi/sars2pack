# private
make_cumul_events = function(count, dates, alpha3="USA", source="NYT", regtag=NA) {
    ans = list(count = count, dates = dates)
    attr(ans, "ProvinceState") = regtag
    attr(ans, "source") = source
    attr(ans, "alpha3") = alpha3
    attr(ans, "dtype") = "cumulative"
    class(ans) = c("cumulative_events", "covid_events")
    ans 
}
form_inc = function(src, regtag) {
 fullsumm = src %>% 
  select(state,date,count) %>% group_by(date) %>% 
   summarise(count=sum(count))  # counts by date collapsed over states
 thecum = make_cumul_events(count=fullsumm$count, dates=fullsumm$date, regtag=regtag)
 form_incident_events(thecum)
}


#' shiny app for appraisal of simple time-series models for COVID-19 incidence trajectories (old)
#' @importFrom dplyr summarise
#' @importFrom graphics lines par
#' @importFrom methods is
#' @importFrom stats arima model.matrix predict ts
#' @importFrom utils data str tail untar
tsapp_old = function() {
 basedate = "2020-03-15" # data prior to this date are dropped completely
 lookback_days = 29 # from present date
 nyd = nytimes_state_data() # cumulative
 allst = sort(unique(nyd$state))
 ui = fluidPage(
  sidebarLayout(
   sidebarPanel(
    helpText("COVID-19 incidence trajectories with simple time series models.
See 'About' tab for more details."),
    selectInput("source", "source", choices=c("fullusa", allst), selected="fullusa"),
    radioButtons("excl", "exclude from fullusa", choices=c("no", "New York", "Washington"), selected="no"),
    selectInput("trigcomp", "# trig components", choices=c("3", "4", "5", "6"), selected="4"),
    selectInput("MAorder", "MA order", choices=c("1", "2"), selected="2"),
    selectInput("trend", "trend", choices=c("linear", "quad"), selected="quad"),
    actionButton("stopper", "stop app"),
    width=2),
   mainPanel(
    tabsetPanel(
     tabPanel("traj",
      plotOutput("traj")
      ),
     tabPanel("rept",
      verbatimTextOutput("rept")
      ),
     tabPanel("about",
      helpText("This app was produced to help evaluate a claim that
an apparent decline in COVID-19 incidence for USA as a whole is driven by
the actual decline in incidence in New York.  As a by-product, models can
be fit for any US state.  The data are generated using `nytimes_state_data()`
in sars2pack."),
      helpText("Tab 'traj' is a plot of the last 29 days of incidence reports
with a trace of the time series model as selected using the input controls."),
      helpText("Tab 'rept' reports statistics from the `arima` function for
the selected model.")
      )
     )
    )
   )
  )
 server = function(input, output) {
  dofit = reactive({
   cbyd = dplyr::filter(nyd, date >= basedate & subset=="confirmed") 
   if (input$source == "fullusa" & input$excl != "no") cbyd = dplyr::filter(cbyd, state!=input$excl)
   else if (input$source != "fullusa") cbyd = dplyr::filter(cbyd, state==input$source)
   ibyd = form_inc(cbyd, regtag=input$source)
   iuse = trim_from(ibyd, basedate)
   full29 = tail(ibyd$count,lookback_days)
   dates29 = tail(ibyd$date,lookback_days)
   nlb=lookback_days-1
   time = (0:nlb)/nlb
#
# crude construction of trigonometric basis
#
   sx1 = sin(2*pi*time)
   cx1 = cos(2*pi*time)
   sx2 = sin(4*pi*time)
   cx2 = cos(4*pi*time)
   sx3 = sin(6*pi*time)
   cx3 = cos(6*pi*time)
   sx4 = sin(8*pi*time)
   cx4 = cos(8*pi*time)
   sx5 = sin(10*pi*time)
   cx5 = cos(10*pi*time)
   sx6 = sin(12*pi*time)
   cx6 = cos(12*pi*time)
#
# interactive selection of quadratic or linear trend
#
   polydeg = ifelse(input$trend=="linear", 1, 2)
   inds2use = list(ord6=c(2:13, 14:(14+polydeg-1)), ord5= c(2:11, 14:(14+polydeg-1)), 
      ord4=c(2:9, 14:(14+polydeg-1)), ord3=c(2:7,14:(14+polydeg-1)))
   ord2use = ifelse(input$MAorder==1, 1, 2)
#
# full basis matrix, which is filtered below to reduce trig order or trend type
#
   trig4 = model.matrix(~sx1+cx1+sx2+cx2+sx3+cx3+sx4+cx4+sx5+cx5+sx6+cx6+poly(time, polydeg))
   tsfull = ts(full29, freq=1)
   tro = c(NA, NA, "ord3", "ord4", "ord5", "ord6")
   xreg2use = trig4[, inds2use[[tro[as.numeric(input$trigcomp)]]]]
   arma.full = arima(tsfull, order=c(0,0,ord2use), xreg=xreg2use)
   pr = predict(arma.full, newxreg=xreg2use)
   list(fit=arma.full, pred=pr, tsfull=tsfull, dates29=dates29)
   })
  output$traj = renderPlot({
   ans = dofit()
   plot(ans$dates29, ans$tsfull, pch=19, ylab="confirmed incidence", xlab="Date")
   lines(ans$dates29, ans$pr$pred, lwd=2, col="purple")
   })
  output$rept = renderPrint({ ans = dofit()
   ans$fit
   })
  observeEvent(input$stopper, {
       ans = dofit()
       stopApp(returnValue=ans$fit)
       })  

  }
 runApp(list(ui=ui, server=server))
}

#' shiny app for appraisal of simple time-series models for COVID-19 incidence trajectories
#' @export
tsapp = function() {
 od = getwd()
 on.exit(setwd(od))
 uif = system.file("tsapp/ui.R", package="sars2pack")
 servf = system.file("tsapp/server.R", package="sars2pack")
 td = tempdir()
 setwd(td)
 file.copy(uif, ".", overwrite=TRUE)
 file.copy(servf, ".", overwrite=TRUE)
 shiny::runApp()
}

