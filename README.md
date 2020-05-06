sars2pack
================

# sars2pack

<!-- badges: start -->

<!-- badges: end -->

``` r
knitr::opts_chunk$set(warning=FALSE,message=FALSE, 
                      fig.width=9, fig.height=6, out.width = '100%'
                      )
knitr::opts_knit$set(upload.fun = knitr::imgur_upload)
```

The `sars2pack` R package:

1.  Presents unified approach to getting **lots** of COVID-19 data,
2.  Provides extensive documentation and usage examples of these
    datasets,
3.  and

## Installation

``` r
# If you do not have BiocManager installed:
install.packages('BiocManager')

# Then, if sars2pack is not already installed:
BiocManager::install('seandavi/sars2pack')

# Then, to use:
```

``` r
library(sars2pack)
```

## Case tracking

``` r
ecdc = ecdc_data()
```

``` r
head(ecdc)
```

    ## # A tibble: 6 x 8
    ## # Groups:   location_name [1]
    ##   date       location_name iso2c iso3c population_2018 continent subset    count
    ##   <date>     <chr>         <chr> <chr>           <dbl> <chr>     <chr>     <dbl>
    ## 1 2019-12-31 Afghanistan   AF    AFG          37172386 Asia      deaths        0
    ## 2 2019-12-31 Afghanistan   AF    AFG          37172386 Asia      confirmed     0
    ## 3 2020-01-01 Afghanistan   AF    AFG          37172386 Asia      deaths        0
    ## 4 2020-01-01 Afghanistan   AF    AFG          37172386 Asia      confirmed     0
    ## 5 2020-01-02 Afghanistan   AF    AFG          37172386 Asia      deaths        0
    ## 6 2020-01-02 Afghanistan   AF    AFG          37172386 Asia      confirmed     0

``` r
library(dplyr)
top10 = ecdc %>% filter(subset=='deaths') %>% 
    group_by(location_name) %>%
    filter(count==max(count)) %>%
    arrange(desc(count)) %>%
    head(10) %>% select(-starts_with('iso'),-continent,-subset) %>%
    mutate(rate_per_100k = 1e5*count/population_2018)
knitr::kable(
    top10,
    caption = "Reported COVID-19-related deaths in ten most affected countries.",
    format = 'pandoc')
```

| date       | location\_name              | population\_2018 | count | rate\_per\_100k |
| :--------- | :-------------------------- | ---------------: | ----: | --------------: |
| 2020-05-05 | United\_States\_of\_America |        327167434 | 68934 |       21.069945 |
| 2020-05-05 | Italy                       |         60431283 | 29079 |       48.119117 |
| 2020-05-05 | United\_Kingdom             |         66488991 | 28734 |       43.216177 |
| 2020-05-05 | Spain                       |         46723749 | 25428 |       54.422003 |
| 2020-05-05 | France                      |         66987244 | 25201 |       37.620595 |
| 2020-05-05 | Belgium                     |         11422068 |  7924 |       69.374477 |
| 2020-05-05 | Brazil                      |        209469333 |  7321 |        3.495022 |
| 2020-05-05 | Germany                     |         82927922 |  6831 |        8.237274 |
| 2020-05-05 | Iran                        |         81800269 |  6277 |        7.673569 |
| 2020-05-05 | Netherlands                 |         17231017 |  5082 |       29.493326 |

Reported COVID-19-related deaths in ten most affected countries.

Examine the spread of the pandemic throughout the world by examining
cumulative deaths reported for the top 10 countries above.

``` r
ecdc_top10 = ecdc %>% filter(location_name %in% top10$location_name & subset=='deaths')
plot_epicurve(ecdc_top10,
              filter_expression = count > 10, 
              color='location_name')
```

<img src="https://i.imgur.com/0Ab9B9q.png" width="100%" />

Comparing the features of disease spread is easiest if all curves are
shifted to “start” at the same absolute level of infection. In this
case, shift the origin for all countries to start at the first time
point when more than 100 cumulative cases had been observed. Note how
some curves cross others which is evidence of less infection control at
the same relative time in the pandemic for that country (eg., Brazil).

``` r
ecdc_top10 %>% align_to_baseline(count>100,group_vars=c('location_name')) %>%
    plot_epicurve(date_column = 'index',color='location_name')
```

<img src="https://i.imgur.com/UERs1qV.png" width="100%" />

## Geospatial plotting of data

## Projection models

``` r
hcpd = healthdata_projections_data()
regs_of_interest = 'Georgia'
library(ggplot2)
pl = hcpd %>%
   dplyr::filter(location_name %in% regs_of_interest) %>%
   ggplot(aes(x=date)) + geom_line(aes(y=mean, color=metric))
# plot the "mean" prediction
pl
```

<img src="https://i.imgur.com/4rdUh85.png" width="100%" />

``` r
# add 95% confidence bounds
pl + geom_ribbon(aes(ymin=lower, ymax=upper, fill=metric), alpha=0.25)
```

<img src="https://i.imgur.com/bGe8ouj.png" width="100%" />

## Contributions

Pull requests are gladly accepted on
[Github](https://github.com/seandavi/sars2pack).

### Adding new datasets

See the **Adding new datasets** vignette.

## Similar work

  - <https://github.com/emanuele-guidotti/COVID19>
  - [Top 25 R resources on Novel COVID-19
    Coronavirus](https://towardsdatascience.com/top-5-r-resources-on-covid-19-coronavirus-1d4c8df6d85f)
  - [COVID-19 epidemiology with
    R](https://rviews.rstudio.com/2020/03/05/covid-19-epidemiology-with-r/)
  - <https://github.com/RamiKrispin/coronavirus>
  - [Youtube: Using R to analyze
    COVID-19](https://www.youtube.com/watch?v=D_CNmYkGRUc)
  - [DataCamp: Visualize the rise of COVID-19 cases globally with
    ggplot2](https://www.datacamp.com/projects/870)
  - [MackLavielle/covidix R
    package](https://github.com/MarcLavielle/covidix/)
