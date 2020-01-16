library(shiny)
library(leaflet)
library(DT)
library(ggvis)
library(dplyr)
library(RColorBrewer)
library(shinythemes)
source('data.R')


options(shiny.host = '127.0.0.1')
options(shiny.port = 8002)


shinyApp(
  ui = tagList(
    tags$head(
    ),
    ## navbarPage
    fluidPage(
      fluidRow(
        column(4,
        # Control Panel for the indicators
          h3("DISAGGREGATED DATA"),
          h4("Availability by Location"),
         selectizeInput(
                     "country", 
                     "",
                     countries_list, 
                      options = list(
                       placeholder = "Select a Country", 
                       onInitialize = I('function() { this.setValue(""); }')
                       )
                     ),
       
          sliderInput("years",
                      h3("Filter Year"), 
                      min = min(years),
                      max = max(years),
                      value = c(min(years), max(years))
                      ),
        
        checkboxGroupInput("filterSubsets", 
                           h3("Filter Subsets"), 
                           choices = subsets_list
                           
                          ),
        checkboxGroupInput("filterIndicators", 
                           h3("Filter Indicators"), 
                           choices = sdg_list
                          ),
        ),
        
          column(8,
           
              h2("Map"),
              leafletOutput("mymap", height="85vh"),
              "Basic needs and living conditions"
              #DT::dataTableOutput("tableTab1")
          )
      )      
    )
  ),
  server = function(input, output) {

    # Create the map
    output$mymap <- renderLeaflet({
    leaflet() %>% addTiles() %>% addProviderTiles("Esri.WorldStreetMap") %>%
      addMiniMap(
        tiles = providers$Esri.WorldStreetMap,
        toggleDisplay = TRUE
      )
    })

    # Filter data by subset 
    filter_country <- reactive({
      if(input$country==""){
        
        return(indicators)
      }else{
        country_selected <- indicators%>% filter(country_code==input$country)
        return(country_selected)
      }
    })
    
    # Filter data by subsets
    filter_subsets <- reactive(function(country_selected){
        if(input$filterSubsets==""){
          subset_selected <- country_selected %>% filter(group_name==input$filterSubsets)
          
          return(country_selected)
        } else {
          subset_selected <- country_selected %>% filter(group_name==input$filterSubsets)
          return(subset_selected)
        }
      })

    observe({
      
      if(input$country=="") {

          refugees <- subset(indicators, group_name == "Refugees")
          idps <- subset(indicators, group_name == "IDPs")
          isdps_not_camp <- subset(indicators, group_name == "IDPs (not in camp/settlements)")
          isdps_camp <- subset(indicators, group_name == "Asylum Seekers")
          asylum_seekers <- subset(indicators, group_name == "Asylum Seekers")
          mixed <- subset(indicators, group_name == "Mixed")
          leafletProxy("mymap") %>%
            setView(lng = 0, lat = 0, zoom = 2.5) %>%
            #clearMarkers() %>%
            addCircleMarkers(layerId = mixed$id, lng = mixed$longitude, 
                             lat = (mixed$latitude-runif(1)), radius = mixed$indicator_value*15, stroke=FALSE, color = "#08306b", 
                             fillOpacity = 0.6, 
                             popup = paste("<h5><b>Country:</b>", 
                                           mixed$countries_name, "</h5>",
                                           "<h5><b>Indicators n:</b>", mixed$indicator_num , "</h5>"
                                           )) %>% 
            addCircleMarkers(layerId = refugees$id, lng = refugees$longitude, 
                              lat = refugees$latitude, radius = refugees$indicator_value*15, stroke=FALSE, color = "#08519c", 
                              fillOpacity = 0.6, 
                              popup = paste("<h5><b>Country:</b>", 
                                            refugees$countries_name, "</h5>",
                                            "<h5><b>Indicators n:</b>", refugees$indicator_num , "</h5>"
                                             
                              )) %>% 
            addCircleMarkers(layerId = idps$id, lng = (idps$longitude+runif(1)), 
                             lat = idps$latitude, radius = idps$indicator_value*15, stroke=FALSE, color = "#2171b5", 
                             fillOpacity = 0.6, 
                             popup = paste("<h5><b>Country:</b>", 
                                           idps$countries_name, "</h5>",
                                           "<h5><b>Indicators n:</b>", idps$indicator_num , "</h5>"
                                           )) %>%
            addCircleMarkers(layerId = isdps_not_camp$id, lng = (isdps_not_camp$longitude+runif(1)), 
                             lat = (isdps_not_camp$latitude+runif(1)), radius = isdps_not_camp$indicator_value*15, stroke=FALSE, color = "#4292c6", 
                             fillOpacity = 0.6, 
                             popup = paste("<h5><b>Country:</b>", 
                                           isdps_not_camp$countries_name, "</h5>",
                                           "<h5><b>Indicators n:</b>", isdps_not_camp$indicator_num , "</h5>"
                                           )) %>%
            addCircleMarkers(layerId = isdps_camp$id, lng = isdps_camp$longitude, 
                             lat = (isdps_camp$latitude+runif(1)), radius = isdps_camp$indicator_value*15, stroke=FALSE, color = "#6baed6", 
                             fillOpacity = 0.6, 
                             popup = paste("<h5><b>Country:</b>", 
                                           isdps_camp$countries_name, "</h5>",
                                           "<h5><b>Indicators n:</b>", isdps_camp$indicator_num , "</h5>"
                                           )) %>%
            addCircleMarkers(layerId = asylum_seekers$id, lng = (asylum_seekers$longitude+runif(1)), 
                             lat = (asylum_seekers$latitude-runif(1)), radius = asylum_seekers$indicator_value*15, stroke=FALSE, color = "#9ecae1", 
                             fillOpacity = 0.6, 
                             popup = paste("<h5><b>Country:</b>", 
                                           asylum_seekers$countries_name, "</h5>",
                                           "<h5><b>Indicators n:</b>", asylum_seekers$indicator_num , "</h5>"
                                           )) 
            
      } else {
        
        filter_country <- filter_country()
        
        filter_years <- subset(filter_country, year>=min(input$years) && year<=max(input$years))
        #filter_country <- subset(filter_country, group_name==input$filterSubsets)
        #filter_country <- subset(filter_country, sdg_indicator_id==input$filterIndicators)
        
        leafletProxy("mymap") %>%
            setView(lng = unique(filter_country$longitude), lat = unique(filter_country$latitude), zoom = 5) %>% 
            clearMarkers() %>% 
              addCircleMarkers(layerId = filter_country$id, lng = (filter_country$longitude+runif(1)), 
                              lat = filter_country$latitude, radius =8, stroke=FALSE, color = "#9ecae1", 
                              fillOpacity = 0.6, 
                              popup = paste("<h5><b>Country:</b>", 
                                            filter_country$countries_name, "</h5>",
                                            "<h5><b>Indicators n:</b>", filter_country$indicator_num , "</h5>"
                              )) 
              
            
      }
      
      
    
    })
    
    

    ## 
    ## table in main page tab 1
    output$tableTab1 = DT::renderDataTable({
      DT::datatable(
        #indicator_table1,
        filter = 'top',
        extensions = 'Buttons',
        options = list(
          dom = 'Blfrtip',
          buttons = c(I('colvis'), 'csv'),
          text = 'Download',
          br()
        ),
        class = "display"
      )
    })
    


    ##end server
  }
)

