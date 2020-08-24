library(tidyverse)


# Extract the Capital Expenditure projects --------------------------------


output2019_clean <- output2019 %>%
  rename(
    projectCode = `Federal Government of Nigeria`,
    project_description = X2,
    Status = X3,
    Amount = X4
  ) %>%
  mutate(
    table_identifier = case_when(
      str_detect(projectCode , "^0[1-5][1-8]") &
        !is.na(project_description) &
        is.na(Status) & is.na(Amount) ~ projectCode
    ),
    table_identifier_MDA = case_when(!is.na(table_identifier) ~ project_description),
    Amount = as.numeric(gsub(",", "", Amount)),
    Year = 2019
  ) %>%
  filter(
    str_detect(projectCode, "^0[1-5][1-8]") &
      !is.na(project_description) &
      is.na(Status) &
      is.na(Amount) | str_detect(projectCode, "(ERGP){1}")
  )  %>%
  fill(table_identifier, table_identifier_MDA) %>%
  mutate(costCenter_Code = str_sub(table_identifier, 1,  4)) %>%
  filter(str_detect(projectCode, "(ERGP){1}")) %>%
  select(
    table_identifier,
    table_identifier_MDA,
    costCenter_Code,
    Year,
    projectCode,
    project_description,
    Status,
    Amount
  )


# Refine columns ----------------------------------------------------------
#rename cloumns to fit other years' data
data_pbi_2019_start_2 <- output2019 %>%
  rename(
    Data.Column1 = `Federal Government of Nigeria`,
    Data.Column2 = X2,
    Data.Column3 = X3,
    Data.Column4 = X4,
    Data.Column5 = X5,
    Data.Column6 = X6,
    Data.Column7 = X7,
    Data.Column8 = X8
  ) %>%
  mutate(
    table_identifier = case_when(
      str_detect(Data.Column1, "^0") & str_length(Data.Column1) == 10 &
        str_detect(Data.Column4, "^2019") |
        str_detect(Data.Column3, "^2019") ~ Data.Column1
    ),
    table_identifier_MDA = case_when(!is.na(table_identifier) ~ Data.Column2)
  )
