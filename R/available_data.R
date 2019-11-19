library(shiny)
library(leaflet)
library(DT)
library(ggvis)
library(dplyr)
source('data.R')
options(shiny.host = '127.0.0.1')
options(shiny.port = 8888)


shinyApp(
  ui = 
    
    ## navbarPage 
    navbarPage(
      theme = shinythemes::shinytheme("cosmo"),
      
      "Charts Wash Data",
      
               mainPanel(
                 tabsetPanel(
                   # Map
                   tabPanel("Map",
                            h2("Map"),
                            leafletOutput("map")
                            
                            
                   )
                 )
               )
      )
    )
  
  
server = function(input, output) {
   

    
}

