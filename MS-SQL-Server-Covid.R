## 2022-06-06

rm(list = ls())
### SQL Server Code

library(DBI)
library(odbc)
library(ggplot2)
library(scales)
library(tidyverse)
library(janitor)
library(readxl)

##
rm(list=ls())

retail_sales <- read_xlsx("./Online Retail.xlsx")
retail_sales <- retail_sales %>% janitor::clean_names()
retail_sales <- retail_sales %>% janitor::remove_empty(which = c("rows","cols"))
# retail_sales$total_sales <- retail_sales$quantity * retail_sales$unit_price
retail_sales <- mutate(retail_sales,total_sales =quantity * unit_price)

## https://db.rstudio.com/databases/microsoft-sql-server/
con <- DBI::dbConnect(odbc::odbc(), 
                      Driver = "SQL Server", 
                      Server = "localhost\\SQLEXPRESS", 
                      Database = "Angelina", 
                      Trusted_Connection = "True")

# dbListTables(con)


# USA <- read.csv("../COVID-19-NYTimes-data//us.csv")
# USA$date <- as.Date(USA$date)

dbWriteTable(con, "retail_sales", retail_sales,overwrite=TRUE)
dbListFields(con,"Covid")

dbGetQuery(con,"select count(*) as row_count from retail_sales")
# dbCommit(con)

dbDisconnect(con)





