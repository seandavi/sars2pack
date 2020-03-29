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



