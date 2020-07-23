library(tidyverse)
proj_2019_MDA <- read_csv(
  "Data/Raw/proj_2019_MDA.csv",
  col_types = cols(
    Column2 = col_character(),
    projectCode = col_character(),
    project_description = col_character(),
    table_identifier = col_character(),
    table_identifier_MDA = col_character()
  )
)
View(proj_2019_MDA)

proj_2019_MDA_Clean <- proj_2019_MDA %>% 
  fill(table_identifier, table_identifier_MDA) %>% 
  filter(!is.na(projectCode)) %>% 
  select(-Column1, -Column2)