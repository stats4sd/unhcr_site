library(DBI)
library(DT)
library(ggplot2)
library(maps)
library(ggthemes)
library(dplyr)
source('dbConfig.R')


#indicators
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
indicators$year <- as.numeric(indicators$year)
indicators$latitude <- as.numeric(indicators$latitude)
indicators$longitude <- as.numeric(indicators$longitude)

##get years list for the slider range bar 
years<-indicators$year

##add number indicators for each country
indicators_num<-indicators %>% group_by(countries_name) %>% summarise('indicator_num'= n())
indicators<-merge(indicators, indicators_num, by.x= 'countries_name', by.y = 'countries_name')

dbDisconnect(con)



