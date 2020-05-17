attach_if_needed = function(pk) {
  sr = search()
  if (!(paste0("package:", pk) %in% sr)) library(pk, character.only=TRUE)
}

attach_if_needed("shiny")
attach_if_needed("sars2pack")
attach_if_needed("dplyr")
attach_if_needed("forecast")

# private
#make_cumul_events = function(count, dates, alpha3="USA", source="NYT", regtag=NA) {
#    ans = list(count = count, dates = dates)
#    attr(ans, "ProvinceState") = regtag
#    attr(ans, "source") = source
#    attr(ans, "alpha3") = alpha3
#    attr(ans, "dtype") = "cumulative"
#    class(ans) = c("cumulative_events", "covid_events")
#    ans 
#}
#form_inc = function(src, regtag) {
# fullsumm = src %>% 
#  select(state,date,count) %>% group_by(date) %>% 
#   summarise(count=sum(count))  # counts by date collapsed over states
# thecum = make_cumul_events(count=fullsumm$count, dates=fullsumm$date, regtag=regtag)
# form_incident_events(thecum)
#}
#
# ui code starts here
 basedate = "2020-03-15" # data prior to this date are dropped completely
 lookback_days = 29 # from present date
 if (!exists(".nyd.global")).nyd.global <<- nytimes_state_data() # cumulative
 if (!exists(".jhu.global")) .jhu.global <<- enriched_jhu_data() # cumulative
 allst = sort(unique(.nyd.global$state))
 ui = fluidPage(
  sidebarLayout(
   sidebarPanel(
    helpText("COVID-19 incidence trajectories with simple time series models.
Code derived from the ", a(href="https://seandavi.github.io/sars2pack", "sars2pack"),
" data science and documentation portal.
See 'About' tab for additional details."),
    selectInput("source", "source", choices=c("fullusa", allst), selected="fullusa"),
    radioButtons("excl", "exclude from fullusa", choices=c("no", "New York", "Washington"), selected="no"),
    selectInput("trigcomp", "# trig components", choices=c("3", "4", "5", "6"), selected="5"),
    numericInput("MAorder", "MA order", min=1, max=4, value=2), # choices=c("1", "2"), selected="2"),
    numericInput("Difforder", "Difforder", min=0, max=2, value=1),
    actionButton("stopper", "stop app"),
    width=3),
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
the actual decline in incidence in New York.  See ",
a(href="https://www.erinbromage.com/post/the-risks-know-them-avoid-them",
"Erin Bromage's blog post"),"  As a by-product, models can
be fit for any US state.  The data are generated using `nytimes_state_data()`
in sars2pack."),
      helpText("Tab 'traj' is a plot of the last 29 days of incidence reports
with a trace of the time series model as selected using the input controls."),
      helpText("Tab 'rept' reports statistics from the `arima` function for
the selected model."),
      helpText("The trigonometric component of the model is inspired by ", 
a(href="http://webpopix.org/covidix19.html#parameter-estimation-and-model-selection", "work of"),
" Marc Lavielle.  The modeling used in this app is however completely elementary and uses only base R.")
      )
     )
    )
   )
  )
