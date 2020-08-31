
# functions ---------------------------------------------------------------


combine_data <- function(a,b,...) {
  rbind(a,b,...)
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
all_year <- combine_data(data_pbi_2018, data_pbi_2019_start_2, data_pbi_2020_start) 

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
write_csv(all_year, 'Data/sql_/all_year.csv')
write_csv(MDA_lookup, 'Data/sql_/MDA_lookup.csv')
write_csv(sub_MDA_lookup, 'Data/sql_/sub_MDA_lookup.csv')
