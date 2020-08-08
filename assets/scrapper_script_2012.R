library(tidyverse)
library(rvest)
library(rebus)
library(stringr)
library(lubridate)
library(xml2)

years <- c(2012:2015)

url <- "https://www.budgetoffice.gov.ng/index.php/2012-budget"


get_last_page  <- function(html) {
  pages_data <- html %>%
    # The '.' indicates the class
    # Using the :nth-child(n+3) like this allows you pick :nth-child(3) and above
    # Using the :nth-child(-n+5) like this allows you pick :nth-child(5) and below
    # Using this nth-child(n+3):nth-child(-n+5) we can select elements within certain ranges, in this case elements 3-5.
    # see: http://nthmaster.com/
    html_nodes('.pagination li:nth-child(n+3):nth-child(-n+5)') %>% 
    # Extract the raw text as a list
    html_text()
  
  # The second to last of the buttons is the one
  pages_data[(length(pages_data))] %>%            
    # Take the raw string
    unname() %>%                                     
    # Convert to number
    as.numeric()   
  
  
}
#ratingWidget > span > span

#edocman_form > div.pagination > ul > li:nth-child(3)
first_page <- read_html(url)

(latest_page_number <- get_last_page(first_page))




###pdf####
pdfurls <- c("https://www.budgetoffice.gov.ng/index.php/2012-budget/presidency/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/office-of-the-secretary-to-the-government-of-the-federation/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/office-of-the-national-security-adviser/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/office-of-the-head-of-civil-service-of-the-federation/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/national-salaries-income-and-wages-commission/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/national-planning-commission/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/independent-corrupt-practices-and-other-related-offences-commission/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/fiscal-responsibility-commission/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-works/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-transport/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-trade-and-investment/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-sports/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-science-tech/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-science-tech/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-power/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-petroleum/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-niger-delta/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-mines-steel/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-labour/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-justice/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-interior/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-information/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-health/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-foreign-affairs/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-finance/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-education/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-culture/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-commnication-technology/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-aviation/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-youth-sport/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-special-duties/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-police-affairs/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-land-and-housing/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-ministry-of-defence/download",
             "https://www.budgetoffice.gov.ng/index.php/2012-budget/federal-capital-territory-administration/download"
)
# n####
destination <- str_c("other_Years/2012/", 1:length(pdfurls), "manual.pdf")


for (i in seq_along(pdfurls)) {
  download.file(pdfurls[i], destfile = destination[i], mode = "wb")
}



