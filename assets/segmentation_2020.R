library(tidyverse)


# Data Import -------------------------------------------------------------

data_pbi_2020 <-
  read_csv(
    "Data/Raw/data_pbi_2020.csv",
    
    col_types =  cols(
      Id = col_character(),
      Name = col_character(),
      Kind = col_character(),
      Data.Column1 = col_character(),
      Data.Column2 = col_character(),
      Data.Column3 = col_character(),
      Data.Column4 = col_character(),
      Data.Column5 = col_character(),
      Data.Column6 = col_character(),
      Data.Column7 = col_character(),
      Data.Column8 = col_character()
    )
  )
View(data_pbi_2020)



# Table of MDAs 2020 -----------------------------------------------------------------
MDA_Table_2020 <- data_pbi_2020 %>%
  filter(str_length(Data.Column2) == 3 &
           Id == "Table001" & str_detect(Data.Column2, "^\\d")) %>%
  select(Data.Column2, Data.Column3) %>%
  rename(Code = Data.Column2, MDA = Data.Column3) %>%
  arrange(Code) %>%
  mutate(No = 1:n(), Code = str_c("0", Code))


# Cleaning ----------------------------------------------------------------

data_pbi_2020_start <- data_pbi_2020 %>%
  arrange(Id, Data.Column1) %>%
  #the table headings 242001001 and 344001001 are missing from the data but their table contents are in the data
  #so we add the table headings by mimmicking the pattern as shown for the rest tables
  add_row(
    Id = "Table1080",
    Name = "Table1080 (Page 1136-1137)",
    Kind = "Table",
    Data.Column1 = "242001001",
    Data.Column2 = "NATIONAL SALARIES, INCOMES AND WAGES COMMISSION",
    .before = 6846
  ) %>%
  add_row(
    Id = "Table1240",
    Name = "Table1240 (Page 1234-1235)",
    Kind = "Table",
    Data.Column1 = "344001001",
    Data.Column2 = "CODE OF CONDUCT BUREAU",
    .before = 11493
  ) %>%
  mutate(
    subCostCenterSum_Code = case_when(
      #dectects any figure from 0-9 in a column
      str_detect(Data.Column2, "^[0-9]") &
        str_detect(Data.Column2, "\\,", negate = TRUE) &
        str_length(Data.Column2) == 9 ~ paste0('0', Data.Column2)
    ),
    #the following detects the apperance of "ERGP" strictly () once {1}
    projectCode = case_when(str_detect(Data.Column1, "^ERGP{1}") ~ Data.Column1),
    expenditureCods = case_when(
      #detects "^2" from the beginning of the column content
      str_detect(Data.Column1, "^2") &
        #[A-Z] because the desired colum have text in the next column
        str_detect(Data.Column2, "[A-Z]") ~ Data.Column1
    ),
    #here we choose to identify relevant tables by their starting codes which in most cases only have two columns thus the sucessuive columns will be empty
    table_identifier =
      case_when(
        str_detect(Data.Column1, "^[0-9]") &
          is.na(Data.Column3) &
          is.na(Data.Column4) &
          is.na(Data.Column5)  ~ paste0('0', Data.Column1) ,
        !is.na(subCostCenterSum_Code) ~ subCostCenterSum_Code
      ) #subCostCenterSum_Code
    ,
    table_identifier_MDA = if_else(
      subCostCenterSum_Code == table_identifier,
      Data.Column3,
      case_when(!is.na(table_identifier) ~ Data.Column2)
    )
  ) %>%
  # we then fill the sucessive rows downwards
  fill(table_identifier, table_identifier_MDA) %>%
  mutate(
    # Code will be later renamed costCenter_Code
    Code = str_sub(table_identifier, end = 4),
    lineExpCode = case_when(
      Data.Column1 == "2" &
        str_detect(Data.Column2, "^EXP{1}") ~ Data.Column1
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
    Year = 2020
  ) %>%
  fill(
    lineExpCode,
    lineExpTerm,
    lineExpCodeLevel1,
    lineExpTermLevel1,
    lineExpTermLevel2,
    lineExpCodeLevel2,
    lineExpTermLevel3,
    lineExpCodeLevel3
  ) %>%
  filter(!is.na(lineExpCodeLevel4)) %>%
  left_join(MDA_Table_2020) %>%
  rename(costCenter_Code = Code,
         costCenter_Code_MDA = MDA) %>%
  mutate(Amount = if_else(
    is.na(Data.Column3),
    as.numeric(str_replace_all(Data.Column4, ",", "")),
    as.numeric(str_replace_all(Data.Column3, ",", ""))
  )) %>%
  select(
    Year,
    costCenter_Code,
    costCenter_Code_MDA,
    table_identifier,
    table_identifier_MDA,
    (lineExpCode:Amount),
    -No
  )

write_csv(data_pbi_2020_start,
          'Data/finished_sets/csv_/budget_2020.csv')

# convert column names to readable forms
budget_2020_public <- data_pbi_2020_start %>%
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
write_csv(budget_2020_public, "Budget_Data/budget_2020.csv")


# inspection --------------------------------------------------------------

finshed_2020 <- data_pbi_2020_start %>%
  filter(!is.na(expenditureCods),  !is.na(lineExpCodeLevel4)) %>%
  mutate(Amount = if_else(
    is.na(Data.Column3),
    as.numeric(str_replace_all(Data.Column4, ",", "")),
    as.numeric(str_replace_all(Data.Column3, ",", ""))
  )) %>%
  select(-(Id:projectCode))

# wertz -------------------------------------------------------------------



check_data_pbi_2020 <- data_pbi_2020_start %>%
  filter(!is.na(expenditureCods),  !is.na(lineExpCodeLevel4)) %>%
  mutate(Amount = if_else(
    is.na(Data.Column3),
    as.numeric(str_replace_all(Data.Column4, ",", "")),
    as.numeric(str_replace_all(Data.Column3, ",", ""))
  )) %>%
  #filter(table_identifier == "0111001002") %>%
  group_by(costCenter_Code, lineExpTermLevel1) %>%
  summarise(totalAllocation = sum(Amount)) %>%
  pivot_wider(names_from = lineExpTermLevel1, values_from = totalAllocation)
