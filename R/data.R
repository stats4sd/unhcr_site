library(DBI)
library(DT)
library(ggplot2)
library(maps)
library(ggthemes)
library(dplyr)
source('dbConfig.R')

#available data maps
url_csv <- 'https://raw.githubusercontent.com/d4tagirl/R-Ladies-growth-maps/master/rladies.csv'
rladies <- read.csv(url(url_csv)) %>%
  select(-1)

datatable(rladies, rownames = FALSE,
          options = list(pageLength = 5))


#use con for connecting to database
indicator_table_db<-dbGetQuery(con,'
  select *
  from countries')

 

# country table
country_table<-dbGetQuery(con,'
  select *
  from countries')

#fdata for data available map
indicators<-dbGetQuery(con,'
  SELECT
          indicators.dataset_id,
          indicators.group_name,
          indicators.sdg_indicator_id,
          indicators.indicator_value,
          datasets.region,
          datasets.country_code,
          datasets.year,
          datasets.description,
          datasets.population_definition,
          datasets.source_url,
          datasets.comment,
          countries.name as countries_name,
          countries.longitude,
          countries.latitude
          FROM indicators
          LEFT JOIN datasets on indicators.dataset_id = datasets.id
          LEFT JOIN countries on datasets.country_code = countries.ISO_code;
  ')

indicators$countries_name <- as.factor(indicators$countries_name )

sdg <-quakes  %>% filter(mag<=4)
refugee <-quakes %>% filter(mag>4)




dbDisconnect(con)



