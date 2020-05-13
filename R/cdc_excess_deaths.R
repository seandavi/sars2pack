#' US CDC excess deaths by week from 2018 to present
#'
#' Understanding the potentially unmeasured death toll due to COVID-19
#' starts with understanding the expected vs observed death rates over
#' time. This dataset presents observed and expected deaths by state
#' by week of year for 2018 to present. In addition, the dataset can be
#' broken down into all cause death and that attributable to COVID-19
#' based on reported COVID-19 deaths.
#' 
#' @details
#'
#' Estimates of excess deaths can provide information about the burden
#' of mortality potentially related to COVID-19, beyond the number of
#' deaths that are directly attributed to COVID-19. Excess deaths are
#' typically defined as the difference between observed numbers of
#' deaths and expected numbers. This visualization provides weekly
#' data on excess deaths by jurisdiction of occurrence. Counts of
#' deaths in more recent weeks are compared with historical trends to
#' determine whether the number of deaths is significantly higher than
#' expected.
#'
#' Estimates of excess deaths can be calculated in a variety of ways,
#' and will vary depending on the methodology and assumptions about
#' how many deaths are expected to occur. Estimates of excess deaths
#' presented in this webpage were calculated using Farrington
#' surveillance algorithms (1). For each jurisdiction, a model is used
#' to generate a set of expected counts, and the upper bound of the
#' 95% Confidence Intervals (95% CI) of these expected counts is used
#' as a threshold to estimate excess deaths. Observed counts are
#' compared to these upper bound estimates to determine whether a
#' significant increase in deaths has occurred. Provisional counts are
#' weighted to account for potential underreporting in the most recent
#' weeks. However, data for the most recent week(s) are still likely
#' to be incomplete. Only about 60% of deaths are reported within 10
#' days of the date of death, and there is considerable variation by
#' jurisdiction. More detail about the methods, weighting, data, and
#' limitations can be found in the [Technical
#' Notes](https://www.cdc.gov/nchs/nvss/vsrr/covid19/excess_deaths.htm).
#'
#' @importFrom dplyr %>% filter mutate select rename
#' @importFrom readr read_csv
#' @importFrom lubridate week dmy
#' @importFrom ggplot2 vars ggplot geom_point geom_line facet_grid ggtitle aes
#'
#' @references
#' - \url{https://www.cdc.gov/nchs/nvss/vsrr/covid19/excess_deaths.htm}
#'
#' @source
#' - \url{https://data.cdc.gov/NCHS/Excess-Deaths-Associated-with-COVID-19/xkkf-xrst}
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' cdcdeaths = cdc_excess_deaths()
#' head(cdcdeaths)
#' colnames(cdcdeaths)
#' table(cdcdeaths$outcome)
#'
#' 
#' # Examine excess deaths in three states
#' library(ggplot2)
#' library(dplyr)
#' interesting_states = c('Ohio', 'Pennsylvania', 'California')
#' ggplot(cdcdeaths %>% dplyr::filter(type=="Predicted (weighted)" &
#'                             outcome=="All causes" &
#'                             state %in% interesting_states),
#'         aes(x=date,y=deaths)) +
#'     geom_point(aes(color=deaths>upper_bound_threshold)) +
#'     geom_line(aes(x=date,y=upper_bound_threshold)) +
#'     facet_grid(rows=vars(state)) +
#'     ggtitle('Excess deaths over time')
#'
#' @family data-import
#' 
#' @export
cdc_excess_deaths <- function() {
    dat = readr::read_csv("https://data.cdc.gov/api/views/xkkf-xrst/rows.csv?accessType=DOWNLOAD&bom=true&format=true",
                    guess_max = 10000,
                    col_types=cols()) %>%
        dplyr::rename(date='Week Ending Date') %>%
        dplyr::mutate(date = lubridate::mdy(date)) %>%
        dplyr::rename(
                   state="State",
                   type="Type",
                   outcome="Outcome",
                   suppress="Suppress",
                   deaths="Observed Number"
               ) %>%
        mutate(week_of_year=lubridate::week(date))
    colnames(dat) = stringr::str_replace_all(colnames(dat),' ', '_') %>% tolower()
    dat = dplyr::select(dat, -c(starts_with('total'), starts_with('percent'),year))
    dat
}
