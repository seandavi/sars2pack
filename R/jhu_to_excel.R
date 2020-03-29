#' utility function to remove columns that contain `data.frame` type
#'
#' The dplyr::bind_rows function does not work with
#' `data.frame` columns, so simply remove them as needed.
#'
#' @param df a `data.frame` that will have all columns of type
#' `data.frame` removed
#'
#' @return df, but without any `data.frame` columns
#' @keywords internal
.remove_df_columns <- function(df) {
    df_cols = which(sapply(df, class)=='data.frame')
    df[, -c(df_cols)]
}

.cols_to_remove = c(
    "callingCodes",
    "altSpellings",
    "latlng",
    "demonym",
    "timezones",
    "nativeName",
    "currencies",
    "languages",
    "translations",
    "flag",
    "regionalBlocs"
)

#' Get enriched jhu dataset as a list of three data.frames
#'
#' The purpose of this function is to enrich the JHU dataset
#' with additional country-level metadata and then get the
#' data into a form that can be easily written to excel or used
#' as a "wide-format" tabular dataset.
#'
#' @importFrom openxlsx write.xlsx
#' @importFrom countrycode countrycode
#'
#' @param cols_to_remove a character vector of column names from
#' [country_metadata()] to remove.
#' 
#' @return A list of three `data.frames` named `deaths`, `confirmed`,
#' and `recovered`.
#' 
#' @export
enriched_jhu_data <- function(cols_to_remove = .cols_to_remove) {
    res = jhu_data()
    cmd = country_metadata()
    res$alpha3Code = countrycode(
        res$CountryRegion,
        origin = "country.name.en",
        destination="iso3c",
        ## This is a custom HACK
        custom_match=c('Kosovo'='XKX', 'Diamond Princess'=NA))
    res3 = cmd %>%
        dplyr::right_join(res,by=c("alpha3Code"="alpha3Code")) %>%
        dplyr::select(-c(cols_to_remove))
    if(nrow(res3) != nrow(res)) {
        stop('row numbers do not match')
    }
    return(res3)
}

#' Create +/- write excel format of enriched JHU global data
#'
#' The purpose of this function is to enrich the JHU dataset
#' with additional country-level metadata and then get the
#' data into a form that can be easily written to excel or used
#' as a "wide-format" tabular dataset.
#'
#' @importFrom openxlsx write.xlsx
#' @importFrom countrycode countrycode
#' @importFrom dplyr filter
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr select
#' @importFrom dplyr right_join
#'
#' @param dat a data.frame-like object with at least column
#'     `CountryRegion` that will be joined with country data.
#' @param file character(1) filename to which to save excel
#'     file. If specified, use the write.xlsx() function from the
#'     openxlsx package to create (or overwrite) the file of that
#'     name. The excel file will have one tab for each of the `subset`
#'     records from the supplied data.frame in `dat`.
#' @param cols_to_remove a character vector of column names from
#'     [country_metadata()] to remove.
#'
#' @return A list of three `data.frames` named `deaths`, `confirmed`,
#' and `recovered`.
#'
#' @examples
#' xls_form = jhu_data_to_excel()
#' names(xls_form)
#' head(xls_form[[1]])
#' 
#' @export
jhu_data_to_excel <- function(dat = jhu_data(),
                              file=NA,
                              cols_to_remove =
                                  c(
                                      "callingCodes",
                                      "altSpellings",
                                      "latlng",
                                      "demonym",
                                      "timezones",
                                      "nativeName",
                                      "currencies",
                                      "languages",
                                      "translations",
                                      "flag",
                                      "regionalBlocs"
                                  ), ...) {
    res = dat
    cmd = country_metadata()
    subsets = unique(res$subset)
    ret = lapply(subsets,function(x) {
        res2 = res %>%
            dplyr::filter(subset==x) %>%
            tidyr::pivot_wider(names_from = date, values_from = count) %>%
            dplyr::select(-subset)
        res2$alpha3Code = countrycode(
            res2$CountryRegion,
            origin = "country.name.en",
            destination="iso3c",
            ## This is a custom HACK
            custom_match=c('Kosovo'='XKX', 'Diamond Princess'=NA))
        res3 = cmd %>%
            dplyr::right_join(res2,by=c("alpha3Code"="alpha3Code")) %>%
            dplyr::select(-c(cols_to_remove))
        if(nrow(res3) != nrow(res2)) {
            stop('row numbers do not match')
        }
        return(res3)
    })
    names(ret) = unique(res$subset)
    if(!is.na(excel_filename)) {
        write.xlsx(ret, file=excel_filename, ...)
    }
    ret
}
