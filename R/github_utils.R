#' do an ls of a github repo
#'
#' Specify repo, path, and github reference (master, sha, etc.)
#' and get back an `ls` of that directory, including download links.
#'
#' @param repository character(1) formatted as 'user/repo_name' from Github
#' @param path character(1) The path in the repo to `ls` on
#' @param ref character(1) The github reference (tag, sha, branch) to
#'     run the ls on. Default is master.
#'
#' @return
#' A `tibble` with columns including:
#' - name
#' - path
#' - size
#' - download_url
#' - type (`file` or `dir`)
#'
#' @examples
#' ls_github('TheEconomist/covid-19-excess-deaths-tracker',
#'           'output-data/excess-deaths')
#' 
#' 
#' @export
ls_github = function(repository, path='', ref='master') {
    path = stringr::str_replace(path,'/$','')
    res = stop_for_status(
        httr::GET(sprintf('https://api.github.com/repos/%s/contents/%s?ref=%s',
                                repository, path, ref))
    )
    tibble::as_tibble(jsonlite::fromJSON(httr::content(res,type='text',encoding='UTF-8')))
}
