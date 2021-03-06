library(DBI)
library(dotenv)


#Include databasename, user and password

load_dot_env(file = "../.env")

con <-  DBI::dbConnect(RMySQL::MySQL(),
                 dbname = Sys.getenv('DB_DATABASE'),
                 host = Sys.getenv('DB_HOST'),
                 port = as.numeric(Sys.getenv('DB_PORT')),
                 user = Sys.getenv('DB_USERNAME'),
                 password = Sys.getenv('DB_PASSWORD')
)
