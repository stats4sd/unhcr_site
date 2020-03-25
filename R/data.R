library(DBI)
library(DT)
library(maps)
library(dplyr)
library(stringi)
library(dotenv)
source('dbConfig.R')

#####################################
# Get connection with the database
#####################################

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



#####################################
# Get url for downloding
#####################################

download_script <- function() {
  
  load_dot_env(file = "../.env")
  Sys.getenv("APP_ENV")
}

download_script()
#############################################
# Create the information for the map, 
# include the url for the markers
#############################################

load_indicators_map<-function(){
  
  indicators_map <- load_indicators(NULL) %>% group_by(countries_name, country_code, latitude, longitude) %>% 
  summarise('indicator_num'= n(), icon_url = create_url_markers(country_code),
            population_definition=paste(unique(population_definition),collapse="; "), 
            source_url=paste('<br style="margin-bottom: 0px;">',unique(description),';','<br style="margin-bottom: 7px;">','<a href="',
                             unique(source_url),'">',unique(source_url), 
                             '</a>',';','<br style="margin-bottom: 7px;">', sep="", collapse=' '),
            max_year=max(year), min_year=min(year)
            )
  
  return(indicators_map)
}


#####################################
# Palette indicators for the Charts
#####################################

palette_indicators<-function(){
  palette_indicators <- c("#e5243b", "#dda83a", "#4c9f38", "#c5192d", "#ff3a21", 
                          "#26bde2", "#fcc30b", "#a21942", "#fd6925", "#dd1367", 
                          "#fd9d24", "#bf8b2e", "#3f7e44","#0a97d9", "#56c02b", 
                          "#00689d", "#19486a")
  
  return(palette_indicators)
}

#########################################
# Create a url for the markers in the map
#########################################

create_url_markers <- function(country_code){

  indic_by_country <- load_indicators(country_code)
  list_group <- unique(indic_by_country$group_name)
  list_group <- sort(list_group, decreasing = FALSE)
  string_group <- paste( unlist(list_group), collapse='')
  icon_url <- paste("images_app/markers/",string_group,".png", sep="")
  
  return(icon_url)
}

############################################
# Create a list of countries for the dropdown
#############################################

countries_list<-function(){
  con <- get_sql_connection()
  
  sql<-"SELECT
            
            datasets.country_code,
            countries.name as countries_name

            FROM datasets
            
            LEFT JOIN countries on datasets.country_code = countries.ISO_code
            WHERE datasets.fake = 0
        "
  
  countries_list_df <- dbGetQuery(con, sql)
  dbDisconnect(con)
  countries_list <- setNames(countries_list_df$country_code,as.character(countries_list_df$countries_name))
  return(countries_list)
}


############################################
# Create a list of groups.name for the 
# subsets checkbox
#############################################

subsets_list<-function(country_code){
 
  con <- get_sql_connection()
  sql<-"SELECT
            groups.name,
            groups.lft
            FROM groups;"
  
  groups_name_df <- dbGetQuery(con, sql)
  dbDisconnect(con)
  if(! is.null(country_code)) {
    groups_country <- unique(load_indicators(country_code)$group_name)
    groups_name_df <- filter(groups_name_df,name %in% groups_country)
  }
  groups_name_df <- groups_name_df[order(groups_name_df$lft),]
  subsets_list <- setNames(groups_name_df$name,as.character(groups_name_df$name))
  
  
  return(subsets_list)  
}
############################################
# Create a list of subgroups.name for the 
# subgroup checkbox
#############################################

subgroup_list<-function(country_code){
  con <- get_sql_connection()
  
  sql<-"SELECT
            subgroups.name,
            subgroups.lft
            FROM subgroups;"
  
  
  subgroups_name_df <- dbGetQuery(con,sql)
  dbDisconnect(con)
  if(! is.null(country_code)) {
    groups_country <- unique(load_indicators(country_code)$subgroup_name)
    subgroups_name_df <- filter(subgroups_name_df,name %in% groups_country)
  }
  subgroups_name_df <- subgroups_name_df[order(subgroups_name_df$lft),]
  subgroup_list <- setNames(subgroups_name_df$name,as.character(subgroups_name_df$name))
  
  return(subgroup_list)  
}

############################################
# load dataset for additional info tab
#############################################

load_dataset<-function(country_code){
  con <- get_sql_connection()
  
  sql<-"SELECT *
          
            FROM datasets
            
            WHERE datasets.fake = 0
  "
  
  if(! is.null(country_code)) {
    sql <- paste(sql, " AND datasets.country_code = '",country_code, "'", sep = "")
  }
  datasets <- dbGetQuery(con,paste(sql,";"))
  
  datasets$countries_name <- as.factor(datasets$country_code)
  datasets$year <- as.numeric(datasets$year)
  datasets$region <- as.factor(datasets$region)
  datasets$description <- as.factor(datasets$description)
  datasets$population_definition <- as.factor(datasets$population_definition)
  datasets$source_url <- as.factor(datasets$source_url)
  datasets$comment <- as.factor(datasets$comment)
  datasets$scripts_description <- as.factor(datasets$scripts_description)
  
  dbDisconnect(con)
  return(datasets)  
}



additional_info<-function(country_code){
  load_dot_env(file = "../.env")
  Sys.getenv('APP_ENV')
  datasets_by_country <- load_dataset(country_code)
  script_download <- c()
  for(i in 1:nrow(datasets_by_country)) {
    row <- datasets_by_country[i,]
    if(!is.na(row$scripts_url)){
    
      script_json <- fromJSON(row$scripts_url)
      for (i in 1:length(script_json)) {
        if(!is.na(script_json[i])){
          script_download <- script_download %>%  append(paste("<a href=https://",Sys.getenv('APP_ENV'),"/storage/", script_json[i],
                                 "'><i class='fa fa-download' style='color:#0072BC'>"," Example script",
                                 "</i></a>", sep = ""))
        }
      }
    }
  }

  return(script_download)
}
additional_info('IRQ')
############################################
# limit to 50 characters the description 
# for the sdg_description
#############################################

limited_description<-function(){
  description<-substring(load_indicators(NULL)$sdg_description, 0, 30)
  for(i in 1:length(load_indicators(NULL)$sdg_description)){
    if(length(load_indicators(NULL)$sdg_description[i])<25){
      description[i]<-paste(description[i], '[...]')
    }
  }
  return(description)
}

############################################
# Create sdg list for the control panel
#############################################

sdg_list <- function(country_code){
  con <- get_sql_connection()
  sql<-"SELECT
            sdg_indicators.code,
            sdg_indicators.description,
            sdg_indicators.lft
            FROM sdg_indicators;"
  
  
  sdg_indicators <- dbGetQuery(con, sql)
  dbDisconnect(con)
  if(! is.null(country_code)) {
    sdg_code_country <- unique(load_indicators(country_code)$sdg_code)
    sdg_indicators <- filter(sdg_indicators,code %in% sdg_code_country)
  }
  sdg_indicators <- sdg_indicators[order(sdg_indicators$lft),]
  sdg_list <- setNames(as.character(sdg_indicators$code),paste(sdg_indicators$code,":",sdg_indicators$description))
  
  return(sdg_list)
}


############################################
# Create sdg code list for the SDG filter
#############################################

sdg_code_list <- function(){
  con <- get_sql_connection()
  
  sql<-"SELECT sdg_indicators.code as sdg_code
           
        FROM sdg_indicators;"
  
  sdg_code_df <- dbGetQuery(con, sql)
  dbDisconnect(con)
  sdg_code_list <- unique(sdg_code_df$sdg_code)
  
  return(sdg_code_list)
}

#####################################
# load data by country code
#####################################

load_indicators<-function(country_code){
  
  con <- get_sql_connection()

  sql <- "SELECT
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
            sdg_indicators.lft as sdg_lft,
            sdg_indicators.description as sdg_description
            FROM indicators
            LEFT JOIN datasets on indicators.dataset_id = datasets.id
            LEFT JOIN countries on datasets.country_code = countries.ISO_code
            LEFT JOIN sdg_indicators on indicators.sdg_indicator_id = sdg_indicators.id"
                        
  if(! is.null(country_code)) {
    sql <- paste(sql, " WHERE datasets.country_code = '",country_code, "'", sep = "")
  }
  
  indicators <- dbGetQuery(con,paste(sql,";"))
  
  indicators$countries_name <- as.factor(indicators$countries_name )
  indicators$year <- as.numeric(indicators$year)
  indicators$latitude <- as.numeric(indicators$latitude)
  indicators$longitude <- as.numeric(indicators$longitude)
  indicators$group_name <- as.factor(indicators$group_name)
  indicators$subgroup_name <- as.factor(indicators$subgroup_name)
  indicators$indicator_value <- round(indicators$indicator_value, 2)
  

  dbDisconnect(con)
  
  return(indicators)
}


#####################################
# Create src for the SDG image
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
#killDbConnections()
