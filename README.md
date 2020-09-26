# New_NGN_BUDGET_DATA
This repo consists of Nigerian Budget Data for data accessible period.

## Motivation
I once needed a transparent budget data of Nigeria and found none but some summaries on the internet and pdf files on [Nigerian Budget Office's website](https://www.budgetoffice.gov.ng/index.php/resources/internal-resources/budget-documents). Thus, I decided to covert this pdf's to data with the following aims in view:
1. To serve the information and decision-making needs of people.
2. To provide a locally accessible data for data-analyst enthusiasts.

## Files and Folders
```
📂Data/
┣📂 finished_sets/
┃ ┣📂 csv_/
┃ ┃ ┣ 🧾budget_2018.csv  --------- 2018 Fiscal Budget
┃ ┃ ┣ 🧾budget_2019.csv  --------- 2019 Fiscal Budget
┃ ┃ ┣ 🧾budget_2020.csv  --------- 2020 Fiscal Budget
┃ ┃ ┣ 🧾data_pbi_2020_start.csv
┃ ┃ ┣ 🧾data_pbi_2020_start_2.csv
┃ ┃ ┣ 🧾projects_18_19_20.csv
┃ ┃ ┣ 🧾summary_by_MDA_18_19_20.csv
┃ ┃ ┗🧾 summary_by_sub_MDA_18_19_20.csv

```

<br>

## Factory Name Setting 😉

| Processed names             | Raw  Names           |
| --------------------------- | -------------------- |
| MDA Code                    | table_identifier     |
| MDA Name                    | table_identifier_MDA |
| Main MDA Code               | costCenter_Code      |
| Main MDA Name               | costCenter_Code_MDA  |
| Expenditure Code            | lineExpCode          |
| Expenditure                 | lineExpTerm          |
| Fund Code                   | lineExpCodeLevel1    |
| Fund                        | lineExpTermLevel1    |
| Line Expense Code           | lineExpCodeLevel2    |
| Line Expense                | lineExpTermLevel2    |
| Line Expense Sub-group Code | lineExpCodeLevel3    |
| Line Expense Sub-group      | lineExpTermLevel3    |
| Main Cost Code              | lineExpCodeLevel4    |
| Main Cost Item              | lineExpTermLevel4    |


<br>

## To follow:
1. - [ ] Data in MySql format
2. - [ ] Detailed Exploratory Analytics and Visualization through blogposts