make_full_map = function(nytc, cg, date.start="2020-04-01", date.end="2020-04-01", offset=0) {
 if (date.start!=date.end) stop("aggregation not ready; date.start must equal date.end")
 date.start = as_date(date.start)+offset
 date.end = as_date(date.end)+offset
 cg %>% 
    left_join(
        nytc %>% 
        group_by(fips) %>% 
        filter(date>=date.start & date<=date.end & count>0 & subset=='confirmed' & !is.na(count)), by=c('GEOID'='fips')) %>% 
    mutate(mid=sf::st_centroid(geometry))
}

#' demonstration 'dynamic' regional map, shows some issues with legend control, needs optimization
#' @import shiny
#' @import ggplot2
#' @import tmap
#' @import dplyr
#' @import htmltools
#' @import htmlwidgets
#' @importFrom lubridate as_date
#' @examples
#' if (interactive()) {
#'  if (!exists("nyt_counties")) nyt_counties = nytimes_county_data()
#'  if (!exists("county_geom")) county_geom = tidycensus::county_laea
#'  regapp( nyt_counties, county_geom, indate="2020-03-15")
#' }
#' @export
regapp = function(nytc, cg, indate="2020-03-15") {
ui = fluidPage(
 sidebarLayout(
  sidebarPanel(
   numericInput("offs", "advance", value=0, min=-10, max=15), 
   width=3
   ),
  mainPanel(
   plotOutput("p", height="600px")
  )
 )
)
server = function(input, output) {
 output$p = renderPlot({
 validate(need(is.numeric(input$offs), "enter 'advance' value"))
 regional_map_for_date(nytc, cg, offset=input$offs, 
     date=indate, crop.vec=c(xmin=-80, xmax=-65, ymin=40, ymax=48))
 })
}
runApp(list(ui=ui, server=server))
}

# needs better design
regional_map_for_date = function(nytc, cg, offset=0, date="2020-04-01", 
    crop.vec=c(xmin=-80, xmax=-65, ymin=40, ymax=48)) {
 full_map = make_full_map(nytc = nytc, cg = cg, date.start=date, date.end=date, offset=offset)
 ftx = st_transform(full_map, crs=4326) 
 lm = st_crop(ftx, crop.vec) # note -- the mid values need to be transformed too
 mm = lm$mid
 mmm = st_transform(mm, crs=4326) 
 lm$mid = mmm
 ggplot(lm, aes(label=county)) +
    geom_sf(aes(geometry=geometry),color='grey85') +
    geom_sf(aes(geometry=mid, size=count), alpha=0.5, show.legend = "point") +
#    geom_sf(aes(geometry=mid, size=count, color=count), alpha=0.5, show.legend = "point") +
    scale_size(breaks=c(1,10,100,1000,10000,50000,100000)) +
    ggtitle(as.character(as_date(as_date(date)+offset)))
#    scale_color_gradient2(midpoint=5500, low="lightblue", mid="orange",high="red", space ="Lab" ) +
#    scale_size(range=c(1,10)) + 
}



