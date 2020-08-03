library(tidyverse)

#TODO inspect table_identifier, table_identifier_MDA if correct, else use subCostCenterSum_Code to pull respective MDA and sub MDA from MDA_Table
budget_18_19_20 <-
  rbind(data_pbi_2018, data_pbi_2019_start, data_pbi_2020_start)


projects_Unique <- as_tibble(budget_18_19_20) %>%
  filter(!is.na(projectCode)) %>%
  select(
    table_identifier,
    table_identifier_MDA,
    costCenter_Code,
    Year,
    projectCode,
    Data.Column2,
    Data.Column3,
    Data.Column4
  ) %>%
  rename(project_description = Data.Column2,
         Status = Data.Column3,
         Amount = Data.Column4) %>%
  filter(Year != 2019) %>%
  mutate(Amount = as.numeric(str_replace_all(Amount, ",", ""))) #%>%
#filter(table_identifier_MDA == "OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT")
# group_by(Year, table_identifier, table_identifier_MDA) %>%
# summarise(count = n()) OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT
# across() selects specified columns
# distinct(projectCode, across(table_identifier:Amount))

#project section of the budget from 2018-2020
projects_18_19_20 <- rbind(projects_Unique, output2019_clean) %>%
  mutate(id = str_c(Year, projectCode))

write_csv(projects_18_19_20,
          'Data/finished_sets/csv_/projects_18_19_20.csv')



#overview by MDAs
summary_by_MDA  <-
  budget_18_19_20 %>% filter(
    str_length(Data.Column2) == 3 &
      !is.na(Data.Column4)
    # !is.na(Data.Column3)  &
    #   !is.na(Data.Column4) &
    #   !is.na(Data.Column5) &
    #   !is.na(Data.Column6) &
    #   !is.na(Data.Column7) & !is.na(Data.Column8),
    # str_detect(Data.Column3, "^(MDA){1}", negate = T),
    # !is.na(Data.Column2),
    # #note the difference between summary_by_MDA and summary_by_sub_MDA lies in the use of !
    # is.na(subCostCenterSum_Code)
  )%>% 
  mutate(subCostCenterSum_Code = str_c("0", Data.Column2)) %>% 
  select(Year,  subCostCenterSum_Code, Data.Column3:Data.Column8) %>% 
  rename(MDA = Data.Column3, Personnel = Data.Column4, Overhead = Data.Column5, Recurrent = Data.Column6, Capital = Data.Column7, totalAllocation = Data.Column8) 

write_csv(summary_by_MDA,
          'Data/finished_sets/csv_/summary_by_MDA_18_19_20.csv')

#overview by sub_MDAs
summary_by_sub_MDA  <-
  budget_18_19_20 %>% filter(
    !is.na(Data.Column3)  &
      !is.na(Data.Column4) &
      !is.na(Data.Column5) &
      !is.na(Data.Column6) &
      !is.na(Data.Column7) & !is.na(Data.Column8),
    str_detect(Data.Column3, "^(MDA){1}", negate = T),
    !is.na(Data.Column2),
    !is.na(subCostCenterSum_Code)
  )%>% 
  select(Year, subCostCenterSum_Code,  Data.Column3:Data.Column8) %>% 
  rename(MDA = Data.Column3, Personnel = Data.Column4, Overhead = Data.Column5, Recurrent = Data.Column6, Capital = Data.Column7, totalAllocation = Data.Column8) 

write_csv(summary_by_sub_MDA,
          'Data/finished_sets/csv_/summary_by_sub_MDA_18_19_20.csv')
# projects_18_19_20 <- rbind(projects_Unique, output2019_clean) %>%
#   filter(table_identifier_MDA == "OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT") %>%
#   group_by(Year, table_identifier, table_identifier_MDA) %>%
#   arrange(projectCode, Year)
wweee_check <- budget_18_19_20 %>% filter(
    !is.na(lineExpTermLevel4)
) %>% filter(Year == 2018) %>% 
  select(Year, table_identifier:lineExpTermLevel4, Data.Column2, Data.Column3 ) %>% 
  mutate(AMount = as.numeric(str_replace_all(Data.Column3, ",", ""))) %>% 
  filter(table_identifier == "0111001001") %>% 
  group_by(table_identifier) %>% 
  summarise(sum(AMount))
         