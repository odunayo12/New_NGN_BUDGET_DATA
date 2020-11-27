Cleaning Nigeria Budget Data
================

``` r
# for y in [1, 2, 3]:
#   print(y)
```

\#\#Read the data

``` r
library(tidyverse)
```

    ## -- Attaching packages -------------------------------------------------------------------------------------------------------------- tidyverse 1.3.0 --

    ## v ggplot2 3.3.2     v purrr   0.3.4
    ## v tibble  3.0.3     v dplyr   1.0.1
    ## v tidyr   1.1.1     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.5.0

    ## -- Conflicts ----------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(knitr)
raw_2021_budget_2021 <-
  read_csv(
    "PDF_Data/raw_2021_budget_2021.csv"
  )
```

    ## Parsed with column specification:
    ## cols(
    ##   Id = col_character(),
    ##   Name = col_character(),
    ##   Kind = col_character(),
    ##   Data.Column1 = col_character(),
    ##   Data.Column2 = col_character(),
    ##   Data.Column3 = col_character(),
    ##   Data.Column4 = col_character(),
    ##   Data.Column5 = col_character(),
    ##   Data.Column6 = col_character(),
    ##   Data.Column7 = col_character(),
    ##   Data.Column8 = col_character(),
    ##   Data.Column9 = col_character(),
    ##   Data.Column10 = col_character()
    ## )

``` r
raw_2021_budget_2021
```

    ## # A tibble: 76,584 x 13
    ##    Id    Name  Kind  Data.Column1 Data.Column2 Data.Column3 Data.Column4
    ##    <chr> <chr> <chr> <chr>        <chr>        <chr>        <chr>       
    ##  1 Tabl~ Tabl~ Table NO           CODE         "MDA"        PERSONNEL   
    ##  2 Tabl~ Tabl~ Table 1            0111         "PRESIDENCY" 34,389,345,~
    ##  3 Tabl~ Tabl~ Table 2            0112         "NATIONAL A~ 128,000,000~
    ##  4 Tabl~ Tabl~ Table 3            0116         "MINISTRY O~ 774,853,568~
    ##  5 Tabl~ Tabl~ Table 4            0119         "MINISTRY O~ 51,791,743,~
    ##  6 Tabl~ Tabl~ Table 5            0123         "FEDERAL MI~ 48,749,617,~
    ##  7 Tabl~ Tabl~ Table 6            0124         "MINISTRY O~ 200,808,195~
    ##  8 Tabl~ Tabl~ Table 7            0125         "OFFICE OF ~ 4,811,663,0~
    ##  9 Tabl~ Tabl~ Table <NA>         <NA>         "THE FEDERA~ <NA>        
    ## 10 Tabl~ Tabl~ Table 8            0140         "AUDITOR GE~ 2,436,674,3~
    ## # ... with 76,574 more rows, and 6 more variables: Data.Column5 <chr>,
    ## #   Data.Column6 <chr>, Data.Column7 <chr>, Data.Column8 <chr>,
    ## #   Data.Column9 <chr>, Data.Column10 <chr>

## Overiew

Let’s make a copy of the original data

``` r
data__2021_start <- raw_2021_budget_2021 
```

### Inspection

We inspect our to see the each colum to see how many empty rows they
contain. In what follows, `map_dl()` map the datafrme `data__2021_start`
in to a vector using an anonymous function that calculates the
percentage of empty record contain in each column. `length()` returns
the size of what (`which()`) empty (`is.na()`) rows(`(.)`) are contained
in each column; mutiplies it by 100 and rounds (`round()`) it to the
nearest whole number.

``` r
data__2021_start %>% map_dbl(function(x) round(100*length(which(is.na(x)))/length(x))) 
```

    ##            Id          Name          Kind  Data.Column1  Data.Column2 
    ##             0             0             0            11             1 
    ##  Data.Column3  Data.Column4  Data.Column5  Data.Column6  Data.Column7 
    ##             6            81            99            99            99 
    ##  Data.Column8  Data.Column9 Data.Column10 
    ##            99            99           100

This shows that bulk of the data is in `Data.Column1`, `Data.Column2`
and `Data.Column3` since they contain just 11%, 1% and 6% null rows
respectively.

When extracting the tables form Excel, the `Id`, `Name` and `Kind`
Columns were automatically created to be used for identifying the table
in the pdf that was converted to excel. That affors us an advatage.
Since the Id column is serial, we can use it to sort (`arrange()`) our
table in such a way that it matches the order of tables in the original
document. And to double check, we also add the column `Data.Column1` to
the sort criteria.

``` r
data__2021_start %>% arrange(Id, Data.Column1)
```

    ## # A tibble: 76,584 x 13
    ##    Id    Name  Kind  Data.Column1 Data.Column2 Data.Column3 Data.Column4
    ##    <chr> <chr> <chr> <chr>        <chr>        <chr>        <chr>       
    ##  1 Tabl~ Tabl~ Table 1            0111         "PRESIDENCY" 34,389,345,~
    ##  2 Tabl~ Tabl~ Table 1            021          "MAIN ENVEL~ <NA>        
    ##  3 Tabl~ Tabl~ Table 10           0147         "FEDERAL CI~ 744,546,830 
    ##  4 Tabl~ Tabl~ Table 11           0148         "INDEPENDEN~ 40,000,000,~
    ##  5 Tabl~ Tabl~ Table 12           0149         "FEDERAL CH~ 2,688,616,5~
    ##  6 Tabl~ Tabl~ Table 13           0155         "FEDERAL MI~ 420,604,423~
    ##  7 Tabl~ Tabl~ Table 14           0156         "FEDERAL MI~ 21,127,073,~
    ##  8 Tabl~ Tabl~ Table 15           0157         "NATIONAL S~ 112,446,153~
    ##  9 Tabl~ Tabl~ Table 16           0158         "CODE OF CO~ 548,758,100 
    ## 10 Tabl~ Tabl~ Table 17           0159         "INFRASTRUC~ 1,013,246,4~
    ## # ... with 76,574 more rows, and 6 more variables: Data.Column5 <chr>,
    ## #   Data.Column6 <chr>, Data.Column7 <chr>, Data.Column8 <chr>,
    ## #   Data.Column9 <chr>, Data.Column10 <chr>

The big question is how do we structure our data so that it can produce
the same figure, with 0% error tolerance? Let us explore the least units
of our data. By observation, the records are stored on hierachical
level; with 48 Ministries Department and Agencies (MDA’s). Under each
MDA, there are sub-MDA’S. The take-away, however is that for all sub
divisions their expenditure is made of 2 of these 3 cost elements,
namely, `CAPITAL EXPENDITURE`, `OTHER RECURRENT COSTS`,`PERSONNEL COST`.
We shall Explain the reason for the inclusion of `TOTAL RETAINED
INDEPENDENT REVENUE` later.

``` r
library(collapsibleTree)
```

    ## Warning: package 'collapsibleTree' was built under R version 4.0.3

``` r
data__2021_test =read_csv("Budget_Data/data__2021_test.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   Year = col_double(),
    ##   costCenter_Code = col_character(),
    ##   costCenter_Code_MDA = col_character(),
    ##   table_identifier = col_character(),
    ##   table_identifier_MDA = col_character(),
    ##   lineExpCode = col_character(),
    ##   lineExpTerm = col_character(),
    ##   lineExpCodeLevel1 = col_character(),
    ##   lineExpTermLevel1 = col_character(),
    ##   lineExpCodeLevel2 = col_character(),
    ##   lineExpTermLevel2 = col_character(),
    ##   lineExpCodeLevel3 = col_character(),
    ##   lineExpTermLevel3 = col_character(),
    ##   lineExpCodeLevel4 = col_character(),
    ##   lineExpTermLevel4 = col_character(),
    ##   Amount = col_double()
    ## )

``` r
data__2021_test <- data__2021_test %>% filter(costCenter_Code=="0111") %>% 
  group_by( costCenter_Code_MDA, table_identifier_MDA, lineExpTermLevel1, lineExpTermLevel2)  %>% 
  summarise(Amount=sum(Amount))
```

    ## `summarise()` regrouping output by 'costCenter_Code_MDA', 'table_identifier_MDA', 'lineExpTermLevel1' (override with `.groups` argument)

``` r
data__2021_test %>% collapsibleTree(c("costCenter_Code_MDA", "table_identifier_MDA", "lineExpTermLevel1"))
```

<!--html_preserve-->

<div id="htmlwidget-128701b2a0c26f3aa5c0" class="collapsibleTree html-widget" style="width:672px;height:480px;">

</div>

<script type="application/json" data-for="htmlwidget-128701b2a0c26f3aa5c0">{"x":{"data":{"name":".","children":[{"name":"PRESIDENCY","children":[{"name":"BUREAU OF PUBLIC ENTERPRISES (BPE)","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"BUREAU OF PUBLIC PROCUREMENT (BPP)","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"}]},{"name":"NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"NIGERIA EXTRACTIVE INDUSTRIES TRANSPARENCY INITIATIVE (NEITI)","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"NIGERIAN FINANCIAL INTELLIGENCE UNIT (NFIU)","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"NIPSS, KURU","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"OFFICE OF THE CHIEF ECONOMIC ADVISER TO THE PRESIDENT","children":[{"name":"OTHER RECURRENT COSTS"}]},{"name":"OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"OFFICE OF THE CHIEF SECURITY OFFICER TO THE PRESIDENT","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"STATE HOUSE - HQTRS","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"PERSONNEL COST"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"STATE HOUSE LAGOS LIAISON OFFICE","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"STATE HOUSE MEDICAL CENTRE","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"STATE HOUSE OPERATIONS - PRESIDENT","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]},{"name":"STATE HOUSE OPERATIONS - VICE PRESIDENT","children":[{"name":"CAPITAL EXPENDITURE"},{"name":"OTHER RECURRENT COSTS"},{"name":"TOTAL RETAINED INDEPENDENT REVENUE"}]}]}]},"options":{"hierarchy":["costCenter_Code_MDA","table_identifier_MDA","lineExpTermLevel1"],"input":null,"attribute":"leafCount","linkLength":null,"fontSize":10,"tooltip":false,"collapsed":true,"zoomable":true,"margin":{"top":20,"bottom":20,"left":30,"right":195},"fill":"lightsteelblue"}},"evals":[],"jsHooks":[]}</script>

<!--/html_preserve-->

``` r
kable(data__2021_test)
```

| costCenter\_Code\_MDA | table\_identifier\_MDA                                        | lineExpTermLevel1                  | lineExpTermLevel2                  |      Amount |
| :-------------------- | :------------------------------------------------------------ | :--------------------------------- | :--------------------------------- | ----------: |
| PRESIDENCY            | BUREAU OF PUBLIC ENTERPRISES (BPE)                            | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |    55229597 |
| PRESIDENCY            | BUREAU OF PUBLIC ENTERPRISES (BPE)                            | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   113257822 |
| PRESIDENCY            | BUREAU OF PUBLIC ENTERPRISES (BPE)                            | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   337483139 |
| PRESIDENCY            | BUREAU OF PUBLIC ENTERPRISES (BPE)                            | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |   526713164 |
| PRESIDENCY            | BUREAU OF PUBLIC ENTERPRISES (BPE)                            | PERSONNEL COST                     | SALARY                             |   800909236 |
| PRESIDENCY            | BUREAU OF PUBLIC ENTERPRISES (BPE)                            | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | BUREAU OF PUBLIC PROCUREMENT (BPP)                            | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   205929069 |
| PRESIDENCY            | BUREAU OF PUBLIC PROCUREMENT (BPP)                            | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   750059898 |
| PRESIDENCY            | BUREAU OF PUBLIC PROCUREMENT (BPP)                            | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |    52091692 |
| PRESIDENCY            | BUREAU OF PUBLIC PROCUREMENT (BPP)                            | PERSONNEL COST                     | SALARY                             |   427807257 |
| PRESIDENCY            | BUREAU OF PUBLIC PROCUREMENT (BPP)                            | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | CAPITAL EXPENDITURE                | CONSTRUCTION / PROVISION           |   750154314 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |   816956658 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   250144397 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | CAPITAL EXPENDITURE                | REHABILITATION / REPAIRS           |    36106249 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | OTHER RECURRENT COSTS              | OVERHEAD COST                      |  3600773352 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION | 14574595929 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | PERSONNEL COST                     | SALARY                             |  9832964046 |
| PRESIDENCY            | ECONOMIC AND FINANCIAL CRIMES COMMISSION (EFCC)               | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)      | CAPITAL EXPENDITURE                | CONSTRUCTION / PROVISION           |  4647647859 |
| PRESIDENCY            | NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)      | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |  3330677854 |
| PRESIDENCY            | NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)      | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   433298500 |
| PRESIDENCY            | NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)      | CAPITAL EXPENDITURE                | REHABILITATION / REPAIRS           |   670375787 |
| PRESIDENCY            | NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)      | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   400000000 |
| PRESIDENCY            | NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)      | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |    75765600 |
| PRESIDENCY            | NATIONAL AGRICULTURAL LAND DEVELOPMENT AUTHORITY (NALDA)      | PERSONNEL COST                     | SALARY                             |   617380882 |
| PRESIDENCY            | NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES                | CAPITAL EXPENDITURE                | CONSTRUCTION / PROVISION           |  1040457710 |
| PRESIDENCY            | NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES                | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   270000000 |
| PRESIDENCY            | NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES                | OTHER RECURRENT COSTS              | GRANTS AND CONTRIBUTIONS           |    75000000 |
| PRESIDENCY            | NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES                | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   289975915 |
| PRESIDENCY            | NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES                | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |   142294086 |
| PRESIDENCY            | NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES                | PERSONNEL COST                     | SALARY                             |  1145586412 |
| PRESIDENCY            | NIGERIA ATOMIC ENERGY COMMISSION & ITS CENTRES                | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | NIGERIA EXTRACTIVE INDUSTRIES TRANSPARENCY INITIATIVE (NEITI) | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |   133416489 |
| PRESIDENCY            | NIGERIA EXTRACTIVE INDUSTRIES TRANSPARENCY INITIATIVE (NEITI) | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   241000000 |
| PRESIDENCY            | NIGERIA EXTRACTIVE INDUSTRIES TRANSPARENCY INITIATIVE (NEITI) | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   327314427 |
| PRESIDENCY            | NIGERIA EXTRACTIVE INDUSTRIES TRANSPARENCY INITIATIVE (NEITI) | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |    87005288 |
| PRESIDENCY            | NIGERIA EXTRACTIVE INDUSTRIES TRANSPARENCY INITIATIVE (NEITI) | PERSONNEL COST                     | SALARY                             |   729322864 |
| PRESIDENCY            | NIGERIA EXTRACTIVE INDUSTRIES TRANSPARENCY INITIATIVE (NEITI) | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | NIGERIAN FINANCIAL INTELLIGENCE UNIT (NFIU)                   | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |   100556531 |
| PRESIDENCY            | NIGERIAN FINANCIAL INTELLIGENCE UNIT (NFIU)                   | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   284000000 |
| PRESIDENCY            | NIGERIAN FINANCIAL INTELLIGENCE UNIT (NFIU)                   | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   900000000 |
| PRESIDENCY            | NIGERIAN FINANCIAL INTELLIGENCE UNIT (NFIU)                   | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |   315020138 |
| PRESIDENCY            | NIGERIAN FINANCIAL INTELLIGENCE UNIT (NFIU)                   | PERSONNEL COST                     | SALARY                             |  2580161100 |
| PRESIDENCY            | NIGERIAN FINANCIAL INTELLIGENCE UNIT (NFIU)                   | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | NIPSS, KURU                                                   | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   232454417 |
| PRESIDENCY            | NIPSS, KURU                                                   | CAPITAL EXPENDITURE                | REHABILITATION / REPAIRS           |    85799598 |
| PRESIDENCY            | NIPSS, KURU                                                   | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   813250740 |
| PRESIDENCY            | NIPSS, KURU                                                   | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |    86758748 |
| PRESIDENCY            | NIPSS, KURU                                                   | PERSONNEL COST                     | SALARY                             |   677148497 |
| PRESIDENCY            | NIPSS, KURU                                                   | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | OFFICE OF THE CHIEF ECONOMIC ADVISER TO THE PRESIDENT         | OTHER RECURRENT COSTS              | OVERHEAD COST                      |    46864446 |
| PRESIDENCY            | OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT                 | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |    56162473 |
| PRESIDENCY            | OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT                 | OTHER RECURRENT COSTS              | OVERHEAD COST                      |    20391700 |
| PRESIDENCY            | OFFICE OF THE CHIEF OF STAFF TO THE PRESIDENT                 | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | OFFICE OF THE CHIEF SECURITY OFFICER TO THE PRESIDENT         | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |   280812366 |
| PRESIDENCY            | OFFICE OF THE CHIEF SECURITY OFFICER TO THE PRESIDENT         | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   111359316 |
| PRESIDENCY            | OFFICE OF THE CHIEF SECURITY OFFICER TO THE PRESIDENT         | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | CAPITAL EXPENDITURE                | CONSTRUCTION / PROVISION           |  1516000000 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |   664595768 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |    98403244 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | CAPITAL EXPENDITURE                | PRESERVATION OF THE ENVIRONMENT    |    51465982 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | CAPITAL EXPENDITURE                | REHABILITATION / REPAIRS           |  5397720503 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | OTHER RECURRENT COSTS              | OVERHEAD COST                      |  2860063433 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | PERSONNEL COST                     | ALLOWANCES AND SOCIAL CONTRIBUTION |   569281967 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | PERSONNEL COST                     | SALARY                             |  1148538933 |
| PRESIDENCY            | STATE HOUSE - HQTRS                                           | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | STATE HOUSE LAGOS LIAISON OFFICE                              | CAPITAL EXPENDITURE                | REHABILITATION / REPAIRS           |   236115792 |
| PRESIDENCY            | STATE HOUSE LAGOS LIAISON OFFICE                              | OTHER RECURRENT COSTS              | OVERHEAD COST                      |    95280402 |
| PRESIDENCY            | STATE HOUSE LAGOS LIAISON OFFICE                              | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | STATE HOUSE MEDICAL CENTRE                                    | CAPITAL EXPENDITURE                | CONSTRUCTION / PROVISION           |   123726387 |
| PRESIDENCY            | STATE HOUSE MEDICAL CENTRE                                    | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |   231969277 |
| PRESIDENCY            | STATE HOUSE MEDICAL CENTRE                                    | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   331730212 |
| PRESIDENCY            | STATE HOUSE MEDICAL CENTRE                                    | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | STATE HOUSE OPERATIONS - PRESIDENT                            | CAPITAL EXPENDITURE                | CONSTRUCTION / PROVISION           |  1374416489 |
| PRESIDENCY            | STATE HOUSE OPERATIONS - PRESIDENT                            | OTHER RECURRENT COSTS              | OVERHEAD COST                      |  2761041923 |
| PRESIDENCY            | STATE HOUSE OPERATIONS - PRESIDENT                            | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
| PRESIDENCY            | STATE HOUSE OPERATIONS - VICE PRESIDENT                       | CAPITAL EXPENDITURE                | FIXED ASSETS PURCHASED             |    19302720 |
| PRESIDENCY            | STATE HOUSE OPERATIONS - VICE PRESIDENT                       | CAPITAL EXPENDITURE                | OTHER CAPITAL PROJECTS             |   111743051 |
| PRESIDENCY            | STATE HOUSE OPERATIONS - VICE PRESIDENT                       | OTHER RECURRENT COSTS              | OVERHEAD COST                      |   948618094 |
| PRESIDENCY            | STATE HOUSE OPERATIONS - VICE PRESIDENT                       | TOTAL RETAINED INDEPENDENT REVENUE | TOTAL RETAINED INDEPENDENT REVENUE |           0 |
