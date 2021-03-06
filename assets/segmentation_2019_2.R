library(tidyverse)

# Import data -------------------------------------------------------------


library(readr)
output2019 <- read_csv(
  "Data/Raw/output2019.csv",
  col_types = cols(
    X4 = col_number(),
    X5 = col_number(),
    X6 = col_character(),
    X7 = col_character(),
    X8 = col_character()
  )#,
  #locale = locale(asciify = TRUE)
)
View(output2019)

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
  # substitute special chars with empty space and trim content
  mutate_at(vars(
    Data.Column1,
    Data.Column2,
    Data.Column3,
    Data.Column4,
    Data.Column5,
    Data.Column6,
    Data.Column7,
    Data.Column8
  ), function(x) {
    #the following does same thing
    #iconv(x, 'utf-8', 'ascii', sub='')
    gsub('[^ -~]', '', str_trim(x))
  }) %>%
  mutate(
    #replace missing values
    Data.Column2 = replace(
      Data.Column2,
      Data.Column3 == 'MINISTRY OF DEFENCE' &
        Data.Column1 == '1.',
      '0116'
    ),
    Data.Column3 = replace(
      Data.Column3,
      Data.Column2 == '0125' &
        Data.Column1 == '1.' &
        is.na(Data.Column3),
      'OFFICE OF THE HEAD OF THE CIVIL SERVICE OF THE FEDERATION'
    ),
    table_identifier = case_when(
      str_detect(Data.Column1, "^0") & str_length(Data.Column1) == 10 &
        str_detect(Data.Column4, "^2019") |
        str_detect(Data.Column3, "^2019") ~ Data.Column1
    ),
    table_identifier_MDA = case_when(!is.na(table_identifier) ~ Data.Column2)
  ) %>%
  fill(table_identifier, table_identifier_MDA) %>%
  mutate(
    #costCenter_Code = str_sub(table_identifier, end = 4),
    costCenter_Code = case_when(
      str_length(Data.Column2) == 4 &
        str_detect(Data.Column2, '^0') ~ Data.Column2
    ),
    costCenter_Code_MDA = case_when(!is.na(costCenter_Code) ~ Data.Column3),
    lineExpCode = case_when(
      Data.Column1 == "2" &
        str_detect(Data.Column2, "(EXP){1}") ~ Data.Column1
    ),
    lineExpTerm = case_when(!is.na(lineExpCode) ~ Data.Column2),
    lineExpCodeLevel1 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 2 &
        str_length(Data.Column2) > 5 ~ Data.Column1
    ),
    lineExpTermLevel1 = case_when(!is.na(lineExpCodeLevel1) ~ Data.Column2),
    lineExpCodeLevel2 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 4 ~ Data.Column1
    ),
    lineExpTermLevel2 = case_when(!is.na(lineExpCodeLevel2) ~ Data.Column2),
    lineExpCodeLevel3 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 6 ~ Data.Column1
    ),
    lineExpTermLevel3 = case_when(!is.na(lineExpCodeLevel3) ~ Data.Column2),
    lineExpCodeLevel4 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 8 ~ Data.Column1
    ),
    lineExpTermLevel4 = case_when(!is.na(lineExpCodeLevel4) ~ Data.Column2),
    Amount = if_else(
      is.na(Data.Column4),
      as.numeric(Data.Column5),
      as.numeric(Data.Column4)
    ),
    Year = 2019
  ) %>%
  fill(
    lineExpCode,
    lineExpTerm,
    lineExpCodeLevel1,
    lineExpTermLevel1,
    lineExpTermLevel2,
    lineExpCodeLevel2,
    lineExpTermLevel3,
    lineExpCodeLevel3,
    costCenter_Code,
    costCenter_Code_MDA
  ) %>%
  filter(!is.na(lineExpCodeLevel4)) %>%
  select(
    Year,
    costCenter_Code,
    costCenter_Code_MDA,
    table_identifier,
    table_identifier_MDA,
    (lineExpCode:Amount)
  )

# save local copy
write_csv(data_pbi_2019_start_2,
          "Data/finished_sets/csv_/budget_2019.csv")


# convert column names to readable forms
budget_2019_public <- data_pbi_2019_start_2 %>%
  rename(
    `MDA Code` = table_identifier,
    `MDA Name` = table_identifier_MDA,
    `Main MDA Code` = costCenter_Code,
    `Main MDA Name` = costCenter_Code_MDA,
    `Expenditure Code` = lineExpCode,
    `Expenditure` = lineExpTerm,
    `Fund Code` = lineExpCodeLevel1,
    `Fund` = lineExpTermLevel1,
    `Line Expense Code` = lineExpCodeLevel2,
    `Line Expense` = lineExpTermLevel2,
    `Line Expense Sub-group Code` = lineExpCodeLevel3,
    `Line Expense Sub-group` = lineExpTermLevel3,
    `Main Cost Code` = lineExpCodeLevel4,
    `Main Cost Item` = lineExpTermLevel4
  )

# save the data
write_csv(budget_2019_public, "Budget_Data/budget_2019.csv")

# checks ------------------------------------------------------------------
#TODO the foolowing ommits certain figures appearing in the data_pbi_2019_start_2 data above. Fix ME.
check_data_pbi_2019_start_2 <- data_pbi_2019_start_2 %>%
  group_by(costCenter_Code, lineExpTermLevel1) %>%
  summarise(totalAllocation = sum(Amount)) %>%
  pivot_wider(names_from = lineExpTermLevel1, values_from = totalAllocation) %>%
  replace(is.na(.), 0) %>%
  mutate(budgetTotal = format((`CAPITAL EXPENDITURE` + `OTHER RECURRENT COSTS` + `PERSONNEL COST`),
                              big.mark = ",",
                              nsmall = 1
  ))