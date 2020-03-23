# second phase of Rex Douglass github.io code
fromscratch=F
if(fromscratch){
  #We need to grab populations
  places <- all_long %>% dplyr::select(country,state) %>% distinct() %>% mutate(search=paste0(state,", ", country ))  %>% mutate(search= ifelse(is.na(state) | state=="none", country, state ) )
  library(WikidataR)
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

latest_pop_df <- readRDS("/media/skynet2/905884f0-7546-4273-9061-12a790830beb/rwd_github_private/TIGR/data_temp/latest_pop_df.RDS")

all_long_covariates <- all_long %>% 
                       left_join(latest_pop_df) %>% 
                       arrange(country, state, days_since_1_confirmed) 
