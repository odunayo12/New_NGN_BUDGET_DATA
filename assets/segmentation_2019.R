data_pbi_2019 <- read_csv(
  "Data/Raw/data_pbi_2019.csv",
  
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
View(data_pbi_2019)


data_pbi_2019_start <- data_pbi_2019 %>%
  arrange(Id) %>%
  mutate(
    subCostCenterSum_Code = case_when(
      #dectects any figure from 0-9 in a column
      str_detect(Data.Column2, "^[0-9]") &
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
    # !is.na(projectCode) ensures that table identifier does not include the projects. we will fix it in the comprehensive table
    table_identifier = case_when(
      str_detect(Data.Column1, "^[0-9]") &
        is.na(Data.Column3) &
        is.na(Data.Column4) & is.na(Data.Column5) & !is.na(projectCode)
      ~ paste0('0', Data.Column1)
    ),
    table_identifier_MDA = case_when(!is.na(table_identifier) ~ Data.Column2)
  ) %>%
  # we then fill the sucessive rows downwards
  #fill(table_identifier, table_identifier_MDA) %>%
  mutate(
    costCenter_Code = str_sub(table_identifier, end = 4),
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
    Year = 2019
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
