#' Nextstrain/GISAID metadata table (raw input)
#'
#' This function gathers the raw input data associated with
#' \url{https://nextstrain.org/} for COVID-19 as gathered from GISAID.
#'
#' @details:
#'
#' Nextstrain is an open-source project to harness the scientific and
#' public health potential of pathogen genome data. They provide a
#' continually-updated view of publicly available data alongside
#' powerful analytic and visualization tools for use by the
#' community. Their goal is to aid epidemiological understanding and
#' improve outbreak response.
#'
#' @section Nextstrain overview:
#' From the Nextstrain website:
#'
#' In the course of an infection and over an epidemic, pathogens
#' naturally accumulate random mutations to their genomes. This is an
#' inevitable consequence of error-prone genome replication. Since
#' different genomes typically pick up different mutations, mutations
#' can be used as a marker of transmission in which closely related
#' genomes indicate closely related infections. By reconstructing a
#' phylogeny we can learn about important epidemiological phenomena
#' such as spatial spread, introduction timings and epidemic growth
#' rate.
#'
#' However, if pathogen genome sequences are going to inform public
#' health interventions, then analyses have to be rapidly conducted
#' and results widely disseminated. Current scientific publishing
#' practices hinder the rapid dissemination of epidemiologically
#' relevant results. We thought an open online system that implements
#' robust bioinformatic pipelines to synthesize data from across
#' research groups has the best capacity to make epidemiologically
#' actionable inferences.
#' 
#' Workflow for Nextstrain processing:
#' - \url{https://github.com/nextstrain/ncov/raw/master/docs/images/basic_snakemake_build.png}
#'
#' @source
#' - \url{https://nextstrain.org/}
#' - \url{https://raw.githubusercontent.com/nextstrain/ncov/master/data/metadata.tsv}
#' 
#' 
#' @references
#'
#' James Hadfield, Colin Megill, Sidney M Bell, John Huddleston,
#' Barney Potter, Charlton Callender, Pavel Sagulenko, Trevor Bedford,
#' Richard A Neher, Nextstrain: real-time tracking of pathogen
#' evolution, Bioinformatics, Volume 34, Issue 23, 01 December 2018,
#' Pages 4121–4123,
#' \url{https://doi.org/10.1093/bioinformatics/bty407}
#'
#'
#' 
#' @family data-import
#' @family genomics
#' @family individual-cases
#'
#' @export
nextstrain_data = function() {
    url = 'https://raw.githubusercontent.com/nextstrain/ncov/master/data/metadata.tsv'
    rpath = s2p_cached_url(url)
    
    ret = suppressWarnings(readr::read_tsv(rpath, col_types = cols()))

    ret
}
    
