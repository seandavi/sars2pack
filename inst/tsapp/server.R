attach_if_needed = function(pk) {
  sr = search()
  if (!(paste0("package:", pk) %in% sr)) library(pk, character.only=TRUE)
}

attach_if_needed("shiny")
attach_if_needed("sars2pack")
attach_if_needed("dplyr")
attach_if_needed("forecast")


 basedate = "2020-03-15" # data prior to this date are dropped completely
 lookback_days = 29 # from present date
 if (!exists(".nyd.global")) .nyd.global <<- nytimes_state_data() # cumulative
 if (!exists(".jhu.global")) .jhu.global <<- enriched_jhu_data() # cumulative
 allst = sort(unique(.nyd.global$state))

 server = function(input, output) {
  dofit = reactive({
   if (input$source == "fullusa" & input$excl == "no") curfit = Arima_nation(.jhu.global, MAorder=input$MAorder)
   else if (input$source == "fullusa" & input$excl != "no") 
        curfit = Arima_drop_state(.jhu.global, .nyd.global, state.in=input$excl, MAorder=input$MAorder)
   else if (input$source != "fullusa") curfit = Arima_by_state(.nyd.global, state.in=input$source, MAorder=input$MAorder)
   list(fit=curfit, pred=fitted.values(forecast(curfit$fit)), tsfull=curfit$tsfull, dates29=curfit$dates29, 
        wald.trend=NA)
   })
  output$traj = renderPlot({
   ans = dofit()
   plot(ans$fit)
   })
  output$rept = renderPrint({ 
    ans = dofit()
    ans$fit
   })
  observeEvent(input$stopper, {
       ans = dofit()
       stopApp(returnValue=ans$fit)
       })  

  }
