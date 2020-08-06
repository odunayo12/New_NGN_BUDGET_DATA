library(tidyverse)
LOAN <- data.frame("SN" = 1:4, "Age" = c(21,47,68,33), 
                   "Name" = c("John", "Dora", "Ali", "Marvin"),
                   "RATE" = c('16%', "24.5%", "27.81%", "22.11%"), 
                   stringsAsFactors = FALSE)

removeChar <- LOAN %>% mutate(RATE = as.numeric(gsub("%", "", RATE)))


DT <- data.frame('AWC'= c(333, 485, 76, 666, 54), 
                 'LocationID'= c('*Yukon','*Lewis Rich', '*Kodiak', 'Kodiak', '*Rays'))

head(DT)
  AWC  LocationID
1 333      *Yukon
2 485 *Lewis Rich
3  76     *Kodiak
4 666      Kodiak
5  54       *Rays

DT <- DT %>% mutate(LocationID = gsub("\\*", "", LocationID))
head(DT)
  AWC LocationID
1 333      Yukon
2 485 Lewis Rich
3  76     Kodiak
4 666     Kodiak
5  54       Rays


price_1 <- c(25, 33, 54, 24)
price_2 <- c(12, 22, 11, 22)
itemid <- c(22203, 44412,55364, 552115)
itembds <- as.integer(c("", 21344, "", ""))
comment_1 <- c("The apple is expensive", "The orange is sweet", "The Apple is nice", "the apple is not nice")
comment_2 <- c("23 The Apple was beside me", "The Apple was left behind", "The apple had rotten", "the Orange should be fine" )
result <- c(0, 1, 1, 0)

df <- data.frame(price_1, price_2, itemid, itembds, comment_1, comment_2, result)
head(df)
DF <- df %>%
  mutate(
    resultNew = case_when(
      str_detect(tolower(comment_1), 'apple') &
        str_detect(tolower(comment_2), 'apple') &
        price_1 - price_2 > 20 ~
        1,
      ((
        str_detect(tolower(comment_1), 'orange') &
          str_detect(tolower(comment_2), 'apple')
      ) | (
        str_detect(tolower(comment_1), 'apple') &
          str_detect(tolower(comment_2), 'orange')
      )) & price_1 - price_2 > 20 ~
        1,
    )
  ) 
head(DF)
  # mutate(resultNew = if_else(
  #   str_detect(tolower(comment_1), 'apple') &
  #     str_detect(tolower(comment_2), 'apple') & price_1 - price_2 > 20,
  #   1,
  #   122
  # )) 

head(DF)
#mutate(reultNew = case_when(filter(str_detect(tolower(comment_1), 'apple'), str_detect(tolower(comment_2), 'apple'))~1 ))
  # filter(str_detect(tolower(comment_1), 'apple'), str_detect(tolower(comment_2), 'apple')) %>%
  # mutate(resultNew = if_else(price_1 - price_2 > 20, 1, 0))
  # mutate(resultNew = if_else())

 # The `tidyverse` package simplifies this with just a few steps.
 # Your dataframe `df` gives 
 # 
 # price_1 price_2 itemid itembds              comment_1                  comment_2 result
 # 1      25      12  22203      NA The apple is expensive 23 The Apple was beside me      0
 # 2      33      22  44412   21344    The orange is sweet  The Apple was left behind      1
 # 3      54      11  55364      NA      The Apple is nice       The apple had rotten      1
 # 4      24      22 552115      NA  the apple is not nice  the Orange should be fine      0
 # 
 # In what follows, `DF` is the new `dataframe`; the `filter` verb filters the `comment_1` and `comment_2` columns; using `str_detect()` to detect a pattern (`apple`), after first converting the respective columns to lowercase via `tolower()`. `mutate` allows us to add a new column (`resultNew`)  to the dataset. `if_esle()` is a shorthand form of the traditional `if else` statement.
 # 
 # 
 # 
 # DF <- df %>% 
 #   filter(str_detect(tolower(comment_1), 'apple'), str_detect(tolower(comment_2), 'apple')) %>% 
 #   mutate(resultNew = if_else(price_1 - price_2 > 20, 1, 0))
 # 
 # The result is:
 #   
 #   head(DF)
 # price_1 price_2 itemid itembds              comment_1                  comment_2 result resultNew
 # 1      25      12  22203      NA The apple is expensive 23 The Apple was beside me      0         0
 # 2      54      11  55364      NA      The Apple is nice       The apple had rotten      1         1
 # 
 
df.1 <- class = c(1,6,8,9,7,8,9,6,4), math = c(0.7, 0.4, 0.7), hist = c(0.6, 0.4, 0.3), geom = c(0.7, 0.4, 0.7), eng = c(0.7, 0.4, 0.7), draw = c(0.8, 0.6, 0.7)

class = c(1, 6, 8, 9, 7, 8, 9, 6, 4)
math = c(0.7, 0.4, 0.7)
hist = c(0.6, 0.4, 0.3)
geom = c(0.7, 0.4, 0.7)
eng = c(0.7, 0.4, 0.7)
draw = c(0.8, 0.6, 0.7)

dimension <-
  seq(max(
    length(class),
    length(math),
    length(hist),
    length(geom),
    length(eng),
    length(draw)
  ))

df.new <- data.frame(class[dimension], math[dimension], hist[dimension], 
                     geom[dimension], eng[dimension], draw[dimension])

names(df.new) <- c('class', 'math', 'hist', 'geom', 'eng', 'draw')
df.new

head(df.1)
tibble(data = df.1) %>% 
  group_by(name = names(data))%>% 
  unnest() %>%
  # mutate(i = row_number()) %>% 
  spread(name, data)
names(df.1)
library(zoo)





#https://stackoverflow.com/questions/1269624/how-to-get-row-from-r-data-frame/63281174#63281174
library(tidyverse)
x <- structure(list(A = c(5,    3.5, 3.25, 4.25,  1.5 ), 
                    B = c(4.25, 4,   4,    4.5,   4.5 ),
                    C = c(4.5,  2.5, 4,    2.25,  3   )
),
.Names    = c("A", "B", "C"),
class     = "data.frame",
row.names = c(NA, -5L)
)

x

y<-c(A=5, B=4.25, C=4.5)
y

#The slice() verb allows one to subset data row-wise. 
x <- x %>% slice(1) #(n) for nth row, or (i:n) for range i to n, (i:n()) for i to bottom

x

#Test that the items in the row match the vector you wanted
x[1,]==y

