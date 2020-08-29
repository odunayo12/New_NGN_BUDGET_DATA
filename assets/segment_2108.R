



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
  # 521 MINISTRY OF HEALTH ------------------------------------------------------

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
  add_row(
    Id = "Table1370",
    Name = "Table1370 (Page 1721)",
    Kind = "Table",
    Data.Column1 = "521026005",
    Data.Column2 = "UNIVERSITY OF BENIN TEACHING HOSPITAL",
    .before = 28183
  ) %>%
  add_row(
    Id = "Table1380",
    Name = "Table1380 (Page 1735-1736)",
    Kind = "Table",
    Data.Column1 = "521026013",
    Data.Column2 = "AMINU KANO UNIVERSITY TEACHING HOSPITAL",
    .before = 28721
  ) %>%
  add_row(
    Id = "Table1390",
    Name = "Table1390 (Page 1748-1749)",
    Kind = "Table",
    Data.Column1 = "521027001",
    Data.Column2 = "IRRUA SPECIALIST TEACHING HOSPITAL",
    .before = 29212
  ) %>%
  add_row(
    Id = "Table1410",
    Name = "Table1410 (Page 1778-1779)",
    Kind = "Table",
    Data.Column1 = "521027016",
    Data.Column2 = "NATIONAL TB AND LEPROSY REFERRED HOSPITAL AND TRAINING, ZARIA",
    .before = 30345
  ) %>%
  add_row(
    Id = "Table1430",
    Name = "Table1430 (Page 1801-1802)",
    Kind = "Table",
    Data.Column1 = "521027033",
    Data.Column2 = "FEDERAL MEDICAL CENTRE, KEBBI STATE",
    .before = 31344
  ) %>%
  add_row(
    Id = "Table1440",
    Name = "Table1440 (Page 1817-1818)",
    Kind = "Table",
    Data.Column1 = "521027041",
    Data.Column2 = "INTERCOUNTRY CENTRE FOR ORAL HEALTH JOS",
    .before = 31932
  ) %>%
  add_row(
    Id = "Table1470",
    Name = "Table1470 (Page 1850-1851)",
    Kind = "Table",
    Data.Column1 = "521034001",
    Data.Column2 = "MEDICAL LAB. SCIENCE COUNCIL OF NIGERIA, YABA",
    .before = 32984
  ) %>%
  add_row(
    Id = "Table1480",
    Name = "Table1480 (Page 1868)",
    Kind = "Table",
    Data.Column1 = "521049001",
    Data.Column2 = "NATIONAL HOSPITAL",
    .before = 33632
  ) %>%
  add_row(
    Id = "Table1360",
    Name = "Table1360 (Page 1708)",
    Kind = "Table",
    Data.Column1 = "521022001",
    Data.Column2 = "NATIONAL POST GRADUATE MEDICAL COLLEGE OF NIGERIA-IJANIKIN LAGOS",
    .before = 27667
  ) %>%
  add_row(
    Id = "Table1450",
    Name = "Table1450 (Page 1828)",
    Kind = "Table",
    Data.Column1 = "521029011",
    Data.Column2 = "PHS, IBADAN",
    .before = 32363
  ) %>%
  add_row(
    Id = "Table1460",
    Name = "Table1460 (Page 1838)",
    Kind = "Table",
    Data.Column1 = "521029012",
    Data.Column2 = "PHS, ABEOKUTA",
    .before = 32587
  ) %>%
  
  
  #517 MINISTRY OF EDUCATION ---------------------------------------------------

add_row(
  Id = "Table1090",
  Name = "Table1090 (Page 1270-1271)",
  Kind = "Table",
  Data.Column1 = "517016001",
  Data.Column2 = "NATIONAL COMMISSION FOR COLLEGE EDUCATION SECRETARIAT",
  .before = 9581
) %>%
  add_row(
    Id = "Table1110",
    Name = "Table1110 (Page 1301)",
    Kind = "Table",
    Data.Column1 = "517018014",
    Data.Column2 = "FEDERAL POLYTECHNIC OKO",
    .before = 10780
  ) %>%
  add_row(
    Id = "Table1100",
    Name = "Table1100 (Page 1284-1285)",
    Kind = "Table",
    Data.Column1 = "517018005",
    Data.Column2 = "FEDERAL POLYTECHNIC KAURA-NAMODA",
    .before = 10155
  ) %>%
  add_row(
    Id = "Table1120",
    Name = "Table1120 (Page 1320-1321)",
    Kind = "Table",
    Data.Column1 = "517018024",
    Data.Column2 = "NATIONAL INSTITUTE FOR CONSTRUCTION TECHNOLOGY UROMI, EDO STATE",
    .before = 11567
  ) %>%
  add_row(
    Id = "Table1140",
    Name = "Table1140 (Page 1355-1356)",
    Kind = "Table",
    Data.Column1 = "517019018",
    Data.Column2 = "FEDERAL COLLEGE OF EDUCATION YOLA",
    .before = 13035
  ) %>%
  add_row(
    Id = "Table1150",
    Name = "Table1150 (Page 1371-1372)",
    Kind = "Table",
    Data.Column1 = "517021005",
    Data.Column2 = "OBAFEMI AWOLOWO UNIVERSITY",
    .before = 13644
  ) %>%
  add_row(
    Id = "Table1170",
    Name = "Table1170 (Page 1395-1396)",
    Kind = "Table",
    Data.Column1 = "517021022",
    Data.Column2 = "NNAMDI AZIKIWE UNIVERSITY, AWKA",
    .before = 14569
  ) %>%
  add_row(
    Id = "Table1200",
    Name = "Table1200 (Page 1435)",
    Kind = "Table",
    Data.Column1 = "517024001",
    Data.Column2 = "NATIONAL OPEN UNIVERSITY",
    .before = 16181
  ) %>%
  add_row(
    Id = "Table1180",
    Name = "Table1180 (Page 1405-1406)",
    Kind = "Table",
    Data.Column1 = "517021028",
    Data.Column2 = "NATIONAL INSTITUE FOR NIGERIAN LANGUAGES",
    .before = 	14985
  ) %>%
  add_row(
    Id = "Table1210",
    Name = "Table1210 (Page 1453-1454)",
    Kind = "Table",
    Data.Column1 = "517026008",
    Data.Column2 = "FGC IJANIKIN",
    .before = 	16913
  ) %>%
  add_row(
    Id = "Table1220",
    Name = "Table1220 (Page 1471-1472)",
    Kind = "Table",
    Data.Column1 = "517026017",
    Data.Column2 = "FGC KEFFI",
    .before = 	17685
  ) %>%
  add_row(
    Id = "Table1230",
    Name = "Table1230 (Page 1490-1491)",
    Kind = "Table",
    Data.Column1 = "517026026",
    Data.Column2 = "FGC OGOJA",
    .before = 	18480
  ) %>%
  add_row(
    Id = "Table1240",
    Name = "Table1240 (Page 1513-1514)",
    Kind = "Table",
    Data.Column1 = "517026036",
    Data.Column2 = "FGC WARRI",
    .before = 	19440
  ) %>%
  add_row(
    Id = "Table1250",
    Name = "Table1250 (Page 1529-1530)",
    Kind = "Table",
    Data.Column1 = "517026043",
    Data.Column2 = "FGGC AKURE",
    .before = 	20067
  ) %>%
  add_row(
    Id = "Table1260",
    Name = "Table1260 (Page 1547-1548)",
    Kind = "Table",
    Data.Column1 = "517026052",
    Data.Column2 = "FGGC EFON ALAYE",
    .before = 	20873
  ) %>%
  add_row(
    Id = "Table1270",
    Name = "Table1270 (Page 1565-1566)",
    Kind = "Table",
    Data.Column1 = "517026061",
    Data.Column2 = "FGGC IKOT-OBIO-ITONG",
    .before = 	21716
  ) %>%
  add_row(
    Id = "Table1280",
    Name = "Table1280 (Page 1584-1585)",
    Kind = "Table",
    Data.Column1 = "517026070",
    Data.Column2 = "FGGC MONGUNO",
    .before = 	22535
  ) %>%
  add_row(
    Id = "Table1290",
    Name = "Table1290 (Page 1602-1603)",
    Kind = "Table",
    Data.Column1 = "517026079",
    Data.Column2 = "FGGC YOLA",
    .before = 	23288
  ) %>%
  add_row(
    Id = "Table1300",
    Name = "Table1300 (Page 1624-1626)",
    Kind = "Table",
    Data.Column1 = "517026089",
    Data.Column2 = "FGGC KAFANCHAN",
    .before = 	24166
  ) %>%
  add_row(
    Id = "Table1310",
    Name = "Table1310 (Page 1646-1647)",
    Kind = "Table",
    Data.Column1 = "517026099",
    Data.Column2 = "FTC ZURU",
    .before = 	25078
  ) %>%
  add_row(
    Id = "Table1320",
    Name = "Table1320 (Page 1662-1663)",
    Kind = "Table",
    Data.Column1 = "517029001",
    Data.Column2 = "NATIONAL BOARD FOR TECHNICAL EDUCATION",
    .before = 	25787
  ) %>%
  add_row(
    Id = "Table1260",
    Name = "Table1260 (Page 1547-1548)",
    Kind = "Table",
    Data.Column1 = "517026052",
    Data.Column2 = "FGGC EFON ALAYE",
    .before = 	20872
  ) %>%
  add_row(
    Id = "Table1130",
    Name = "Table1130 (Page 1339)",
    Kind = "Table",
    Data.Column1 = "517019009",
    Data.Column2 = "FEDERAL COLLEGE OF EDUCATION KOTANGORA",
    .before = 	12366
  ) %>%
  add_row(
    Id = "Table1161",
    Name = "Table1161 (Page 1383-1384)",
    Kind = "Table",
    Data.Column1 = "517021014",
    Data.Column2 = "UNIVERSITY OF PORT HARCOURT",
    .before = 	14097
  ) %>%
  # mutate ------------------------------------------------------------------


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
    !is.na(table_identifier),
    Data.Column2,
    case_when(subCostCenterSum_Code == table_identifier ~ Data.Column3)
    # subCostCenterSum_Code == table_identifier,
    # Data.Column3,
    #case_when(!is.na(table_identifier) ~ Data.Column2)
  )
) %>%
  # we then fill the sucessive rows downwards
  fill(table_identifier, table_identifier_MDA) %>%
  mutate(
    # Code will be later renamed costCenter_Code
    Code = str_sub(table_identifier, end = 4),
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
  left_join(MDA_Table) %>%
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

# save local copy
write_csv(data_pbi_2018,
          "Data/finished_sets/csv_/budget_2018.csv")


# convert column names to readable forms
budget_2018_public <- data_pbi_2018 %>%
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
write_csv(budget_2018_public, "Budget_Data/budget_2018.csv")


# TODO write a formula to obtain sumarries by MDA and MDA subgroup

write_csv(data_pbi_2018, "Data/finished_sets/csv_/budget_2018.csv")
#write_csv(data_pbi_2018, "Data/semi_finished/budget_2018.csv")

# checks ------------------------------------------------------------------


check_data_pbi_2018 <- data_pbi_2018 %>%
  group_by(costCenter_Code, costCenter_Code_MDA, lineExpTermLevel1) %>%
  summarise(totalAllocation = sum(Amount)) %>%
  pivot_wider(names_from = lineExpTermLevel1, values_from = totalAllocation) %>%
  replace(is.na(.), 0) %>%
  #summarise_all(funs(sum))
  mutate(`TOTAL ALLOCATION` = format((`CAPITAL EXPENDITURE` + `OTHER RECURRENT COSTS` + `PERSONNEL COST`),
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
