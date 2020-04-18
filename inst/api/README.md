# R0 REST API

## Docker deployment of plumber API

```
docker build -t sars2packapi .
docker run -p 8080:8080 sars2packapi
```

Then, test access:

http://localhost:8080/__swagger__/

## Examples

Examples, using httpie, for simplicity:

```
export URL='localhost:8080' # OR URL='https://sars2packapi-whnnxetv4q-uc.a.run.app'

http $URL/datasets

http $URL/usa_facts/locations

http "$URL/usa_facts/estimate?location_key=Virginia Beach City,VA&mean_si=4&std_si=4"

http $URL/jhu_us/locations

http "$URL/jhu_us/estimate?location_key=Federal Correctional Institution (FCI), Michigan, US&mean_si=4&std_si=4"

http "$URL/eu_data_cache/locations"

http "$URL/eu_data_cache/estimate?location_key=NA,świętokrzyskie,NA,PL&mean_si=4&std_si=4"
```


## Deploy to google cloud

```
export PROJECT_ID='YOUR_PROJECT_ID'
docker build -t gcr.io/${PROJECT_ID}/sars2pack_api .
gcloud run deploy sars2packapi --image gcr.io/${PROJECT_ID}/sars2pack_api
```
