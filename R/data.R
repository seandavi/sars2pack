#' march 19 result of CSSEGISandData/COVID-19/ time series data retrieval as data.frame
#' @docType data
#' @format data.frame
#' @examples
#' mar19df[1:3, 1:8]
"mar19df"

#' march 19 result of CSSEGISandData/COVID-19/ time series data retrieval as data.table
#' @docType data
#' @format data.frame
#' @examples
#' mar19dt[1:3, 1:8]
"mar19dt"

#' serial interval values fo 468 COVID-19 cases in 93 cities in China
#' @source \url{https://github.com/MeyersLabUTexas/COVID-19} Table S5.xlsx
#' @format data.frame
"CRF_468_China"


#' MCMC-based model for SI, Gamma family used for censored-data likelihood
#' @format list with components `si_sample` (matrix) and `si_parametric_distr (character)
"si_cens_G"

#' MCMC-based model for SI, lognormal family used for censored-data likelihood
#' @format list with components `si_sample` (matrix) and `si_parametric_distr (character)
"si_cens_L"

#' MCMC-based model for SI, Weibull family used for censored-data likelihood
#' @format list with components `si_sample` (matrix) and `si_parametric_distr (character)
"si_cens_W"


#' MCMC-based model for SI, Gamma family used for positive-data likelihood
#' @note The data reported at [CDC](https://wwwnc.cdc.gov/eid/article/26/6/20-0357_article) on
#' 468 transmission events were filtered to include only reports where contact
#' symptom onset was later than that reported for index case.
#' @format list with components `si_sample` (matrix) and `si_parametric_distr (character)
"si_pos_G"

#' MCMC-based model for SI, lognormal family used for positive-data likelihood
#' @format list with components `si_sample` (matrix) and `si_parametric_distr (character)
"si_pos_L"

#' MCMC-based model for SI, Weibull family used for positive-data likelihood
#' @format list with components `si_sample` (matrix) and `si_parametric_distr (character)
"si_pos_W"

#' genbank records including available sequence for SARS-Cov-2 accessions available 14 May 2020
#' @format list
"sars2gb_2020_05_14"
