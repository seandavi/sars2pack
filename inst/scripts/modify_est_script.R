library(sars2pack)  # need 0.0.5
library(lubridate)
My_Estimate_R <- function (incidence_vector) {
  estimate.R(incidence_vector, GT = GT.cov2 , t = as_date(mdy(names(incidence_vector))),
begin=1L, end=as.integer(length(incidence_vector)), methods=c("EG"))
}
as_vector = function(x) data.matrix(x)[1,,drop=TRUE]
cvec = as_vector(get_series("France", "France"))
ivec = diff(cvec)
tivec = trimLeading(ivec)
names(tivec) = gsub("/", "-", names(tivec)) # JHU gives / but lubridate needs -
GT.cov2 = generation.time("gamma", c(3.5, 4.8))  # you are taking this from global environment ...
My_Estimate_R(tivec)  
