library(DBI)
#Include databasename, user and password 

con <- dbConnect(RMySQL::MySQL(),
                 dbname = "unhcr",
                 host ='127.0.0.1', 
                 port = 3306,
                 user = 'root',
                 password = "Logoslogos88")


