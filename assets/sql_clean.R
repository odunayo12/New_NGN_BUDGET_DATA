

# functions ---------------------------------------------------------------


combine_data <- function(a, b, ...) {
  rbind(a, b, ...)
}


years_summary_by_MDAs <- function(requiredData) {
  summary_data <-
    requiredData %>%  group_by(costCenter_Code, costCenter_Code_MDA, lineExpTermLevel1) %>%
    summarise(totalAllocation = sum(Amount)) %>%
    pivot_wider(names_from = lineExpTermLevel1, values_from = totalAllocation) %>%
    replace(is.na(.), 0) %>%
    mutate(`TOTAL ALLOCATION` = format((
      `CAPITAL EXPENDITURE` + `OTHER RECURRENT COSTS` + `PERSONNEL COST`
    ),
    big.mark = ",",
    nsmall = 1
    ))
  return(summary_data)
}

sql_clean_data <- function(a_data, b_distinct, ...) {
  a <-  a_data %>% distinct(b_distinct, .keep_all = T) #%>%
  #select(b_distinct, c_row_select, d_row_select, e_row_select)
  ##, c_row_select, d_row_select, e_row_select
  return(a)
}
#test------------------------------
all_year <-
  combine_data(data_pbi_2018, data_pbi_2019_start_2, data_pbi_2020_start)

year_2018_summary <- years_summary_by_MDAs(data_pbi_2019_start_2)

sql_clean_data(all_year, costCenter_Code)

# cleaning for sql --------------------------------------------------------

MDA_lookup <- all_year %>%
  distinct(costCenter_Code, .keep_all = T) %>%
  select(costCenter_Code, costCenter_Code_MDA) %>%
  arrange(costCenter_Code) %>%
  view()


sub_MDA_lookup <- all_year %>%
  distinct(table_identifier, .keep_all = T) %>%
  select(costCenter_Code, table_identifier, table_identifier_MDA) %>%
  arrange(costCenter_Code) %>%
  view()

lineExpLevel1 <- all_year %>%
  distinct(lineExpCodeLevel1, .keep_all = T) %>%
  select(lineExpCodeLevel1, lineExpTermLevel1) %>%
  rename(expd_id = lineExpCodeLevel1, expd_term = lineExpTermLevel1) %>%
  view()

lineExpLevel2 <- all_year %>%
  distinct(lineExpCodeLevel2, .keep_all = T) %>%
  select(lineExpCodeLevel2, lineExpTermLevel2) %>%
  rename(expd_id = lineExpCodeLevel2, expd_term = lineExpTermLevel2) #%>%
view()

# lineExpLevel2_test <- all_year %>%
#   distinct(lineExpTermLevel2, .keep_all = T) %>%
#   select(lineExpCodeLevel2, lineExpTermLevel2) %>%
#   view()


lineExpLevel3 <- all_year %>%
  distinct(lineExpCodeLevel3, .keep_all = T) %>%
  select(lineExpCodeLevel3, lineExpTermLevel3) %>%
  rename(expd_id = lineExpCodeLevel3, expd_term = lineExpTermLevel3) #%>%
view()

lineExpLevel4 <- all_year %>%
  distinct(lineExpCodeLevel4, .keep_all = T) %>%
  select(lineExpCodeLevel4, lineExpTermLevel4) %>%
  rename(expd_id = lineExpCodeLevel4, expd_term = lineExpTermLevel4) #%>%
view()

codes_n_meaning_table <-
  combine_data(lineExpLevel1, lineExpLevel2, lineExpLevel3, lineExpLevel4) %>%
  add_row(expd_id = '2', expd_term = "EXPENDITURE", .before = 1)

all_year_sql <- all_year %>% 
  select(!contains('Term'), -table_identifier_MDA, lineExpTerm, lineExpTermLevel1)%>%
  view()
#### Filter for MDAs -------------------------------------
MDA_distr_by_year <- 
  all_year %>% filter(
    !is.na(Amount)
  ) %>% 
  group_by(Year, costCenter_Code, costCenter_Code_MDA, table_identifier, table_identifier_MDA) %>% 
  summarise(total_allocation = sum(Amount)) %>%view()

write_csv(MDA_distr_by_year, "Budget_Data/summary/mda_by_year.csv")
#save-----------------------------------------------------------------------
write_csv(all_year, 'Data/sql_/all_year.csv')
write_csv(MDA_lookup, 'Data/sql_/MDA_lookup.csv')
write_csv(sub_MDA_lookup, 'Data/sql_/sub_MDA_lookup.csv')
write_csv(all_year_sql, 'Data/sql_/all_year_sql.csv')
write_csv(codes_n_meaning_table, 'Data/sql_/codes_n_meaning_table.csv')
write_csv(check_data_pbi_2018, "Budget_Data/summary/2018_summary_by_MDA.csv")
write_csv(check_data_pbi_2019_start_2, "Budget_Data/summary/2019_summary_by_MDA.csv")
write_csv(check_data_pbi_2020, "Budget_Data/summary/2020_summary_by_MDA.csv")