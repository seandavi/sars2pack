#' COVID GLUE datasets
#'
#' @importFrom readr read_csv cols
#' @importFrom dplyr rename %>%
#' @importFrom countrycode countrycode
#' 
#' @references
#' 
#' \code{{
#' \@article{VANDORP2020104351,
#' title = "Emergence of genomic diversity and recurrent mutations in SARS-CoV-2",
#' journal = "Infection, Genetics and Evolution",
#' pages = "104351",
#' year = "2020",
#' issn = "1567-1348",
#' doi = "https://doi.org/10.1016/j.meegid.2020.104351",
#' url = "http://www.sciencedirect.com/science/article/pii/S1567134820301829",
#' author = "Lucy [van Dorp] and Mislav Acman and Damien Richard and Liam P. Shaw and Charlotte E. Ford and Louise Ormond and Christopher J. Owen and Juanita Pang and Cedric C.S. Tan and Florencia A.T. Boshier and Arturo Torres Ortiz and FranÃ§ois Balloux"
#' }
#' }}
#'
#' @family lineage
#' @family data-import
#' @family individual-cases
#'
#' @seealso cov_glue_newick_data()
#'
#' @rdname cov_glue_datasets
#'
#' @examples
#' res = cov_glue_lineage_data()
#' head(res)
#' colnames(res)
#' dplyr::glimpse(res)
#' 
#' 
#' @export 
cov_glue_lineage_data <- function() {
    url = 'https://raw.githubusercontent.com/hCoV-2019/lineages/master/lineages/data/lineages.2020-04-27.csv'
    rpath = s2p_cached_url(url)
    dat = readr::read_csv(rpath, col_types = readr::cols()) %>%
        dplyr::rename(date = 'sample date',
                      travel_history = 'travel history',
                      gisaid_id = 'GISAID ID')
    dat$iso3c = countrycode::countrycode(dat$country, warn=FALSE, 
                                         origin='country.name.en',destination='iso3c')
    dat$iso2c = countrycode::countrycode(dat$country, warn=FALSE,
                                         origin='country.name.en',destination='iso2c')
    dat
}


#' COVID GLUE Newick tree
#'
#' @importFrom ape read.tree
#'
#' 
#' @family lineage
#' @family data-import
#' @family individual-cases
#'
#' @seealso cov_glue_lineage_data()
#'
#' @examples
#' tr = cov_glue_newick_data()
#' plot(tr, type='r', cex=0.4)
#' 
#' @export
cov_glue_newick_data <- function() {
    url = 'https://raw.githubusercontent.com/hCoV-2019/lineages/master/lineages/data/anonymised.aln.fasta.treefile'
    rpath = s2p_cached_url(url)
    dat = ape::read.tree(rpath)
    dat
}
