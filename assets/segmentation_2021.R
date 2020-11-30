library(tidyverse)
library(reticulate)
library(collapsibleTree)
options(dplyr.summarise.inform = FALSE)
use_python("C:/Users/rotim/anaconda3", required = T)
repl_python()

#reticulate::py_config()

use_condaenv()
raw_2021_budget_2021 <-
  read_csv(
    "PDF_Data/raw_2021_budget_2021.csv",
    cols(
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
      Data.Column8 = col_character(),
      Data.Column9 = col_character(),
      Data.Column10 = col_character()
    )
  )
View(raw_2021_budget_2021)

# Cleaning ----------------------------------------------------------------
head(raw_2021_budget_2021)
data_col_names = c(colnames(raw_2021_budget_2021))
raw_2021_budget_2021 %>% group_by(null_col = sum(is.na((Data.Column3))), sum(is.na((Data.Column2))), sum(is.na((Id)))) %>% summarise()

for (col_name in data_col_names) {
  print (col_name)
  mutate (raw_2021_budget_2021 %>% group_by(sum(is.na(col_name))) %>% summarise())
}


for (var in names(raw_2021_budget_2021)) {
  raw_2021_budget_2021 %>% count(is.na(.data[[var]])) %>% print()
}


# Strategy: the data contains
# Lest make a copy of the original data
data__2021_start <- raw_2021_budget_2021

# We inspect our to see the each colum to see how many empty rows they contain. In what follows, `map_dl()` map the datafrme `data__2021_start` in to a vector using an anonymous function
# that calculates the percentage of empty record contain in each column. `length()` returns the size of what (`what`) empty (`is.na()`) rows(`(.)`) are contained in each column; mutiplies it by 100 and rounds (`round()`) it to the nearest whole number.

data__2021_start %>% map_dbl(function(x)
  round(100 * length(which(is.na(
    x
  ))) / length(x)))
# -----------------------------------------------
# When extracting the tables form Excel, the `Id`, `Name` and `Kind` Columns were automatically created to be used for identifying the table in the pdf that was converted to excel. That affors us an advatage. Since the Id column is serial, we can use it to sort (`arrange()`) our table in such a way that it matchess the order of tables in the original document. And to double check, we also add the column `Data.Column1` to the sort criteria
data__2021_start %>%
  arrange(Id, Data.Column1) %>%
  
  data.frame("Column Names" = row.names(t(stmbbyby)),
             t(stmbbyby),
             row.names = NULL)
glimpse(supmed)

my_summarise4 <- function(data, expr) {
  data %>% summarise(#"mean_{{expr}}" := mean({{ expr }}),
    #"sum_{{expr}}" := sum({{ expr }}),
    "n_{{expr}}" := sum(is.na({
      {
        expr
      }
    })))
}

test__1 = my_summarise4(raw_2021_budget_2021, data_col_names)


for (var in names(raw_2021_budget_2021)) {
  raw_2021_budget_2021 %>% sum(is.na(.data[[var]])) %>% print()
}

# https://dplyr.tidyverse.org/articles/programming.html
my_summarise <- function(.data, ...) {
  .data %>%
    group_by(...) %>%
    summarise(null_col = sum(mass),
              height = mean(height, na.rm = TRUE))
}

map_dbl(raw_2021_budget_2021, ~ length(which(is.na(.x))))
#  Table of MDAs 2020 ----------------------------------------------------

MDA_Table_2021 <- data__2021_start %>%
  select(Data.Column2, Data.Column3) %>%
  filter(str_length(Data.Column2) == 4 &
           str_detect(Data.Column2, "^0")) %>%
  rename(Code = Data.Column2, MDA = Data.Column3) %>%
  arrange(Code) %>%
  mutate(No = 1:n()) %>% view()



# Cleaning ----------------------------------------------
#
data__2021_test <- data__2021_start %>%
  select(-(Id:Kind), -(Data.Column4:Data.Column10)) %>%
  mutate(
    Data.Column1 = if_else(str_detect(Data.Column2, "TOTAL RETAINED"), "07", Data.Column1),
    table_identifier = case_when(
      #dectects any figure from 0-9 in a column
      str_detect(Data.Column1, "^[0-9]") &
        str_length(Data.Column1) == 10
      ~  Data.Column1
    ),
    table_identifier_MDA = case_when(!is.na(table_identifier) ~ Data.Column2)
  ) %>% fill(table_identifier, table_identifier_MDA) %>%
  mutate(
    Code = str_sub(table_identifier, end = 4),
    lineExpCode = case_when(
      Data.Column1 == "2" &
        str_detect(Data.Column2, "^EXP{1}") |
        Data.Column1 == "07" &
        str_detect(Data.Column2, "TOTAL RETAINED") ~ Data.Column1
    ),
    lineExpTerm = case_when(
      !is.na(lineExpCode) ~ Data.Column2,
      Data.Column1 == "07" ~ Data.Column2
    ),
    lineExpCodeLevel1 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 2 &
        str_length(Data.Column2) > 5 ~ Data.Column1,
      Data.Column1 == "07" ~ Data.Column1
    ),
    lineExpTermLevel1 = case_when(
      !is.na(lineExpCodeLevel1) ~ Data.Column2,
      Data.Column1 == "07" ~ Data.Column2
    ),
    lineExpCodeLevel2 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 4 ~ Data.Column1,
      Data.Column1 == "07" ~ Data.Column1
    ),
    lineExpTermLevel2 = case_when(
      !is.na(lineExpCodeLevel2) ~ Data.Column2,
      Data.Column1 == "07" ~ Data.Column2
    ),
    lineExpCodeLevel3 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 6 ~ Data.Column1,
      Data.Column1 == "07" ~ Data.Column1
    ),
    lineExpTermLevel3 = case_when(
      !is.na(lineExpCodeLevel3) ~ Data.Column2,
      Data.Column1 == "07" ~ Data.Column2
    ),
    lineExpCodeLevel4 = case_when(
      str_detect(Data.Column1, "21|22|23|24") &
        str_length(Data.Column1) == 8 ~ Data.Column1,
      Data.Column1 == "07" ~ Data.Column1
    ),
    lineExpTermLevel4 = case_when(
      !is.na(lineExpCodeLevel4) ~ Data.Column2,
      Data.Column1 == "07" ~ Data.Column2
    ),
    Year = 2021
  )  %>%
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
  left_join(MDA_Table_2021) %>%
  rename(costCenter_Code = Code,
         costCenter_Code_MDA = MDA) %>%
  mutate(Amount = as.numeric(str_replace_all(Data.Column3, ",", ""))) %>%
  select(
    Year,
    costCenter_Code,
    costCenter_Code_MDA,
    table_identifier,
    table_identifier_MDA,
    (lineExpCode:Amount),
    -No
  ) %>%
  view()

# Check for anomaly-------------------
# TODO: create a column to track retained Earnings
anomally <- data__2021_test %>%
  select(table_identifier,
         table_identifier_MDA,
         lineExpTermLevel4,
         lineExpCode,
         Amount) %>%
  filter(str_detect(table_identifier, "^0517")) %>%
  group_by(table_identifier, table_identifier_MDA) %>%
  summarise(sum(Amount)) %>%
  view()

# check accuracy----------------------------
check_data__2021_test <- data__2021_test %>%
  group_by(costCenter_Code, costCenter_Code_MDA, lineExpTermLevel1) %>%
  summarise(totalAllocation = sum(Amount)) %>%
  pivot_wider(names_from = lineExpTermLevel1, values_from = totalAllocation) %>%
  replace(is.na(.), 0) %>%
  mutate(budgetTotal = format((
    `CAPITAL EXPENDITURE` + `OTHER RECURRENT COSTS` + `PERSONNEL COST` - `TOTAL RETAINED INDEPENDENT REVENUE`
  ),
  big.mark = ",",
  nsmall = 1
  )) %>%
  view()
# sample plot ----------------
colapse_pres_ <-
  data__2021_test %>% filter(costCenter_Code == "0111") %>%
  group_by(costCenter_Code_MDA,
           table_identifier_MDA,
           lineExpTermLevel1,
           lineExpTermLevel2)  %>% summarise(Amount = sum(Amount))

write_csv(data__2021_test,
          "Budget_Data/data__2021_test.csv")
