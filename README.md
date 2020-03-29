# sars2pack

```
BioManager::install('seandavi/sars2pack')
# OR
devtools::install_github('seandavi/sars2pack')
```

# Features

- [X] Access data from multiple sources: jhu_data(), usa_facts_data(), nytimes_county_data(), nytimes_state_data(), covidtracker_data()
- [X] Estimate R0 for localities or countries.
- [X] Visualize time series pandemic case growth
- [X] Perform data mashups between COVID-19 pandemic data and
      additional geographic, financial, and demographic datasets
- [ ] Create static and interactive maps of COVID-19 data for states,
      countries, or even counties.


# Workflow status

| Workflow Status | Description |
| --- | --- |
| ![Publish artifacts](https://github.com/seandavi/sars2pack/workflows/Publish%20artifacts/badge.svg) | Produces regularly updated data resources and products |
| ![pkgdown site](https://github.com/seandavi/sars2pack/workflows/pkgdown%20site/badge.svg) | Prepare and publish [pkgdown documentation](https://seandavi.github.io/sars2pack/) |



covid-19 work from John Mallery and Charles Morefield

Mostly mediating to R0 package from CRAN -- from Obedia Haneef and Boelle DOI 10.1186/1472-6947-12-147

To contribute to this package please make a fork and then issue pull requests.

An HTML version of the vignette is under inst/HTMLS.
