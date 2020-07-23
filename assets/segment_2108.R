#to format: First CTRL+A, then CTRL+SHIFT+A.
#pipe: Ctrl+shift+m
#comment: Ctrl+shift+c
library(tidyverse)
library(rtools)
#list_of_MDA_Codes <- tableOfContent$Code

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

#in what follows we separate by page in the name column to extract the last page numbers at the end of the Name column

data_pbi_2018 <-
  data_pbi %>% 
  arrange(Id, Data.Column1) %>%
  mutate(subCostCenterSum_Code = case_when(
    #dectects any figure from 0-9 in a column
    str_detect(Data.Column2, "[0-9]") &
      str_length(Data.Column2) == 9 ~ paste0('0', Data.Column2)
  ),
  #the following detects the apperance of "ERGP" strictly () once {1}
  projectCode = case_when(str_detect(Data.Column1, "^ERGP{1}") ~ Data.Column1),
  expenditureCods = case_when(
    #detects "^2" from the beginning of the column content
    str_detect(Data.Column1, "^2") &
      #[A-Z] because the desired colum have text in the next column
      str_detect(Data.Column2, "[A-Z]") ~ Data.Column1),
  #here we choose to identify relevant tables by their starting codes which in most cases only have two columns thus the sucessuive columns will be empty
  table_identifier = case_when(str_detect(Data.Column1, "^[0-9]") & is.na(Data.Column3) & is.na(Data.Column4) & is.na(Data.Column5)  ~ paste0('0', Data.Column1)),
  table_identifier_MDA = case_when(!is.na(table_identifier) ~ Data.Column2)
  ) %>%
  # we then fill the sucessive rows downwards
  fill(table_identifier, table_identifier_MDA) %>% 
  mutate( costCenter_Code = str_sub(table_identifier, end = 4),
          lineExpCode = case_when(Data.Column1 == "2" & str_detect(Data.Column2, "(EXP){1}") ~ Data.Column1),
          lineExpTerm = case_when(!is.na(lineExpCode) ~ Data.Column2), 
          lineExpCodeLevel1 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 2 & str_length(Data.Column2) > 5~ Data.Column1),
          lineExpTermLevel1 = case_when(!is.na(lineExpCodeLevel1) ~ Data.Column2), 
          lineExpCodeLevel2 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 4 ~ Data.Column1),
          lineExpTermLevel2 = case_when(!is.na(lineExpCodeLevel2) ~ Data.Column2),
          lineExpCodeLevel3 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 6 ~ Data.Column1),
          lineExpTermLevel3 = case_when(!is.na(lineExpCodeLevel3) ~ Data.Column2),
          lineExpCodeLevel4 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 8 ~ Data.Column1),
          lineExpTermLevel4 = case_when(!is.na(lineExpCodeLevel4) ~ Data.Column2),
          Year = 2018
  ) %>% 
  #arrange(Id, Data.Column1) %>% 
  fill(lineExpCode, lineExpTerm, lineExpCodeLevel1, lineExpTermLevel1, lineExpTermLevel2, lineExpCodeLevel2, lineExpTermLevel3, lineExpCodeLevel3) %>% 
  select(-Name, -Kind)

write_csv(data_pbi_2018, "Data/semi_finished/budget_2018.csv")
#   separate(Name, c("Name.NN", "Name.needed"), "Page ") %>%
#   select(-Name.NN, -Kind) %>%
#   #separate by "([ -])"
#   separate(
#     Name.needed,
#     c("Name.needed.1", "Name.needed.2"),
#     sep = "([ -])" ,
#     extra = "drop",
#     fill = "right"
#   ) %>%
#   #update values not captured by the previous line
#   mutate(Name.needed.2 = (if_else(
#     is.na(Name.needed.2), Name.needed.1, Name.needed.2
#   ))) %>%
#   #rename colum
#   rename(Page = Name.needed.2) %>%
#   #delete the trailing ")" at the end if the Page variable or column
#   mutate(Page = as.numeric(gsub(")", "", Page))) %>%
#   #delete a column
#   select(-Name.needed.1) %>%
#   ########mind the order, reversed (in desc. order) when the sign is ">"############
# mutate(
#   costCenter_Code = case_when(
#     Page < 36 ~ '0111',
#     Page < 38 ~ '0112',
#     Page < 81 ~ '0116',
#     Page < 317 ~ '0119',
#     Page < 367 ~ '0123',
#     Page < 391 ~ '0124',
#     Page < 418 ~ '0125',
#     Page < 422 ~ '0140',
#     Page < 424 ~ '0145',
#     Page < 427 ~ '0147',
#     Page < 429 ~ '0148',
#     Page < 433 ~ '0149',
#     Page < 441 ~ '0156',
#     Page < 453 ~ '0157',
#     Page < 457 ~ '0158',
#     Page < 459 ~ '0159',
#     Page < 462 ~ '0160',
#     Page < 514 ~ '0161',
#     Page < 614 ~ '0215',
#     Page < 672 ~ '0220',
#     Page < 705 ~ '0222',
#     Page < 723 ~ '0227',
#     Page < 950 ~ '0228',
#     Page < 978 ~ '0229',
#     Page < 1035 ~ '0231',
#     Page < 1048 ~ '0232',
#     Page < 1074 ~ '0233',
#     Page < 1091 ~ '0238',
#     Page < 1094 ~ '0242',
#     Page < 1097 ~ '0246',
#     Page < 1101 ~ '0250',
#     Page < 1164 ~ '0252',
#     Page < 1166 ~ '0318',
#     Page < 1187 ~ '0326',
#     Page < 1191 ~ '0341',
#     Page < 1194 ~ '0344',
#     Page < 1197 ~ '0437',
#     Page < 1208 ~ '0451',
#     Page < 1221 ~ '0513',
#     Page < 1228 ~ '0514',
#     Page < 1666 ~ '0517',
#     Page < 1870 ~ '0521',
#     Page < 1913 ~ '0535',
#     Page >= 1913 ~ '0543'
# 
#   )
# ) %>% 
# arrange(Id, Data.Column1) %>%
#   mutate(subCostCenterSum_Code = case_when(
#     #dectects any figure from 0-9 in a column
#     str_detect(Data.Column2, "[0-9]") &
#       str_length(Data.Column2) == 9 ~ paste0('0', Data.Column2)
#   )) %>%
#   #the following detects the apperance of "ERGP" strictly () once {1}
#   mutate(projectCode = case_when(str_detect(Data.Column1, "(ERGP){1}") ~ Data.Column1)) %>%
#   mutate(expenditureCods = case_when(
#     #detects "^2" from the beginning of the column content
#     str_detect(Data.Column1, "^2") &
#       #[A-Z] because the desired colum have text in the next column
#       str_detect(Data.Column2, "[A-Z]") ~ Data.Column1
#   )) %>% 
#   #here we choose to identify relevant tables by their starting codes which in most cases only have two columns thus the sucessuive columns will be empty
#   mutate(table_identifier = case_when(str_detect(Data.Column1, "^[0-9]") & is.na(Data.Column3) & is.na(Data.Column4) & is.na(Data.Column5)  ~ paste0('0', Data.Column1))) %>% 
#   # we then fill the sucessive rows downwards
#   fill(table_identifier) %>% 
#   mutate(lineExpCode = case_when(Data.Column1 == "2" & str_detect(Data.Column2, "(EXP){1}") ~ Data.Column1),
#          lineExpTerm = case_when(!is.na(lineExpCode) ~ Data.Column2), 
#          lineExpCodeLevel1 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 2 & str_length(Data.Column2) > 5~ Data.Column1),
#          lineExpTermLevel1 = case_when(!is.na(lineExpCodeLevel1) ~ Data.Column2), 
#          lineExpCodeLevel2 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 4 ~ Data.Column1),
#          lineExpTermLevel2 = case_when(!is.na(lineExpCodeLevel2) ~ Data.Column2),
#          lineExpCodeLevel3 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 6 ~ Data.Column1),
#          lineExpTermLevel3 = case_when(!is.na(lineExpCodeLevel3) ~ Data.Column2),
#          lineExpCodeLevel4 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 8 ~ Data.Column1),
#          lineExpTermLevel4 = case_when(!is.na(lineExpCodeLevel4) ~ Data.Column2),
#          Year = 2018
#   ) %>% 
#   #arrange(Id, Data.Column1) %>% 
#   fill(lineExpCode, lineExpTerm, lineExpCodeLevel1, lineExpTermLevel1, lineExpTermLevel2, lineExpCodeLevel2, lineExpTermLevel3, lineExpCodeLevel3)
# 
# #write_csv(data_pbi_2108, "Data/semi_finished/budget_2018.csv")
# 
# # # Segment data into sizable chuncks##########
# # # See for reges http://www.endmemo.com/r/gsub.php
# # presidency <- data_pbi %>%
# #   filter(Page < 36) %>%
# #   arrange(Id, Data.Column1) %>%
# #   mutate(subCostCenterSum_Code = case_when(
# #     #dectects any figure from 0-9 in a column
# #     str_detect(Data.Column2, "[0-9]") &
# #       str_length(Data.Column2) == 9 ~ paste0('0', Data.Column2)
# #   )) %>%
# #   #the following detects the apperance of "ERGP" strictly () once {1}
# #   mutate(projectCode = case_when(str_detect(Data.Column1, "(ERGP){1}") ~ Data.Column1)) %>%
# #   mutate(expenditureCods = case_when(
# #     #detects "^2" from the beginning of the column content
# #     str_detect(Data.Column1, "^2") &
# #       #[A-Z] because the desired colum have text in the next column
# #       str_detect(Data.Column2, "[A-Z]") ~ Data.Column1
# #   )) %>% 
# #   #here we choose to identify relevant tables by their starting codes which in most cases only have two columns thus the sucessuive columns will be empty
# #   mutate(table_identifier = case_when(str_detect(Data.Column1, "^[0-9]") & is.na(Data.Column3) & is.na(Data.Column4) & is.na(Data.Column5)  ~ paste0('0', Data.Column1))) %>% 
# #   # we then fill the sucessive rows downwards
# #   fill(table_identifier) %>% 
# #   mutate(lineExpCode = case_when(Data.Column1 == "2" & str_detect(Data.Column2, "(EXP){1}") ~ Data.Column1),
# #          lineExpTerm = case_when(!is.na(lineExpCode) ~ Data.Column2), 
# #          lineExpCodeLevel1 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 2 & str_length(Data.Column2) > 5 ~ Data.Column1),
# #          lineExpTermLevel1 = case_when(!is.na(lineExpCodeLevel1) ~ Data.Column2), 
# #          lineExpCodeLevel2 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 4 ~ Data.Column1),
# #          lineExpTermLevel2 = case_when(!is.na(lineExpCodeLevel2) ~ Data.Column2),
# #          lineExpCodeLevel3 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 6 ~ Data.Column1),
# #          lineExpTermLevel3 = case_when(!is.na(lineExpCodeLevel3) ~ Data.Column2),
# #          lineExpCodeLevel4 = case_when(str_detect(Data.Column1, "21|22|23|24") & str_length(Data.Column1) == 8 ~ Data.Column1),
# #          lineExpTermLevel4 = case_when(!is.na(lineExpCodeLevel4) ~ Data.Column2)
# #          ) %>% 
# #   #arrange(Id, Data.Column1) %>% 
# #   fill(lineExpCode, lineExpTerm, lineExpCodeLevel1, lineExpTermLevel1, lineExpTermLevel2, lineExpCodeLevel2, lineExpTermLevel3, lineExpCodeLevel3)
# #  
# 
# 
# 
# # https://stackoverflow.com/a/46320477/13119339 #####
# # ^        >> from the beginning of the string...
# # .*       >> every character till...
# # dollars  >> the substring 'dollars'...
# # .*?      >> and than any character until the first...
# # ([0-9]+) >> number of any length, that is selected as group...
# # .*       >> and then everything else
# # check
# # length(which(presidency$subCostCenter_Code != "NA"))