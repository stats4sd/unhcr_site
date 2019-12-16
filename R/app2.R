library(shiny)
library(leaflet)
library(DT)
#library(ggvis)
library(dplyr)
library(RColorBrewer)
library(shinythemes)
source('data.R')

options(shiny.host = '127.0.0.1')
options(shiny.port = 8002)


shinyApp(
  ui = tagList(
    tags$head(
      # style for the page
      tags$style(
      )
    ),
    ## navbarPage 
  
      tabPanel("Available Data",
               h2("Data available into database"),
               leafletOutput("available_map"),
               absolutePanel(#top = 100, right = 10,
                 
                 selectInput("country", "Country",
                             c("select country", unique(as.character(country_table$name)))
                 )
               )
      )

  ),
  server = function(input, output) {
   
    #Create Available data map
    pal = colorFactor(palette = c("yellow", "red", "green"), domain = quakes$mag)
    output$available_map <- renderLeaflet({
      leaflet( options = leafletOptions(minZoom = 1)) %>%
        
        setView(lng = 25, lat = 26, zoom = 2) %>% 
        # adds different details for the map
        addTiles() %>%
        addCircleMarkers(data = refugee, color = 'navy',~longitude, ~latitude, ~mag, stroke = F, group = "Refugee", 
                         popup = paste("<h5><strong>","Country name","</strong></h5>",
                                       "<b>Indic4:</b>", refugee$mag)) %>% 
        
        addCircleMarkers(data = sdg, color = ~ pal(mag),~longitude, ~latitude, ~mag*2, stroke = F, group = "SDG",  
                         popup= paste("<h5><strong>","Country name","</strong></h5>",
                                      "<b>Indic4:</b>", sdg$mag),
                         
        ) %>%
        # Layers control
        addLayersControl(
          overlayGroups = c("Refugee", "SDG"),
          options = layersControlOptions(collapsed = FALSE, title= "Layers Control")
        ) %>% 
        # addLegend
        addLegend(position = "bottomright", pal = pal, values = c(2,4,6),
                  title = "title legend"
        ) 
      
      
    })
    
    
    
    ##end server
  }
)
