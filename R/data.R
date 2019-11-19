library(DBI)
library(DT)
library(data.table)
source('dbConfig.R')
quakes <- quakes %>%
  dplyr::mutate(mag.level = cut(mag,c(3,4,5,6),
                                labels = c('>3 & <=4', '>4 & <=5', '>5 & <=6')))
#use con for connecting to database 
indicator_table<-dbGetQuery(con,'
  select *
  from indicator
  group by id')


dbDisconnect(con)



