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
        selectInput("country", "",
                    c("Select Country", unique(as.character(indicators$countries_name)))
                    ),
       
          sliderInput("n",
                      "Select the years:",
                      min = min(years),
                      max = max(years),
                      value = c(min(years), max(years))
                      ),
        
        checkboxGroupInput("filterSubsets", 
                           h3("Filter Subsets"), 
                           choices = list("Refugees" = "Refugees", 
                                          "IDPs (in camps/settlements)" = "IDPs (in camps/settlements)", 
                                          "IDPs (not in camps/settlements)" = "IDPs (not in camps/settlements)",
                                          "IDPs" = "IDPs"
                                          ),
                          ),
        checkboxGroupInput("filterIndicators", 
                           h3("Filter Indicators"), 
                           choices = list("8.5.2.male: Unemployment rate, by sex, age and persons with disabilities" = '8_5_2_male', 
                                          "8.5.2.female:	Unemployment rate, by sex, age and persons with disabilities" = '8_5_2_female', 
                                          "8.3.1.male:	Proportion of informal employment in non‑agriculture employment, by sex" = '8_3_1_male',
                                          "8.3.1.female:	Proportion of informal employment in non‑agriculture employment, by sex" = '8_3_1_female', 
                                          "7.1.1:	Proportion of population with access to electricity" = "7_1_1", 
                                          "6.1.1:	Proportion of population using safely managed drinking water services" = "6_1_1",
                                          "4.1.1.c.ii: Proportion of children and young people: (a) in grades 2/3; (b) at the end of primary; and (c) at the end of lower secondary achieving at least a minimum proficiency level in (i) reading and (ii) mathematics, by sex" = "4_1_1_c_ii", 
                                          "4.1.1.c.i: Proportion of children and young people: (a) in grades 2/3; (b) at the end of primary; and (c) at the end of lower secondary achieving at least a minimum proficiency level in (i) reading and (ii) mathematics, by sex" = "4_1_1_c_i",
                                          "4.1.1.b.ii: Proportion of children and young people: (a) in grades 2/3; (b) at the end of primary; and (c) at the end of lower secondary achieving at least a minimum proficiency level in (i) reading and (ii) mathematics, by sex" = "4_1_1_b_ii", 
                                          "4.1.1.b.i: Proportion of children and young people: (a) in grades 2/3; (b) at the end of primary; and (c) at the end of lower secondary achieving at least a minimum proficiency level in (i) reading and (ii) mathematics, by sex" = "4_1_1_b_i", 
                                          "4.1.1.a.ii: Proportion of children and young people: (a) in grades 2/3; (b) at the end of primary; and (c) at the end of lower secondary achieving at least a minimum proficiency level in (i) reading and (ii) mathematics, by sex" = "4_1_1_a_ii",
                                          "4.1.1.a.i: Proportion of children and young people: (a) in grades 2/3; (b) at the end of primary; and (c) at the end of lower secondary achieving at least a minimum proficiency level in (i) reading and (ii) mathematics, by sex" = "4_1_1_a_i",
                                          "3.2.1: Under-five mortality rate" = "3_2_1",
                                          "2.2.1:	Prevalence of stunting (height for age" = "2_2_1",
                                          "1.4.2.b:	Proportion of total adult population with secure tenure rights to land, (a) with legally recognized documentation, (b) who perceive their rights to land as secure, by sex and type of tenure" = "1_4_2_b",
                                          "1.4.2.a: Proportion of total adult population with secure tenure rights to land, (a) with legally recognized documentation, (b) who perceive their rights to land as secure, by sex and type of tenure" = "1_4_2_a",
                                          "1.2.1:	Proportion of population living below the national poverty line, by sex and age" = "1_2_1",
                                          "16.9.1: Proportion of children under 5 years of age whose births have been registered with a civil authority, by age" = "16_9_1",
                                          "16.1.4:	Proportion of population that feel safe walking alone around the area they live" = "16_1_4",
                                          "11.1.1:	Proportion of urban population living in slums, informal settlements or inadequate housing" = "11_1_1"
                                          ),
                          ),
        ),
        
          column(8,
              h2("Map"),
              leafletOutput("mymap", height="85vh"),
              "Basic needs and living conditions",
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

    observe({
   
      if(nrow(indicators) > 0) {
          
          leafletProxy("mymap") %>%
            setView(lng = 0, lat = 0, zoom = 2.5) %>%
            #clearMarkers() %>%
            addCircleMarkers(layerId = indicators$id, lng = indicators$longitude, 
                              lat = indicators$latitude, radius =8, stroke=FALSE, color = "blue", 
                              fillOpacity = 0.4, 
                              popup = paste("<h5><b>Country:</b>", 
                              indicators$countries_name, "</h5>",
                              "<h5><b>Indicators :</b>", indicators$indicator_num , "</h5>"))
      } else {
        leafletProxy("mymap") %>%
          setView(lng = 0, lat = 0, zoom = 2.5)
      }
    
    })
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
