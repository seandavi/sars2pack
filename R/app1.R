#' demonstrative app for EpiEstim R[t] sensitivity analysis
#' @import shiny
#' @import EpiEstim
#' @param src intended to be the result of sars2pack::nytimes_state_data(), no checking is done.
#' @note This app is currently incomplete.  Additions needed include 1) accommodation of
#' standard deviation of parametric serial interval distribution, 2) additional
#' approaches to serial interval modeling, 3) enhancement of displays to present actual
#' calendar dates, 4) an approach to supporting comparative displays, particularly allowing
#' overlay of different R[t] fits for different serial interval modeling assumptions.
#' @examples
#' \dontrun{
#'  nytdat = nytimes_state_data()
#'  eesi(nytdat)
#' }
#' @export
eesi = function(src) {  # intended to run with nyt state data
 states = sort(unique(src$state))
 ui = fluidPage(
  sidebarLayout(
   sidebarPanel(
    helpText(h3("R[t] displays with sensitivity analysis for serial interval model selections")),
    helpText(h5("Computations are a blend of ",
     a( href="https://cran.r-project.org/package=EpiEstim", target="_blank", "EpiEstim"), 
     "::estimate_R and ",
     a( href="https://seandavi.github.io/sars2pack/", target="_blank", "sars2pack")," data acquisition.  See",
     a( href="https://academic.oup.com/aje/article-lookup/doi/10.1093/aje/kwt133", target="_blank", "Cori et al. (2013)."), 
     "for details.")),
    selectInput("stsel", "state", choices=states, selected="Massachusetts"),
    dateInput("inidat", "Start of outbreak", value="2020-03-15", min="2020-01-01",
       max="2020-04-01"),
    radioButtons("sitype", "Serial Interval Method",
      choices=c("2009 flu", "parametric"), selected="2009 flu"),
    conditionalPanel(
     condition = "input.sitype == 'parametric'",
       numericInput("parmn", "mean SI", min=1, max=6, step=.1,
                      value=3.8)
     ),
    numericInput("winsz", "window size", min=1, max=14, step=1,
                   value=7),
    width=3),
   mainPanel(
    tabsetPanel(
     tabPanel("views",
      plotOutput("plR", height="300px"),
      plotOutput("plSI", height="300px"),
      plotOutput("plI", height="300px")
      )
     )
    )
   )
  )
 server = function(input, output) {
  output$pl2 = renderPlot({ plot(1) })
  comput = reactive({
   ccur = cumulative_events_nyt_state(src, eventtype = "confirmed",
    statename=input$stsel)
   icur = form_incident_events(trim_from(ccur, input$inidat))
   nt = length(icur$count)
   starts = seq_len(nt)
   ends = starts + input$winsz - 1
   drop = which(ends > nt)
   starts = starts[-drop][-1]
   ends = ends[-drop][-1]
   if (input$sitype == "2009 flu") {
     data("Flu2009", package="EpiEstim")
     ans = EpiEstim::estimate_R(incid = icur$count, method="non_parametric_si",
                        config = make_config(list(si_distr = Flu2009$si_distr,
                          t_start=starts, t_end=ends)))
     } else {
     ans = EpiEstim::estimate_R(incid = icur$count, method="parametric_si",
      config=make_config(list(mean_si=input$parmn, std_si=4.8,
                          t_start=starts, t_end=ends))) 
     }
    ans
   })
  output$plR = renderPlot({
   plot(comput(), what="R")
   })
  output$plSI = renderPlot({
   plot(comput(), what="SI")
   })
  output$plI = renderPlot({
   plot(comput(), what="incid")
   })
  }
 runApp(list(ui=ui, server=server))
 }
   
