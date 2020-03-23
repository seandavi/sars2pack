#'
#' @importFrom openxlsx write.xlsx
#'
#'
jhu_data_to_excel <- function(include_country_metadata=TRUE) {
    res = jhu_data()
    ret = lapply(unique(res$subset),function(x) {
        res2 = res %>% dplyr::filter(subset==x)
        res3 = res2 %>% tidyr::pivot_wider(names_from = date, values_from = count)
        return(res3)
    })
    names(ret) = unique(res$subset)
    ret
}

