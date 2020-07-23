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
  select(-Column1, -Column2) %>% 
  mutate(table_identifier2 = case_when(str_detect( table_identifier_MDA, "SCIENCE EQUIPMENT DEVELOPMENT INSTITUTE- ENUGU") ~ "0228047001", 
                                    str_detect(table_identifier_MDA, "DENTAL TECHNOLOGY REGISTRATION B") ~ "0521007001" ,
                                    str_detect(table_identifier_MDA, "AUDITOR GENERAL FOR THE FEDER") ~ "0140001001",
                                    str_detect(table_identifier_MDA, "TECHNOLOGY BUSINESS INCUBATOR CENTRE - B/ KEBBI") ~ "0228021001",
                                    str_detect( table_identifier_MDA, "NIGERIA INSTITUTE FOR SCIENCE LABORATORY TECHNOLOGY - IBADAN") ~ "0228051001",
                                    str_detect( table_identifier_MDA, "NIGERIA ARMY UNIVERSITY, BIU") ~ "0517021044",
                                    str_detect( table_identifier_MDA, "NATIONAL HEALTH INSURANCE SCHEME") ~ "0521002001",
                                    str_detect( table_identifier_MDA, "OPTOMETRIST AND DISPENSING OPTICIANS BOARD OF NIGERIA") ~ "0521009001"
                                    ))

