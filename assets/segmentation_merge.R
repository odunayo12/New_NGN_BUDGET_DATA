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


# projects_18_19_20 <- rbind(projects_Unique, output2019_clean) %>%
#   filter(table_identifier_MDA == "OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT") %>%
#   group_by(Year, table_identifier, table_identifier_MDA) %>%
#   arrange(projectCode, Year)
