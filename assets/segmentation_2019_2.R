library(tidyverse)


output2019_clean <- output2019 %>%
  rename(projectCode = `Federal Government of Nigeria`, project_description = X2, Status = X3, Amount = X4) %>%
  mutate(
    table_identifier = case_when(
      str_detect(projectCode , "^0[1-5][1-8]") &
        !is.na(project_description) & is.na(Status) & is.na(Amount) ~ projectCode
    ),
    table_identifier_MDA = case_when(!is.na(table_identifier) ~ project_description),
    Amount = as.numeric(gsub(",", "", Amount)),
    Year = 2019
  ) %>%
  filter(
    str_detect(projectCode, "^0[1-5][1-8]") &
      !is.na(project_description) &
      is.na(Status) & is.na(Amount) | str_detect(projectCode, "(ERGP){1}")
  )  %>%
  fill(table_identifier, table_identifier_MDA) %>%
  mutate(costCenter_Code = str_sub(table_identifier, 1,  4)) %>% 
  filter(str_detect(projectCode, "(ERGP){1}")) %>%
  select(table_identifier, table_identifier_MDA, costCenter_Code, Year, projectCode, project_description, Status, Amount )
