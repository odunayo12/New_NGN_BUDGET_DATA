#to format: First CTRL+A, then CTRL+SHIFT+A.
#pipe: Ctrl+shift+m
#comment: Ctrl+shift+c
library(tidyverse)

#list_of_MDA_Codes <- tableOfContent$Code

# Data Import -------------------------------------------------------------

data_pbi <- read_csv(
  "Data/Raw/data_pbi_2018.csv",
  col_types = cols(
    Data.Column1 = col_character(),
    Data.Column3 = col_character(),
    Data.Column4 = col_character(),
    Data.Column5 = col_character(),
    Data.Column6 = col_character(),
    Data.Column7 = col_character(),
    Data.Column8 = col_character(),
    Id = col_character()
  )
)

# Cleaning ----------------------------------------------------------------

#You have to use one of the previous versions on Github to get the EGRP Projects. The version that led to the completion before finishing the 2019 version.
#in what follows we separate by page in the name column to extract the last page numbers at the end of the Name column

data_pbi_2018 <-
  data_pbi %>%
  arrange(Id, Data.Column1) %>%
  # mutate() %>% 
  add_row(
    Id = "Table1519",
    Name = "Table1519 (Page 1914-1915)",
    Kind = "Table",
    Data.Column1 = "543001001",
    Data.Column2 = "NATIONAL POPULATION COMMISSION",
    .before = 35464
  ) %>%
  add_row(
    Id = "Table1030",
    Name = "Table1030 (Page 1215-1216)",
    Kind = "Table",
    Data.Column1 = "513003001",
    Data.Column2 = "NATIONAL YOUTH SERVICE CORPS (NYSC)",
    .before = 7156
  ) %>%
  add_row(
    Id = "Table1070",
    Name = "Table1070 (Page 1245-1246)",
    Kind = "Table",
    Data.Column1 = "517005001",
    Data.Column2 = "JOINT ADMISSIONS MATRICULATION BOARD",
    .before = 8520
  ) %>%
  add_row(
    Id = "Table1511",
    Name = "Table1511 (Page 1905-1906)",
    Kind = "Table",
    Data.Column1 = "535016001",
    Data.Column2 = "NATIONAL ENVIRONMENTAL STANDARDS AND REGULATIONS ENFORCEMENT AGENCY",
    .before = 35158
  ) %>%
  add_row(
    Id = "Table1341",
    Name = "Table1341 (Page 1679-1680)",
    Kind = "Table",
    Data.Column1 = "521005001",
    Data.Column2 = "NATIONAL ARBOVIRUS AND VECTOR RESEARCH",
    .before = 26582
  ) %>%
  add_row(
    Id = "Table1350",
    Name = "Table1350 (Page 1692)",
    Kind = "Table",
    Data.Column1 = "521012001",
    Data.Column2 = "PHARMACIST COUNCIL OF NIGERIA COUNCIL",
    .before = 27062
  ) %>%
  mutate(
    SN = row_number(),
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
    table_identifier = case_when(
      str_detect(Data.Column1, "^[0-9]") &
        is.na(Data.Column3) &
        is.na(Data.Column4) &
        is.na(Data.Column5)  ~ paste0('0', Data.Column1),
      !is.na(subCostCenterSum_Code) ~ subCostCenterSum_Code
    ),
    table_identifier_MDA = if_else(
      subCostCenterSum_Code == table_identifier,
      Data.Column3,
      case_when(!is.na(table_identifier) ~ Data.Column2)
    )
  ) %>%
  # we then fill the sucessive rows downwards
  fill(table_identifier, table_identifier_MDA) %>%
  mutate(
    costCenter_Code = str_sub(table_identifier, end = 4),
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
    Year = 2018
  ) %>%
  #arrange(Id, Data.Column1) %>%
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
  select(-Name, -Kind)

#write_csv(data_pbi_2018, "Data/semi_finished/budget_2018.csv")

# checks ------------------------------------------------------------------


check_data_pbi_2018 <- data_pbi_2018 %>%
  filter(!is.na(expenditureCods),  !is.na(lineExpCodeLevel4)) %>%
  mutate(Amount = if_else(
    is.na(Data.Column3),
    as.numeric(str_replace_all(Data.Column4, ",", "")),
    as.numeric(str_replace_all(Data.Column3, ",", ""))
  )) %>%
  group_by(costCenter_Code, lineExpTermLevel1) %>%
  summarise(totalAllocation = sum(Amount)) %>%
  pivot_wider(names_from = lineExpTermLevel1, values_from = totalAllocation) %>%
  replace(is.na(.), 0) %>%
  #summarise_all(funs(sum))
  mutate(budgetTotal = format((`CAPITAL EXPENDITURE` + `OTHER RECURRENT COSTS` + `PERSONNEL COST`),
                              big.mark = ",",
                              nsmall = 1
  ))

check_data <- function(requiredData) {
  requiredD <-
    requiredData %>% filter(!is.na(expenditureCods),  !is.na(lineExpCodeLevel4)) %>%
    mutate(Amount = if_else(
      is.na(Data.Column3),
      as.numeric(str_replace_all(Data.Column4, ",", "")),
      as.numeric(str_replace_all(Data.Column3, ",", ""))
    )) %>%
    group_by(costCenter_Code, lineExpTermLevel1) %>%
    summarise(totalAllocation = sum(Amount)) %>%
    pivot_wider(names_from = lineExpTermLevel1, values_from = totalAllocation)
  #destination <-str_extract(requiredData, "")
  # destination  <- str_c("check_", fileName, ".csv")
  #write.csv(fileName, str_c("check_", fileName, ".csv"))
  return(requiredD)
}

check_data(data_pbi_2018)
