library(DBI)
library(DT)
# library(data.table)
library(ggplot2)
library(maps)
library(ggthemes)
#library(readr)
library(dplyr)
source('dbConfig.R')
quakes <- read.csv("query.csv")
View(quakes)
#available data maps 
url_csv <- 'https://raw.githubusercontent.com/d4tagirl/R-Ladies-growth-maps/master/rladies.csv'
rladies <- read.csv(url(url_csv)) %>% 
  select(-1)

datatable(rladies, rownames = FALSE,
          options = list(pageLength = 5))

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

map <- world +
  geom_point(aes(x = lon, y = lat, size = followers),
             data = rladies, 
             colour = 'purple', alpha = .5) +
  scale_size_continuous(range = c(1, 8), 
                        breaks = c(250, 500, 750, 1000)) +
  labs(size = 'Followers')


#use con for connecting to database 
indicator_table_db<-dbGetQuery(con,'
  select *
  from indicator
  group by id')


# # indicators table from csv
# indicator_table <- read.csv("C:/Users/LuciaFalcinelli/Documents/R/unhcr/data/Colombia Iraq SDG indicators for displaced people.csv")
# 
# # indicator_table1 for Basic needs and living conditions
# indicator_table1<-indicator_table %>% select('Country', 'Year', 'SDG_2.2.1', 'SDG_3.2.1', 'SDG_6.6.1', 'SDG_11.1.1')
# 
# # indicator_table2 for Livelihoods and economic self-reliance
# indicator_table2<-indicator_table %>% select('Country', 'Year', 'SDG_1.2.1', 'SDG_4.1.1.a.i', 'SDG_7.1.1', 'SDG_8.3.1', 'SDG_8.5.2.male', 'SDG_8.5.2.female')
# 
# # indicator_table3 for Livelihoods and economic self-reliance
# indicator_table3<-indicator_table %>% select('Country', 'Year', 'SDG_1.4.2.a', 'SDG_1.4.2.b', 'SDG_16.1.4', 'SDG_16.9.1')

dbDisconnect(con)



