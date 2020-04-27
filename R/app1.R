#' demonstrative app for EpiEstim R[t] sensitivity analysis
#' @import shiny
#' @import EpiEstim
#' @param src intended to be the result of sars2pack::nytimes_state_data(), no checking is done.
#' @param mean_si_trunc_radius numeric(1) 
#' @param std_si_trunc_radius numeric(1) 
#' @param std_mean_si numeric(1) used with 'uncertain' serial interval option, see EpiEstim::make_config
#' @param std_std_si numeric(1) used with 'uncertain' serial interval option, see EpiEstim::make_config
#' @param n1 numeric(1) used with 'uncertain' serial interval option, see EpiEstim::make_config
#' @param n2 numeric(1) used with 'uncertain' serial interval option, see EpiEstim::make_config
#' @note This app is currently incomplete.  Additions needed include 
#' 2) additional
#' approaches to serial interval modeling, 3) enhancement of displays to present actual
#' calendar dates, 4) an approach to supporting comparative displays, particularly allowing
#' overlay of different R[t] fits for different serial interval modeling assumptions.
#' @examples
#' # must run example(eesi, ask=FALSE)
#' if (interactive()) {
#'  nytdat = nytimes_state_data()
#'  eesi(nytdat)
#' }
#' @export
eesi = function(src,
 mean_si_trunc_radius = 3,
 std_si_trunc_radius = 3,
 std_mean_si = 3, 
 std_std_si = 5,
 n1 = 100,
 n2 = 100) {  # intended to run with nyt state data
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
      choices=c("2009 flu", "uncertain"), selected="2009 flu"),
    conditionalPanel(
     condition = "input.sitype == 'uncertain'",
       numericInput("parmn", "mean SI", min=1, max=6, step=.1,
                      value=4),
       numericInput("parmnsd", "SD SI", min=.5, max=12, step=.1,
                      value=5)
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
   icurdf = data.frame(I=icur$count, dates=icur$date)
   nt = length(icur$count)
   starts = seq_len(nt)
   ends = starts + input$winsz - 1
   drop = which(ends > nt)
   starts = starts[-drop][-1]
   ends = ends[-drop][-1]
   if (input$sitype == "2009 flu") {
     data("Flu2009", package="EpiEstim")
     ans = EpiEstim::estimate_R(incid = icurdf, method="non_parametric_si",
                        config = make_config(list(si_distr = Flu2009$si_distr,
                          t_start=starts, t_end=ends)))
     } else {
     print(c(minm=input$parmn-mean_si_trunc_radius, m=input$parmn, maxm=input$parmn+mean_si_trunc_radius))
     ans = EpiEstim::estimate_R(incid = icurdf, method="uncertain_si",
      config=make_config(list(mean_si=input$parmn, std_si=input$parmnsd,
             std_mean_si=std_mean_si, min_mean_si=max(c(1,input$parmn-mean_si_trunc_radius)),
             max_mean_si=input$parmn+mean_si_trunc_radius,
             std_std_si=std_std_si, min_std_si=max(c(.5, input$parmnsd-std_si_trunc_radius)),
            max_std_si=input$parmnsd+std_si_trunc_radius, n1=n1, n2=n2,
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
   
