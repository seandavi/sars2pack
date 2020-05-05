#' Estimate R(t) from cumulative case time series
#' 
#' Given a case-tracking dataset, determine the basic reproduction
#' index over time. 
#' 
#' @importFrom EpiEstim make_config estimate_R
#' @importFrom dplyr filter %>% 
#' @importFrom rlang enquo `!!`
#' @importFrom R0 estimate.R
#' 
#' @param df a data.frame containing at least a date column and a cases column, describing
#'     the cumulative cases at each date. Note that dates MUST NOT REPEAT and the function
#'     will check that this is the case. Use the `filter_expression` parameter to limit
#'     the data.frame to achieve non-duplicated dates from the typical case-tracking datasets
#'     in sars2pack. 
#' @param filter_expression a `dplyr::filter` expression, applied directly to the data.frame
#'     prior to calculating Rt. This is a useful way to write a one-liner from any of the
#'     case-tracking datasets.
#' @param cases_column character(1) name of (cumulative) cases column in the input data.frame
#' @param date_column character(1) name of date column in the input data.frame
#' @param estimation_family One of `epiestim`
#' @param method character(1) passed to `EpiEstim::estimate_R()`
#' @param config list() passed to `EpiEstim::make_config()`. Typically used to 
#'     set up the serial interval distribution.
#' @param invert **Unused** default FALSE, but if TRUE, returns 1/R(t) or related
#'     estimate, useful for plotting, since we are often most interested
#'     in looking at R(t) near or below 1. 
#' @param quiet logical(1) whether or not to provide messages, etc. 
#' @param ... passed to the estimation method
#'
#' @return
#' For the epiestim method, returns a data.frame with columns:
#'     - Mean(R)           
#'     - Std(R)
#'     - Quantile.0.025(R) 
#'     - Quantile.0.05(R)
#'     - Quantile.0.25(R)
#'     - Median(R)
#'     - Quantile.0.75(R)
#'     - Quantile.0.95(R)
#'     - Quantile.0.975(R)"
#'     - date_start
#'     - date_end
#' 
#' @family analysis
#' @family case-tracking
#'
#' @examples
#' nyt = nytimes_state_data()
#' head(nyt)
#' 
#' nystate_Rt = estimate_Rt(
#'     nyt,
#'     filter_expression = state=='New York' & subset=='confirmed',
#'     estimation_family='epiestim',
#'     cumulative=TRUE,
#'     method = 'parametric_si',
#'     config = list(mean_si=3.96, std_si=4.75))
#' head(nystate_Rt)
#' 
#' library(ggplot2)
#' p = ggplot(nystate_Rt, aes(x=date_start,y=`Mean(R)`)) + geom_line()
#' p
#' p + geom_ribbon(aes(ymin=`Quantile.0.05(R)`, ymax=`Quantile.0.95(R)`), alpha=0.5)
#' 
#' # plot 1/Rt to expand region around 1 since that is typically what
#' # is most interesting with respect to controls
#' 
#' p = ggplot(nystate_Rt, aes(x=date_start,y=1/`Mean(R)`)) + geom_line()
#' p
#' p + geom_ribbon(aes(ymax=1/`Quantile.0.05(R)`, ymin=1/`Quantile.0.95(R)`), alpha=0.5)
#' 
#' # and simple loess smoothing
#' p + geom_smooth()
#' 
#' 
#' # super-cool use of tidyr, purrr, and dplyr to perform 
#' # calculations over all states:
#' \dontrun{
#' library(dplyr)
#' library(tidyr)
#' est_by = function(df) {
#'         estimate_Rt(
#'         df,
#'         estimation_family='epiestim',
#'         cumulative=TRUE,
#'         method = 'parametric_si',
#'         config = list(mean_si=3.96, std_si=4.75))
#'     }
#' z = nyt %>% dplyr::filter(subset=='confirmed') %>% tidyr::nest(-state) %>%
#'     dplyr::mutate(rt_df = purrr::map(data, est_by)) %>% tidyr::unnest(cols=rt_df)
#' p = ggplot(z,aes(x=date_start,y=1/`Mean(R)`, color=state)) + 
#'      ylim(c(0.5,1.25)) + 
#'      geom_smooth(se = FALSE)
#' p
#' library(plotly)
#' ggplotly(p)
#' }
#' 
#' @export
estimate_Rt = function(df, filter_expression, 
                       cases_column = 'count', 
                       date_column = 'date',
                       method,
                       config,
                       cumulative = TRUE,
                       estimation_family = 'epiestim', invert = FALSE,
                       quiet=TRUE,
                       ...) {
    
    if(!missing(filter_expression)) {
        df = df %>% dplyr::filter(!!enquo(filter_expression))
    }
    
    if(any(duplicated(df[[date_column]]))) {
        stop('Repeated dates found. Did you forget to filter or summarize first?')
    }
    
    if(any(diff(df[[date_column]])!=1)) {
        nm2 = list()
        nm2[[cases_column]]=0
        df2 = data.frame(Date = seq(min(df[[date_column]]), max(df[[date_column]]), by = "1 day"))
        df3 = merge(df2, df, by.x="Date", by.y=date_column, all.x=TRUE)
        colnames(df3) = c(date_column, cases_column)
        df3[[cases_column]][is.na(df[[cases_column]])] = 0
        df = df3
        
    }
    
    if(cumulative) {
        df = add_incidence_column(df,date_column = date_column, count_column = cases_column)
        df[['inc']][df[['inc']]<0]=0
        df[['inc']][is.na(df[['inc']])]=0
        cases_column = 'inc'
    }
    if(nrow(df)<10) {
        return(data.frame())
    }
    if(estimation_family == 'epiestim') {
        df1 = df[,c(cases_column, date_column)]
        
        colnames(df1) = c("I", 'dates')
        df1 = df1[order(df1$dates),]
        tryCatch({
        if(quiet) {
            ret = suppressMessages(EpiEstim::estimate_R(
                df1, method = method, 
                config = suppressMessages(EpiEstim::make_config(config)),
                ...))
            
        } else {
            ret = EpiEstim::estimate_R(df1, method = method, 
                                       config = EpiEstim::make_config(config),
                                       ...)
        }},
        error=function(e) {
            message('failed epiestim')
            message(e)
            print(data.frame(df1))
            ret = data.frame()
            return(ret)
        },
        finally = function() {
            message('failed epiestim')
            print(data.frame(df1))
            return(data.frame())
        })
        ret = ret$R
        ret$date_start = df1$dates[ret$t_start]
        ret$date_end = df1$dates[ret$t_end]
        return(ret) # returns an epiestim data.frame
    }
    if(estimation_family == 'td') {
        dat = df[[cases_column]]
        names(dat) == df[[date_column]]
        res = R0::estimate.R(dat, method='TD',GT = generation.time("gamma", c(3.96, 4.75)))
        ret = data.frame(prediction = res$pred)
    }
    
}

#' Estimate R(t) for all locales in a case-tracking dataset
#' 
#' This function can estimate R(t) curves for all locations in a case-tracking
#' dataset and return a stacked data.frame with the location details included.
#' It is a convenience function for getting R(t) over a large dataset. Right
#' now, nothing is done in "parallel", so this function is not going to be 
#' much (or any) faster than running on each location in a case-tracking
#' dataset independently and then combining. 
#' 
#' 
#' 
#' @importFrom tidyr nest unnest
#' @importFrom purrr map
#' @importFrom dplyr mutate `%>%`
#' 
#' @param df a data.frame containing at least a date column and a cases column, describing
#'     the cumulative cases at each date. The data.frame may contain additional columns
#'     that can be used to "group" the dates and cases to produce a set of R(t) curves.
#' @param cases_column character(1) the column in `df` that includes the case counts
#'     of interest.
#' @param date_column character(1) the column in `df` that includes the date information
#'     about when cases reported.
#' @param grouping_columns character() vector specifying the grouping columns that
#'     will break `df` into chunks for estimation (i.e., location, etc.). The default is normally
#'     correct and includes all
#'     columns except for date_column and case_column.
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @return 
#' A "stacked" data.frame with the outputs from the R(t) estimation process
#' and associated location information. The actual columns returned for the
#' R(t) estimate will depend on the `estimation_family` parameter as well
#' as other parameters specific to each method. 
#' 
#' @examples
#' library(dplyr)
#' nyt = nytimes_state_data() %>% 
#'     dplyr::filter(subset=='confirmed') %>%
#'     dplyr::arrange(state,date)
#' head(nyt)
#' 
#' # this may produce warnings, but the processing
#' # will still be correct....
#' res = bulk_estimate_Rt(head(nyt,500), 
#'     estimation_family='epiestim',method = 'parametric_si',
#'     config = list(mean_si=3.96, std_si=4.75))
#' head(res)
#' colnames(res)
#' 
#' library(ggplot2)
#' ggplot(res, aes(x=date_start,y=1/`Mean(R)`,color=state)) + 
#'     geom_smooth(se=FALSE) + ylim(c(0,1.5))
#' 
#' @family analysis
#' @family case-tracking
#' 
#' @export
bulk_estimate_Rt = function(df, 
                            grouping_columns= setdiff(colnames(df),
                                                      c(cases_column,date_column)), 
                            cases_column = 'count', date_column='date', ...) {
    app_fn = function(x,...) {
        estimate_Rt(x, cases_column = cases_column,
                    date_column = date_column, ...)
    }
    d = df %>% tidyr::nest(-c(grouping_columns)) 
    d %>% dplyr::mutate(rt_df = purrr::map(data, app_fn, ...)) %>% tidyr::unnest(cols=rt_df)
}



