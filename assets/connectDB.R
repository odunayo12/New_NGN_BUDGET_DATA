#readRenviron(".env")

#Sys.getenv("pwd")
drectory <- "C:/Users/rotim/OneDrive - bwedu/Web Developmnet/data-analysis/New_NGN_BUDGET_DATA/assets/.env"
readRenviron(drectory)


storiesDb <- dbConnect(RMariaDB::MariaDB(), user=Sys.getenv('user'), password=Sys.getenv('pwd'), dbname=Sys.getenv('dbname'), host=Sys.getenv('host'))
dbListTables(storiesDb)

query <- "INSERT INTO n_s VALUES (DEFAULT,'Ah', 'AW', 77, 30876.33);"
print(query)

rsInsert <- dbSendQuery(storiesDb, query)







dbDisconnect(storiesDb)
