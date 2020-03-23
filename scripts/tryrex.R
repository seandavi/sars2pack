library(tidyverse)
confirmed <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"))
deaths <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"))
recovered <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv"))

confirmed_long <- pivot_longer(confirmed, names_to = "date", cols = ends_with("20"), values_to = "confirmed")
deaths_long <- pivot_longer(deaths, names_to = "date", cols = ends_with("20"), values_to = "deaths")
recovered_long <- pivot_longer(recovered, names_to = "date", cols = ends_with("20"), values_to = "recovered")

library(lubridate)

all_long <- deaths_long %>% 
  full_join(confirmed_long) %>% 
  full_join(recovered_long) %>%
  filter(confirmed>0) %>% 
  
  mutate(date_asdate = mdy(str_replace(date,"20$","2020"))) %>% 
  rename(country=`Country/Region`, state=`Province/State`) %>%
  #filter(!state %in% c("From Diamond Princess","Diamond Princess")) %>%
  mutate(state=ifelse(is.na(state),"none",state)) %>%   
  mutate(country_state=paste0(country, "___", state) %>% as.factor()  ) %>%
  
  arrange(country_state, date_asdate) %>%
  filter(confirmed>0) %>% #subset to only places/time periods that have had confirmed
  group_by(country_state) %>%
  mutate(days_since_1_confirmed=cumsum(confirmed>0)) %>%
  mutate(confirmed_fd=confirmed-lag(confirmed)) %>%

  ungroup() %>%
  filter(days_since_1_confirmed>0) 
    
padded <- all_long %>%
          tidyr::expand(country_state, days_since_1_confirmed) %>% 
          separate(col=country_state, into=c('country','state'), sep = "___", remove = T) 

all_long <- padded %>% 
            left_join(all_long) %>% 
            arrange(country, state, days_since_1_confirmed) %>%
            mutate(country_state=paste0(country, "___", state) %>% as.factor()  )
