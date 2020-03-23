# this is grabbed from https://rexdouglass.github.io/TIGR/R0_estimates.nb.html on 23 mar 2020
# there is one segment involving a local file that is altered, see "ALTERED" below
# I moved all library commands to top


library(tidyverse)
library(R0)  # added by VJC
library(lubridate)
library(WikidataR)
library(spatstat) #install.packages('spatstat')
library(DT)

confirmed <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"))
deaths <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"))
recovered <- read_csv(url("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv"))

confirmed_long <- pivot_longer(confirmed, names_to = "date", cols = ends_with("20"), values_to = "confirmed")
deaths_long <- pivot_longer(deaths, names_to = "date", cols = ends_with("20"), values_to = "deaths")
recovered_long <- pivot_longer(recovered, names_to = "date", cols = ends_with("20"), values_to = "recovered")


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

# THIS STATEMENT PREVENTS RECOMPUTATION OF POPULATION DATA
fromscratch=F
# SKIPPED
if(fromscratch){
  #We need to grab populations
  places <- all_long %>% dplyr::select(country,state) %>% distinct() %>% mutate(search=paste0(state,", ", country ))  %>% mutate(search= ifelse(is.na(state) | state=="none", country, state ) )
  wiki_searches <- list()
  for(q in places$search){
    print(q)
    try({
      #wiki <- find_item("Ramsey County")
      wiki <- find_item(q)
      temp <- as.data.frame(wiki[[1]])
      temp$search <- q
      wiki_searches[[q]] <- temp
    })
  }
  wiki_searches_df <- bind_rows(wiki_searches)
  
  item_df <- list()
  for(q in wiki_searches_df$id){
    print(q)
    try({
      item_df[[q]] <- get_item(id = q)
    })
  }
  wiki <- find_item("New York")
  
  latest_pop_list <- list()
  for(q in names(item_df)){
    print(q)
    try({
      latest_pop_list[[q]] <- data.frame(wikidata_id=q, P1082= rev(item_df[[q]][[1]]$claims$P1082$mainsnak$datavalue$value$amount)[1])
    })
  }
  latest_pop_df <- places %>% left_join(wiki_searches_df %>% dplyr::select(search,wikidata_id=id), by=c('search'='search')) %>% left_join( bind_rows(latest_pop_list) ) %>% 
    mutate(population= str_replace(P1082,"\\+","") %>% as.numeric()    ) %>%
    mutate(population_log= log(population)) %>%
    mutate(state=ifelse(is.na(state),"none",state)) %>% distinct() %>% arrange(country, state) 
  
  saveRDS(latest_pop_df,"/media/skynet2/905884f0-7546-4273-9061-12a790830beb/rwd_github_private/TIGR/data_temp/latest_pop_df.RDS")

}

# ALTERED -- I HAVE RDS file locally after running code above

# latest_pop_df <- readRDS("/media/skynet2/905884f0-7546-4273-9061-12a790830beb/rwd_github_private/TIGR/data_temp/latest_pop_df.RDS")
latest_pop_df = readRDS("latest_pop_df.rds")

all_long_covariates <- all_long %>% 
                       left_join(latest_pop_df) %>% 
                       arrange(country, state, days_since_1_confirmed) 


mGT<-generation.time("gamma", 
                     c(3.96,#Serial interval mean
                       4.75 #Serial interval standard deviation
                       )
                     ) #mean and sd of the disease?



#Note many of these will throw errors for lack of data

locations <- all_long_covariates$country_state
r_list <- list()
for(q in locations %>% unique() ){
  print(q)
  try({
    temp <- all_long_covariates %>% filter(country_state %in% q) %>% filter(!is.na(confirmed))
    temp$confirmed_fd[1]<-temp$confirmed[1]

    incidents <- as.vector(temp$confirmed_fd )
    pop <- temp$population[1]

    estR0<-est.R0.ML(
          epid=incidents, 
          GT=mGT, 
          begin=1,
          #end=length(incidents), 
          methods="ML", #c("EG", "ML", "TD", "AR", "SB"),
          pop.size=pop, #Population size in which the incident cases were observed. See more details in est.R0.AR documentation
          impute.values=F #incidents[1]>10 #if the data start with more than 10 confirmed cases immediately then assume left censor and impute #imputation is really slow
    )
    #attributes(estR0)
    estR0
    r_list[[q]] <- data.frame(country=temp$country[1],state=temp$state[1], r_ml=round(estR0$R,2), pop=pop, R2= round(estR0$Rsquared,2))
  })
}

r_df <- bind_rows(r_list)

weights <- table(r_df$country)
weights <- weights[r_df$country]
weights <- 1/(weights/max(weights))

results <- r_df %>% filter(!is.na(pop)) %>% pull(r_ml) %>% weighted.quantile(w=weights) #weight by country, exclude obs with no population data.

r_df %>% filter(!is.na(pop)) %>% ggplot(aes(x=r_ml)) + geom_density() + ggtitle("Distribution R0 Estimates Across Countries") +  geom_vline(xintercept = results[3], stat = 'vline', linetype = "dashed") + theme_bw() +
  scale_x_continuous(breaks=seq(0, 30, by = 1)) + annotate("text", x = 6, y = .5, label = "Median R0=2.56") + xlab("R0 (maximum likelihood estimate)")

r_df %>%
  mutate(r_ml= round(r_ml,2)) %>%
datatable(rownames = FALSE,
          options = list(
            pageLength = 50,
            columnDefs = list(list(className = 'dt-center', targets = "_all")
                              )
            )
)

