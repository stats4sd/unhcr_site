library(DBI)
library(DT)
library(maps)
library(dplyr)
library(stringi)
library(dotenv)
source('dbConfig.R')

get_sql_connection <- function() {
  
 
  load_dot_env(file = "../.env")
  
  con <-  DBI::dbConnect(RMySQL::MySQL(),
                         dbname = Sys.getenv('DB_DATABASE'),
                         host = Sys.getenv('DB_HOST'),
                         port = as.numeric(Sys.getenv('DB_PORT')),
                         user = Sys.getenv('DB_USERNAME'),
                         password = Sys.getenv('DB_PASSWORD')
                        )
  
  
  dbSendQuery(con,"set character set 'utf8mb4'")
  
  return(con)
}
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
indicators_map <- indicators %>% group_by(countries_name, country_code, latitude, longitude) %>% summarise('indicator_num'= n(), icon_url = list_group(country_code)) 


list_group <- function(country_code){

  indic_by_country <- load_indicators(country_code)
  list_group <- unique(indic_by_country$group_name)
  string_group<-paste( unlist(list_group), collapse='')
  print(string_group)
  return(string_group)
}



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
# load data by country code
#####################################
load_indicators<-function(country_code){
  
  con <- get_sql_connection()
  sql <- "SELECT
         indicators.group_name,
         indicators.indicator_value,
         datasets.region,
         datasets.year,
         datasets.country_code,
         datasets.description,
         datasets.population_definition,
         datasets.source_url,
         datasets.comment,
         countries.name as countries_name,
         sdg_indicators.code as sdg_code
         FROM indicators
         LEFT JOIN datasets on datasets.id = indicators.dataset_id
         LEFT JOIN countries on countries.ISO_code = datasets.country_code
         LEFT JOIN sdg_indicators on  sdg_indicators.id = indicators.sdg_indicator_id"
                        
  if(! is.null(country_code)) {
    sql <- paste(sql, " WHERE datasets.country_code = '",country_code, "'", sep = "")
  }
  
  indicators <- dbGetQuery(con,paste(sql,";"))
  dbDisconnect(con)
  return(indicators)
  
}


#####################################
# create image for SDG
#####################################

show_image<-function(sdg_number){
  src_image <- paste("images_app/E-WEB-Goal-",sdg_number,".png", sep="")
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


killDbConnections <- function () {
  
  all_cons <- dbListConnections(MySQL())
  
  print(all_cons)
  
  for(con in all_cons)
    +  dbDisconnect(con)
  
  print(paste(length(all_cons), " connections killed."))
  
}

killDbConnections()
