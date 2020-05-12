#' CoronaNet government policy response database
#'
#' This dataset contains variables from the CoronaNet government
#' response project, representing national and sub-national policy
#' event data from more than 140 countries since January 1st,
#' 2020. The data include source links, descriptions, targets
#' (i.e. other countries), the type and level of enforcement, and a
#' comprehensive set of policy types.
#'
#' @importFrom readr read_csv cols
#' 
#' @references Cheng, Cindy, Joan Barcelo, Allison Hartnett,
#'     Robert Kubinec, and Luca Messerschmidt. 2020. “Coronanet: A
#'     Dyadic Dataset of Government Responses to the COVID-19
#'     Pandemic.” SocArXiv. April 12. doi:10.31235/osf.io/dkvxy.
#' 
#' - \url{https://coronanet-project.org/working_papers}
#'
#' @source
#' - \url{https://coronanet-project.org/download}
#'
#' @return
#' - record_id Unique identifier for each policy record
##' - entry_type Whether the record is new, meaning no restriction had been in place before, or an update (restriction was in place but changed). Corrections are corrections to previous entries.
##' - event_description A short description of the policy change
##' - type The category of the policy
##' - country The country initiating the policy
##' - init_country_level Whether the policy came from the national level or a sub-national unit
##' - index_prov The ID of the sub-national unit
##' - target_country Which foreign country a policy is targeted at (i.e. travel policies)
##' - target_geog_level Whether the target of the policy is a country as a whole or a sub-national unit of that country
##' - target_who_what Who the policy is targeted at
##' - recorded_date When the record was entered into our data
##' - target_direction Whether a travel-related policy affects people coming in (Inbound) or leaving (Outbound)
##' - travel_mechanism If a travel policy, what kind of transportation it affects
##' - compliance Whether the policy is voluntary or mandatory
##' - enforcer What unit in the country is responsible for enforcement
##' - date_announced When the policy goes into effect
##' - link A link to at least one source for the policy
##' - ISO_A3 3-digit ISO country codes
##' - ISO_A2 2-digit ISO country codes
##' - severity_index_5perc 5% posterior low estimate (i.e. lower bound of uncertainty interval) for severity index
##' - severity_index_median posterior median estimate (point estimate) for severity index, which comes from a Bayesian latent variable model aggregating across policy types to measure country-level policy severity (see paper on our website)
##' - severity_index_5perc 95% posterior high estimate (i.e. upper bound of uncertainty interval) for severity index
##'
##' @family data-import
##' @family NPI
##'
##' 
#' @examples
#' res = coronanet_government_response_data()
#' head(res)
#' colnames(res)
#' dplyr::glimpse(res)
#' summary(res)
#' 
#'
#' @export
coronanet_government_response_data <- function() {
    url = "https://raw.githubusercontent.com/saudiwin/corona_tscs/master/data/CoronaNet/coronanet_release.csv"
    rpath = s2p_cached_url(url)
    dat = readr::read_csv(rpath, col_types = readr::cols(), progress=FALSE)
    dat %>% rename(iso2c = "ISO_A2", iso3c="ISO_A3")
}
    
