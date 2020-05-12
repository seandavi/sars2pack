
# sars2pack

<!-- badges: start -->

<!-- badges: end -->

## Questions addressed by sars2pack

  - What are the current and historical total, new cases, and deaths of
    COVID-19 at the city, county, state, national, and international
    levels?
  - How do changes in infection rates differ across locations?
  - What are the non-pharmacological interventions in place at the local
    and national levels?
  - In the United States, what is the geographical distribution of
    healthcare capacity (ICU beds, total beds, doctors, etc.)?
  - What are the published values of key epidemic parameters, as curated
    from the literature?

## Installation

``` r
# If you do not have BiocManager installed:
install.packages('BiocManager')

# Then, if sars2pack is not already installed:
BiocManager::install('seandavi/sars2pack')
```

After the one-time installation, load the packge to get started.

``` r
library(sars2pack)
```

## Available datasets

<table class="table table-striped" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

name

</th>

<th style="text-align:left;">

accessor

</th>

<th style="text-align:left;">

data\_type

</th>

<th style="text-align:left;">

geographical

</th>

<th style="text-align:left;">

geospatial

</th>

<th style="text-align:left;">

resolution

</th>

<th style="text-align:left;">

region

</th>

<th style="text-align:left;">

url

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

United States county-level geographic details

</td>

<td style="text-align:left;">

us\_county\_geo\_details

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

county

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://github.com/josh-byster/fips_lat_long)

</td>

</tr>

<tr>

<td style="text-align:left;">

Our World In Data testing and cases reporting

</td>

<td style="text-align:left;">

owid\_data

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

admin0

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://ourworldindata.org/coronavirus)

</td>

</tr>

<tr>

<td style="text-align:left;">

Kaiser Family Foundation ICU bed data

</td>

<td style="text-align:left;">

kff\_icu\_beds

</td>

<td style="text-align:left;">

healthcare capacity

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Individual hospital

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://khn.org/news/as-coronavirus-spreads-widely-millions-of-older-americans-live-in-counties-with-no-icu-beds)

</td>

</tr>

<tr>

<td style="text-align:left;">

CovidTracker data

</td>

<td style="text-align:left;">

covidtracker\_data

</td>

<td style="text-align:left;">

healthcare capacity

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

Individual hospital

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://covidtracking.com/)

</td>

</tr>

<tr>

<td style="text-align:left;">

CovidCare United States Healthcare Capacity

</td>

<td style="text-align:left;">

us\_healthcare\_capacity

</td>

<td style="text-align:left;">

healthcare capacity

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

Individual hospital

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://github.com/covidcaremap/covid19-healthsystemcapacity)

</td>

</tr>

<tr>

<td style="text-align:left;">

GISAID metadata from thousands of SARS-CoV-2 sequences

</td>

<td style="text-align:left;">

cov\_glue\_lineage\_data

</td>

<td style="text-align:left;">

individual cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

multiple

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://github.com/hCoV-2019/lineages)

</td>

</tr>

<tr>

<td style="text-align:left;">

beoutbreakprepared

</td>

<td style="text-align:left;">

beoutbreakprepared\_data

</td>

<td style="text-align:left;">

individual cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

patient

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://github.com/beoutbreakprepared/nCoV2019)

</td>

</tr>

<tr>

<td style="text-align:left;">

US CDC excess deaths dataset

</td>

<td style="text-align:left;">

cdc\_excess\_deaths

</td>

<td style="text-align:left;">

miscellaneous

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

admin1

</td>

<td style="text-align:left;">

US

</td>

<td style="text-align:left;">

[LINK](https://www.cdc.gov/nchs/nvss/vsrr/covid19/excess_deaths.html)

</td>

</tr>

<tr>

<td style="text-align:left;">

Published epidemic parameters for COVID-19

</td>

<td style="text-align:left;">

param\_estimates\_published

</td>

<td style="text-align:left;">

miscellaneous

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

[LINK](https://github.com/midas-network/COVID-19/blob/master/parameter_estimates/2019_novel_coronavirus/estimates.csv)

</td>

</tr>

<tr>

<td style="text-align:left;">

Google mobility data

</td>

<td style="text-align:left;">

google\_mobility\_data

</td>

<td style="text-align:left;">

mobility

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://www.google.com/covid19/mobility/)

</td>

</tr>

<tr>

<td style="text-align:left;">

Descartes Labs Mobility Data

</td>

<td style="text-align:left;">

descartes\_mobility\_data

</td>

<td style="text-align:left;">

mobility

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

county

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://raw.githubusercontent.com/descarteslabs/DL-COVID-19)

</td>

</tr>

<tr>

<td style="text-align:left;">

Apple mobility data from maps

</td>

<td style="text-align:left;">

apple\_mobility\_data

</td>

<td style="text-align:left;">

mobility

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

country and sub-country

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://www.apple.com/covid19/mobility)

</td>

</tr>

<tr>

<td style="text-align:left;">

Newick tree from thousands of SARS-CoV-2 sequences

</td>

<td style="text-align:left;">

cov\_glue\_newick\_data

</td>

<td style="text-align:left;">

phylogenetic

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

multiple

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://github.com/hCoV-2019/lineages)

</td>

</tr>

<tr>

<td style="text-align:left;">

Aggregated projections from US CDC

</td>

<td style="text-align:left;">

cdc\_aggregated\_projections

</td>

<td style="text-align:left;">

projections

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

[LINK](https://www.cdc.gov/coronavirus/2019-ncov/covid-data/forecasting-us.html)

</td>

</tr>

<tr>

<td style="text-align:left;">

Oxford Government Policy Intervention time series

</td>

<td style="text-align:left;">

government\_policy\_timeline

</td>

<td style="text-align:left;">

public policy

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

country

</td>

<td style="text-align:left;">

International

</td>

<td style="text-align:left;">

[LINK](https://www.bsg.ox.ac.uk/research/research-projects/oxford-covid-19-government-response-tracker)

</td>

</tr>

<tr>

<td style="text-align:left;">

United States social distancing policies

</td>

<td style="text-align:left;">

us\_state\_distancing\_policy

</td>

<td style="text-align:left;">

public policy

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

state

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://github.com/COVID19StatePolicy/SocialDistancing/)

</td>

</tr>

<tr>

<td style="text-align:left;">

European CDC world tracking

</td>

<td style="text-align:left;">

ecdc\_data

</td>

<td style="text-align:left;">

time series cumulative cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

country

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://www.ecdc.europa.eu/en/covid-19)

</td>

</tr>

<tr>

<td style="text-align:left;">

EU data Github aggregator

</td>

<td style="text-align:left;">

eu\_data\_cache\_data

</td>

<td style="text-align:left;">

time series cumulative cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

country and sub-country

</td>

<td style="text-align:left;">

Europe

</td>

<td style="text-align:left;">

[LINK](https://github.com/covid19-eu-zh/covid19-eu-data)

</td>

</tr>

<tr>

<td style="text-align:left;">

USA Facts

</td>

<td style="text-align:left;">

usa\_facts\_data

</td>

<td style="text-align:left;">

time series cumulative cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

county

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://usafacts.org/visualizations/coronavirus-covid-19-spread-map/)

</td>

</tr>

<tr>

<td style="text-align:left;">

Johns Hopkins dataset

</td>

<td style="text-align:left;">

jhu\_data

</td>

<td style="text-align:left;">

time series cumulative cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

country

</td>

<td style="text-align:left;">

World

</td>

<td style="text-align:left;">

[LINK](https://github.com/CSSEGISandData/COVID-19)

</td>

</tr>

<tr>

<td style="text-align:left;">

Johns Hopkins US-centric data

</td>

<td style="text-align:left;">

jhu\_us\_data

</td>

<td style="text-align:left;">

time series cumulative cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

county

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://github.com/CSSEGISandData/COVID-19)

</td>

</tr>

<tr>

<td style="text-align:left;">

New York Times county level data

</td>

<td style="text-align:left;">

nytimes\_county\_data

</td>

<td style="text-align:left;">

time series cumulative cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

county

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://raw.githubusercontent.com/nytimes/covid-19-data)

</td>

</tr>

<tr>

<td style="text-align:left;">

New York Times state level data

</td>

<td style="text-align:left;">

nytimes\_state\_data

</td>

<td style="text-align:left;">

time series cumulative cases

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

state

</td>

<td style="text-align:left;">

United States

</td>

<td style="text-align:left;">

[LINK](https://raw.githubusercontent.com/nytimes/covid-19-data)

</td>

</tr>

<tr>

<td style="text-align:left;">

Healthdata.org projections of hospital utilization and deaths

</td>

<td style="text-align:left;">

healthdata\_projections\_data

</td>

<td style="text-align:left;">

time series projections

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

[LINK](http://www.healthdata.org/covid)

</td>

</tr>

</tbody>

</table>

## Case tracking

Updated tracking of city, county, state, national, and international
confirmed cases, deaths, and testing is critical to driving policy,
implementing interventions, and measuring their effectiveness. Case
tracking datasets include date, a count of cases, and usually numerous
other pieces of information related to location of reporting, etc.

Accessing case-tracking datasets is typically done with one function per
dataset. The example here is data from the European Centers for Disease
Control, or ECDC.

``` r
ecdc = ecdc_data()
```

Get a quick overview of the dataset.

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

The `ecdc` dataset is just a `data.frame` (actually, a `tibble`), so
applying standard R or tidyverse functionality can get answers to basic
questions with little code. The next code block generates a `top10` of
countries with the most deaths recorded to date. Note that if you do
this on your own computer, the data will be updated to today’s data
values.

``` r
library(dplyr)
top10 = ecdc %>% filter(subset=='deaths') %>% 
    group_by(location_name) %>%
    filter(count==max(count)) %>%
    arrange(desc(count)) %>%
    head(10) %>% select(-starts_with('iso'),-continent,-subset) %>%
    mutate(rate_per_100k = 1e5*count/population_2018)
```

Finally, present a nice table of those countries:

``` r
knitr::kable(
    top10,
    caption = "Reported COVID-19-related deaths in ten most affected countries.",
    format = 'pandoc')
```

| date       | location\_name              | population\_2018 | count | rate\_per\_100k |
| :--------- | :-------------------------- | ---------------: | ----: | --------------: |
| 2020-05-07 | United\_States\_of\_America |        327167434 | 73431 |       22.444471 |
| 2020-05-07 | United\_Kingdom             |         66488991 | 30076 |       45.234556 |
| 2020-05-07 | Italy                       |         60431283 | 29684 |       49.120255 |
| 2020-05-06 | Spain                       |         46723749 | 25857 |       55.340165 |
| 2020-05-07 | France                      |         66987244 | 25809 |       38.528231 |
| 2020-05-07 | Brazil                      |        209469333 |  8536 |        4.075060 |
| 2020-05-07 | Belgium                     |         11422068 |  8339 |       73.007795 |
| 2020-05-07 | Germany                     |         82927922 |  7119 |        8.584563 |
| 2020-05-07 | Iran                        |         81800269 |  6418 |        7.845940 |
| 2020-05-07 | Netherlands                 |         17231017 |  5204 |       30.201351 |

Reported COVID-19-related deaths in ten most affected countries.

Examine the spread of the pandemic throughout the world by examining
cumulative deaths reported for the top 10 countries above.

``` r
ecdc_top10 = ecdc %>% filter(location_name %in% top10$location_name & subset=='deaths')
plot_epicurve(ecdc_top10,
              filter_expression = count > 10, 
              color='location_name')
```

<img src="https://i.imgur.com/BjGKIaf.png" width="100%" />

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

<img src="https://i.imgur.com/OW4DQFU.png" width="100%" />

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

<img src="https://i.imgur.com/HX6HdVW.png" width="100%" />

``` r
# add 95% confidence bounds
pl + geom_ribbon(aes(ymin=lower, ymax=upper, fill=metric), alpha=0.25)
```

<img src="https://i.imgur.com/UQVSBSd.png" width="100%" />

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
