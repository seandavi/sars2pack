
library(shiny)
library(sars2app)
library(dplyr)
library(forecast)
library(shinytoastr)

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
 basedate = "2020-02-15" # data prior to this date are dropped completely
 lookback_days = 29 # from present date
 if (!exists(".nyd.global")).nyd.global <<- nytimes_state_data() # cumulative
 if (!exists(".jhu.global")) .jhu.global <<- enriched_jhu_data() # cumulative
 allst = sort(unique(.nyd.global$state))
 ui = fluidPage(
  shinytoastr::useToastr(),
  sidebarLayout(
   sidebarPanel(
    helpText("COVID-19 incidence trajectories with simple time series models.
Code derived from the ", a(href="https://seandavi.github.io/sars2pack", "sars2pack"),
" data science and documentation portal.
See 'About' tab for additional details."),
    selectInput("source", "source", choices=c("fullusa", allst), selected="fullusa"),
    radioButtons("excl", "exclude from fullusa", choices=c("none", "New York", "NY,NJ", "NY,NJ,MA",
                  "NY,NJ,MA,PA"), selected="none"),
    dateInput("maxdate", "look back from", min="2020-03-15", max=max(lubridate::as_date(.nyd.global$date)),
         value=max(lubridate::as_date(.nyd.global$date))),
    numericInput("MAorder", "MA order", min=0, max=6, value=3), 
    numericInput("ARorder", "AR order", min=0, max=6, value=3), # May 22 opt for USA
    numericInput("Difforder", "Difforder", min=0, max=2, value=1),
    actionButton("stopper", "stop app"),
    width=3),
   mainPanel(
    tabsetPanel(
     tabPanel("traj",
      plotOutput("traj", height="425px"),
      helpText("EpiEstim model for R[t] using MCMC-based Gamma model for serial interval:"),
      plotOutput("Rtplot", height="425px")
      ),
     tabPanel("rept",
      verbatimTextOutput("rept"),
      plotOutput("tsdiag")
      ),
     tabPanel("meta",
      verbatimTextOutput("meta.rept"),
      plotOutput("metaplot", height=700)
      ),
     tabPanel("about",
      helpText("This app was produced to help evaluate a claim that
an apparent decline in COVID-19 incidence for USA as a whole is driven by
the actual decline in incidence in New York.  See ",
 a(href="https://www.erinbromage.com/post/the-risks-know-them-avoid-them",
"Erin Bromage's blog post."),"  As a by-product, models can
be fit for any US state.  The data are generated using `nytimes_state_data()`
in sars2pack."),
      helpText("Tab 'traj' include two displays.  At the top is a plot of the last 29 days of incidence reports
with a trace of the fitted time series model as selected using the input controls.  Below that
is a display of the fit of an `EpiEstim estimate_R` run with an MCMC-based
model for the serial interval; see the ", a(href='https://github.com/seandavi/sars2pack',
"doMCMC vignette of sars2pack.", target="_blank")),
      helpText("Tab 'rept' reports statistics from the `forecast::Arima` function for
the selected model, and display the result of tsdiag()."),
      helpText("Tab 'meta' reports meta-analysis results using the rmeta package.
The time series model for each state employs autoregressive and moving average
orders selected by minimizing BIC over a grid of choices ranging from 0 to 5
for each parameter.  Note that this minimization was conducted for data available
20 May 2020.  Users can update these selections in their own
interactive R sessions using 'min_bic_all_states' and supplying the result to `run_meta`."),
      helpText(paste("This app is defined in", packageVersion("sars2pack"), "of sars2pack."))
      )
     )
    )
   )
  )
