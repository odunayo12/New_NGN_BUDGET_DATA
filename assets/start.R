library(pdftools)
library(tidyverse)


#extract table of content
ectractTOC <- extract_areas('PDF_Data/2018_Executive_Proposal.pdf',pages = 1917:1918)

#selects the first 3 columns and all rows of the 2 vectors and returns a dataframe for each
ectractTOC[[1]] <- data.frame(ectractTOC[[1]], stringsAsFactors = FALSE)
ectractTOC[[2]] <- data.frame(ectractTOC[[2]], stringsAsFactors = FALSE)

# Label the columns
names(ectractTOC[[1]] ) <- c('costCenter', 'Page')
names(ectractTOC[[2]] ) <- c('costCenter', 'Page')

# combine both dataframes into 1
tableOfContentPrelim <- data.frame(rbind(ectractTOC[[1]], ectractTOC[[2]]))

tableOfContent <- tableOfContentPrelim %>%
  slice(3:n()) %>%
  mutate("No" = 1:n()) %>%
  left_join(MDA_Table, by = "No") %>%
  select(No, Code, costCenter, Page) %>%
  mutate(Brew = case_when(No > 20 ~ "Yes",
                          No > 15 ~ "Wait",
                          No > 10 ~ "Yes"))


# save as csv
write_csv(tableOfContent, 'Data/tableOfContent.csv')


# tableOfContent <- tableOfContent %>% 
  #select(everything()) %>% 

# #extract needed data from relevant pages
# ectractMDAs <- extract_areas('PDF_Data/2018_Executive_Proposal.pdf',pages = 1:2)
# ectractMDAsxx <- extract_areas('PDF_Data/2018_Executive_Proposal.pdf',pages = 1:2)
# 
# ectractMDAsxx1 <- ectractMDAsxx[[1]]
# #selects the first 3 columns and all rows of the 2 vectors and returns a dataframe for each
# ectractMDAs[[1]]<- data.frame(ectractMDAs[[1]][,1:3], stringsAsFactors = FALSE)
# ectractMDAs[[2]]<- data.frame(ectractMDAs[[2]][,1:3], stringsAsFactors = FALSE)
# 
# # Label the columns
# names(ectractMDAs[[1]] ) <- c('No', 'Code', 'MDA')
# names(ectractMDAs[[2]] ) <- c('No', 'Code', 'MDA')
# ectractMDAsXXXx <- ectractMDAs[[1]]
# # combine both dataframes into 1
# tableOfMDAs <- data.frame(rbind(ectractMDAs[[1]], ectractMDAs[[2]]))
# 
# # save as csv
# write_csv(tableOfMDAs, 'Data/tableOfMDAs.csv')
# TO_DO: Merge tableOfContent with MDA_Table.csv