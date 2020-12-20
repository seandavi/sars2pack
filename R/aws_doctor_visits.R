aws_doctor_visits <- function() {
    url = 'https://media.githubusercontent.com/media/covid-projections/covid-data-public/master/data/aws-lake/timeseries-doctor-visits.csv'
    rpath = s2p_cached_url(url)
    readr::read_csv(rpath, col_types = readr::cols())
}

google_trends_data <- function() {
    url = 'https://media.githubusercontent.com/media/covid-projections/covid-data-public/master/data/aws-lake/timeseries-google-survey.csv'
    rpath = s2p_cached_url(url)
    readr::read_csv(rpath, col_types = readr::cols())
}

facebook_survey_data <- function() {
    url = 'https://media.githubusercontent.com/media/covid-projections/covid-data-public/master/data/aws-lake/timeseries-fb-survey.csv'
    rpath = s2p_cached_url(url)
    readr::read_csv(rpath, col_types = readr::cols())
}


quidel_data <- function() {
    url = 'https://media.githubusercontent.com/media/covid-projections/covid-data-public/master/data/aws-lake/timeseries-quidel.csv'
    rpath = s2p_cached_url(url)
    readr::read_csv(rpath, col_types = readr::cols())
}

aws_hospital_admissions_index_data <- function() {
    url = "https://media.githubusercontent.com/media/covid-projections/covid-data-public/master/data/aws-lake/timeseries-hospital-admissions.csv"
    rpath = s2p_cached_url(url)
    readr::read_csv(rpath, col_types = readr::cols())
}

covidcast_signal_data <- function(...) {
    if(requireNamespace('covidcastR')) {
        return(covidcastR::covidcast_signal(...))
    }
    stop('The covidcastR package is required for this functionality. Please install from https://github.com/cmu-delphi/covidcast')
}
