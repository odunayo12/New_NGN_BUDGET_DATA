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

    ## -- Attaching packages ------------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse 1.3.0 --

    ## v ggplot2 3.3.2     v purrr   0.3.4
    ## v tibble  3.0.3     v dplyr   1.0.1
    ## v tidyr   1.1.1     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.5.0

    ## -- Conflicts ---------------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
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

Next the granularity of this dataset lies in the expenses column
Satrting with 2 and incresing. Our strategy will be to create a new
cloumn for the desired entries.
