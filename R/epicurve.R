epicurve <- function(x, ...) UseMethod('epicurve')

epicurve.data.frame <- function(x, count_column = 'count',
                                date_column = 'date',cumulative=TRUE, ...) {
    stopifnot(c(date_column,count_column) %in% colnames(x))
    class(x) = c('epicurve',class(x))
    attr(x,'epicurve') = list(date_column=date_column,
                              count_column = count_column,
                              cumulative   = cumulative)
    x
}

print.epicurve <- function(x, ...) {
    epiattr = attr(x, 'epicurve')
    cat('# epicurve \n')
    cat(utils::str(epiattr))
    NextMethod()
}

ggplot_epicurve <- function(x, ...) {
    epiattr = attr(x, 'epicurve')
    print(epiattr$date_column)
    ggplot2::ggplot(x, ggplot2::aes_string(x = epiattr$date_column,
                                           y = epiattr$count_column)) + 
        ggplot2::geom_line()
}



                
