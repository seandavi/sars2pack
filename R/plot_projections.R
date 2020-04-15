#' plot the disease course and death projections
#'
#' Using data from \url{https://covid19.healthdata.org/projections}, either
#' render a plot or return a ggplot object for further manipulation.
#'
#' @details
#' This function is a convenience function to return a ggplot2 object that
#' displays projections for a given location. Projections are typically
#' coming from a call to `healthdata_projections_data()`. If assigned to a
#' variable, the results can be further manipulated or passed into any
#' function that accepts a ggplot2 object (like plotly, cowplot, etc.). See
#' examples for details.
#' 
#' @param metrics character vector of metrics to include on plot.
#'   Get a list of these from the `metric` column.
#'
#' @param projections supply a data.frame, typically from a call to
#'   `healthdata_projections_data()`. This data.frame must have columns
#'   that include `date`, `location_name`, `metric`, `mean`, `upper`, and `lower`.
#'
#' @param location_name character(1), chosen from `unique(projections$location_name)`
#'   that is used to filter the projections data.frame to one location.
#'
#' @import magrittr
#' @importFrom ggplot2 geom_line geom_ribbon ggplot theme
#' 
#' @source \url{https://covid19.healthdata.org/projections}
#'
#' @family plotting
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @seealso healthdata_projections_data()
#'
#' @examples
#' library(sars2pack)
#' 
#' hdp = healthdata_projections_data()
#'
#' library(ggplot2)
#' # possible locations
#' sort(unique(hdp$location_name))
#'
#' # create a ggplot2 object
#' nyp = plot_projection(projections = hdp,
#'     location_name='New York')
#'
#' # and do the plot
#' print(nyp)
#'
#' # Zoomable html version using plotly
#' if(require(plotly)) {
#'   ggplotly(nyp)
#' }
#'
#' # California
#' calip = plot_projection(projections = hdp,
#'     location_name='California')
#' print(calip)
#'
#' # entire US
#' plot_projection(location_name = "United States of America", projections = hdp)
#' 
#'
#' # Compare two countries
#' spain_proj = plot_projection(location_name = "Spain", projections = hdp)
#' portugal_proj = plot_projection(location_name = "Portugal", projections = hdp)
#' #'
#' print(spain_proj)
#' print(portugal_proj)
#'
#' # plot both on same plot
#' if(require(cowplot)) {
#'   plot_grid(spain_proj, portugal_proj)
#' }
#'
#' @export
plot_projection <- function(location_name,
                            projections = healthdata_projections_data(),
                            metrics = unique(projections$metric)) {
    alocation_name = location_name
    ametrics = metrics
    gp = subset(projections, (location_name == alocation_name) & (metrics %in% ametrics)) %>%
        ggplot(aes(x=date, y=mean)) +
        geom_line(aes(color=metric)) +
        theme(legend.position = "bottom") +
        geom_ribbon(aes(ymin=lower,ymax=upper, fill=metric), alpha=0.25)
    gp
}
