#' World population details from United Nations
#' 
#' @source 
#' - \url{https://population.un.org}
#' 
#' @author Sean Davis <seandavi@gmail.com>
#' 
#' @return a `data.frame`
#' 
#' @examples 
#' res = world_population_data()
#' 
#' colnames(res)
#' dplyr::glimpse(res)
#' head(res)
#' 
#' 
#' @export

world_population_data <- function() {
  .fix_df = function(df) {
    df %>% tidyr::pivot_longer(cols="0-4":"100+",names_to='age_group',values_to='population') %>%
      dplyr::select(-c("Index"))
  }
  get_url = function(url1) {
    tf <- tempfile(fileext = ".xlsx")
    utils::download.file(url1,tf)
    tf
  }
  f = get_url('https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2019_POP_F15_2_ANNUAL_POPULATION_BY_AGE_MALE.xlsx')
  male = readxl::read_excel(f,sheet=1, skip=16)
  f = get_url('https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2019_POP_F15_3_ANNUAL_POPULATION_BY_AGE_FEMALE.xlsx')
  female = readxl::read_xlsx(f,sheet=1, skip=16)
  dplyr::bind_rows(lapply(list(male = male,female = female),.fix_df),.id='gender') %>%
    dplyr::rename(variant = 'Variant',region_code='Country code', data_category='Type',
                  year = "Reference date (as of 1 July)", notes="Notes",
                  region_type = 'Region, subregion, country or area *',
                  parent_region_code='Parent code') %>%
    dplyr::mutate(population = round(suppressWarnings(as.numeric(.data$population))*1000))

}
