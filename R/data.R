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
          countries.latitude,
          sdg_indicators.code as sdg_code,
          sdg_indicators.description as sdg_description
          FROM indicators
          LEFT JOIN datasets on indicators.dataset_id = datasets.id
          LEFT JOIN countries on datasets.country_code = countries.ISO_code
          LEFT JOIN sdg_indicators on indicators.sdg_indicator_id = sdg_indicators.id;
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

countries_list <- setNames(indicators$country_code,as.character(indicators$countries_name))
subsets_list <- unique(setNames(indicators$group_name,as.character(indicators$group_name)))
sdg_list <- setNames(indicators$sdg_code,as.character(paste(indicators$sdg_code, indicators$sdg_description, sep=': ')))
sdg_list[!is.na(sdg_list)]

#data to display in the table
data_table <- dbGetQuery(con,'
SELECT
          
          indicators.group_name,
          indicators.indicator_value,
          datasets.region,
          datasets.year,
          datasets.description,
          datasets.population_definition,
          datasets.source_url,
          datasets.comment,
          countries.name as countries_name,
          sdg_indicators.code as sdg_code
          FROM indicators
          LEFT JOIN datasets on indicators.dataset_id = datasets.id
          LEFT JOIN countries on datasets.country_code = countries.ISO_code
          LEFT JOIN sdg_indicators on indicators.sdg_indicator_id = sdg_indicators.id;
  ')
dbDisconnect(con)



