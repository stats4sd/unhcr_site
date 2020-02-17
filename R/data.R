library(DBI)
library(DT)
library(maps)
library(dplyr)
library(stringi)
source('dbConfig.R')


#indicators
indicators<-dbGetQuery(con,'
SELECT
          indicators.dataset_id,
          indicators.group_name,
          indicators.subgroup_name,
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
indicators$group_name <- as.factor(indicators$group_name)

##get years list for the slider range bar 
years<-indicators$year

##create indicator for the maps included the color for the group
indicators_map <- indicators %>% group_by(countries_name, group_name, subgroup_name, latitude, longitude) %>% summarise('indicator_num'= n()) 
#Palette
palette_group <- data.frame('group_name' = unique(indicators_map$group_name), "color"=c("#08306b","#08519c", "#2171b5", "#4292c6", "#6baed6", "#9ecae1"), 
                            'lat'= c(0.5,0,0,0.5,0,-0.5), 'long'= c(0,-0.5,0.5,0.5,0,0.5))
palette_indicators = c("#e5243b", "#dda83a", "#4c9f38", '#c5192d',
                       "#ff3a21", "#26bde2", "#fcc30b", '#a21942',
                       "#fd6925", "#dd1367", "#fd9d24", '#bf8b2e',
                       "#3f7e44", '#0a97d9', '#56c02b', '#00689d', '#19486a')

indicators_map <- merge(x=indicators_map, y=palette_group, by="group_name", all.x=TRUE)
indicators_map$latitude <- indicators_map$latitude+indicators_map$lat
indicators_map$longitude <- indicators_map$longitude+indicators_map$long

#list of countries, sdg and sdg_code for the filters
countries_list <- setNames(indicators$country_code,as.character(indicators$countries_name))
subsets_list <- sort(unique(setNames(indicators$group_name,as.character(indicators$group_name))))
subsets_list <- append(as.character(subsets_list), 'Select All', after = 0)

#limit to 50 characters the description for the sdg_description

limited_description<-substring(indicators$sdg_description, 0, 30)
for(i in 1:length(indicators$sdg_description)){
  if(length(indicators$sdg_description[i])<25){
    
    limited_description[i]<-paste(limited_description[i], '[...]')
  }
}
sdg_list <- setNames(unique(indicators$sdg_code),as.character(paste(unique(indicators$sdg_code), unique(limited_description), sep=': ')))
sdg_list[!is.na(sdg_list)]
sdg_list <- sort(sdg_list)

sdg_list <- append((sdg_list), 'Select All', after = 0)

sdg_code_list <- unique(indicators$sdg_code)

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

#####################################
# create image for SDG
#####################################

show_image<-function(sdg_number){
  src_image <- paste("images_app/E-WEB-Goal-0",sdg_number,".png", sep="")
  alt_image <- paste("sdg",sdg_number, sep="")
  renderImage({
   
      return(list(
        width = 100,
        height = 100,
        src = src_image,
        contentType = "image/png",
        alt = alt_image
      ))
    
    
  }, deleteFile = FALSE)
}
