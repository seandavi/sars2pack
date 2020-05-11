#' Longitudinal tracking of government interventions to combat COVID-19
#' 
#' Governments are taking a wide range of measures in response to the COVID-19 outbreak. The Oxford COVID-19 Government Response Tracker (OxCGRT) aims to track and compare government responses to the coronavirus outbreak worldwide rigorously and consistently.
#'
#' Systematic information on which governments have taken which measures, and when, can help decision-makers and citizens understand the robustness of governmental responses in a consistent way, aiding efforts to fight the pandemic. The OxCGRT systematically collects information on several different common policy responses governments have taken, scores the stringency of such measures, and aggregates these scores into a common Stringency Index.
#'
#' Data is collected from public sources by a team of dozens of Oxford University students and staff from every part of the world.
#' 
#' OxCGRT collects publicly available information on 11 indicators of government response (S1-S11). The first seven indicators (S1-S7) take policies such as school closures, travel bans, etc. are recorded on an ordinal scale; the remainder (S8-S11) are financial indicators such as fiscal or monetary measures. For a full description of the data and how it is collected, see this working paper.
#' 
#' Recommended citation for database: Hale, Thomas and Samuel Webster (2020). Oxford COVID-19 Government Response Tracker. Data use policy: Creative Commons Attribution CC BY standard.
#'
#' @importFrom readr read_csv cols
#' @importFrom lubridate ymd
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @source 
#' - \url{https://www.bsg.ox.ac.uk/research/research-projects/oxford-covid-19-government-response-tracker}
#'
#' @family data-import
#' @family NPI
#' 
#' 
#' @examples
#' library(dplyr)
#' res = government_policy_timeline()
#' head(res)
#' colnames(res)
#' dplyr::glimpse(res)
#' summary(res)
#' 
#' @export
government_policy_timeline = function () {
    rpath = s2p_cached_url('https://github.com/OxCGRT/covid-policy-tracker/raw/master/data/OxCGRT_latest.csv')
    dat = readr::read_csv(rpath, guess_max = 50000, col_types = cols())
    dat$Date = lubridate::ymd(dat$Date)
    colnames(dat)[1:3]=c('country', 'iso3c', 'date')
    dat
}
