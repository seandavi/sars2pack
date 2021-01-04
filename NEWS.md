# sars2pack 0.99.2

## New datasets

- Excess deaths during coronavirus `economist_excess_deaths()` `cdc_excess_deaths()` `financial_times_excess_deaths()`
- Coronavirus Vaccine Data Tracking in the United States `cci_us_vaccine_data()`
- Corona Data Scraper data	`coronadatascraper_data()`
- United States CDC Line list (anonymized)	`cdc_us_linelist_data()`
- United States contact tracers by state from testandtrace.com	`test_and_trace_data()`
- United States Unemployment Insurance claims by week	 `econ_tracker_unemp_national_data()`
- United States Unemployment Insurance claims by week	`econ_tracker_unemp_state_data()`
- United States Unemployment Insurance claims by week	`econ_tracker_unemp_county_data()`
- United States Unemployment Insurance claims by week	`econ_tracker_unemp_city_data()`
- United States Consumer Spending from Econ Tracker and Affinity	`econ_tracker_consumer_spending_national_data()`
- United States Consumer Spending from Econ Tracker and Affinity	`econ_tracker_consumer_spending_state_data()`
- United States Consumer Spending from Econ Tracker and Affinity	`econ_tracker_consumer_spending_county_data()`
- United States Consumer Spending from Econ Tracker and Affinity	`econ_tracker_consumer_spending_city_data()`
- ACAPS Secondary impacts of covid data `acaps_secondary_impact_data()`

## Dataset updates

- Google search trends data `google_search_trends_data()`
- United States social distancing policy data `us_state_distancing_policy()`
- 

## Enhancements

- Vignettes are large and unwieldy, so are now in a separate [`bookdown` site](https://seandavi.github.io/sars2pack-book).

# sars2pack 0.99.0

Start Bioconductor submission process

# sars2pack 0.1.2

## New datasets

- US CDC Social Vulnerability Index: `cdc_social_vulnerability_index()`
- 


## bug fixes

- Fixed `cdc_excess_deaths()` date parsing (hanks
  to Nancy Hansen for report).


# sars2pack 0.0.38

## Minor updates

- FIPS variable in usa_facts_data() now 5-digit 
  string to match other datasets.
- Add county_to_state_fips() function to convert
  from US county FIPS to state FIPS; no need to 
  carry both values in a dataset.

## Major changes

- Add `dataset_details()` to catalog column names, date 
  ranges (for datasets with dates), and dimensions
- All dataset tests pass


# sars2pack 0.0.36

## Bug fixes

- Fixed caching bug that caused data resources that
  needed updates to be missed. 

# sars2pack 0.0.34

## Major changes

- Add `plot_projection()` functionality to plot projections from 
  `healthdata_projections_data()` from
  https://covid19.healthdata.org/projections

# sars2pack 0.0.32

## Major changes

- Add vignette, `Datasets`, that offers quick, sortable,
  searchable dataset descriptions and column names across
  all available datasets. 


# sars2pack 0.0.30

## Major changes

- Add Descartes Labs Mobility dataset


# sars2pack 0.0.28

## Major changes

- Add healthdata.org COVID-19 morbidity and mortality
  projections data


# sars2pack 0.0.26

## Major changes

- Added Oxford Government Policy Intervention
  time series dataset


# sars2pack 0.0.22

## Major changes

- Added `available_datasets` convenience function
  that reads from a yaml file to give a nice catalog
  of available data resources in sars2pack.


# sars2pack 0.0.15

## Major changes

- added `coronatracker_data` data resource for detailed United States
  data. This is the only data resource that includes US testing
  numbers, including positive and negatives.
- added `us_county_geo_details` from US census gazetteer files to
  provide geographic details of US counties (area, lat/long, etc.)
- significantly expanded vignette to include data exploration and
  plotting of time course data for prominent pandemic sites.


# sars2pack 0.0.13

## Major changes

- `enhanced_jhu_data` now returns a tidy tbl_df
  rather than a list of wide data.frames
- new function `jhu_data_to_excel` that writes out
  "enriched" dataset to excel for sharing with non data
  science types. Replaces functionality of old 
  `enhanced_jhu_data`.

# sars2pack 0.0.12

## Major changes

- Vignette updates to include data exploration
  and time series visualization

# sars2pack 0.0.11

## Major changes

- Add NYTimes state and county data
- Support for USAFacts state and county data
- Support for Johns Hopkins international data



