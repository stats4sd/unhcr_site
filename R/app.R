library(shiny)
library(leaflet)
library(DT)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(shinyjs)
source('data.R')

options(shiny.host = '127.0.0.1')
options(shiny.port = 8002)

shinyApp(
  ui = tagList(
    tags$head(
    ),
    useShinyjs(),  # Set up shinyjs
    ## navbarPage
    fluidPage(
      fluidRow(
        column(4,
               # Control Panel for the indicators
               h3("DISAGGREGATED DATA", align = "center", style = "color:blue"),
               h4("Availability by Location", align = "center", style = "color:blue"),
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
                                  choices = subsets_list,     
               ),
               checkboxGroupInput("filterIndicators", 
                                  h3("Filter Indicators"), 
                                  choices = sdg_list,
               ),
        ),
        
        column(8,
                br(),
               
                leafletOutput("mymap", height="85vh"),
                br(),
                absolutePanel( 

                p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                DT::dataTableOutput("tableTab1"),
                column(4, 

                  shinyjs::hidden(
                    div(style="display: inline-block;vertical-align:top; width: 200px; ", id="sdgfilter",
                      selectizeInput("sdgChartFilter", 
                                      h5("Filter Indicators"), 
                                      choices = sdg_code_list,
                                      selected = sdg_code_list[[1]]
                                    )
                      )
                  ),
                  shinyjs::hidden(
                    div(style="vertical-align:top; width: 200px; padding-top: 300px;", id="groupfilter",
                      selectizeInput("groupChartFilter", 
                                      h5("Filter Subsets"), 
                                      choices = subsets_list,
                                      selected = subsets_list[[1]]
                                      )                  
                      )
                  )
                ),
                column(8,
                    plotOutput("chart"),
                    plotOutput("chartSdgsGroup")
                  )
                ),
        )
      )      
    )
  ),
  server = function(input, output, session) {
    # Create the map
    output$mymap <- renderLeaflet({
      leaflet() %>% addTiles() %>% addProviderTiles("Esri.WorldStreetMap") %>%
        addMiniMap(
          tiles = providers$Esri.WorldStreetMap,
          toggleDisplay = TRUE
        )
    })

    observe({
      req(input$filterIndicators)
      if(input$filterIndicators!=""){
        shinyjs::show(id = "groupfilter") 
        shinyjs::show(id = "sdgfilter") 
      }
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

    # Create a list of sdg selected from filter
    ChartGroupsSdg <- reactive ({
      req(input$sdgChartFilter)
      data<-selectedData()
      data <-subset(data, sdg_code == input$sdgChartFilter)

      return(data)

      })

    ChartSdgsGroup<- reactive ({
      req(input$groupChartFilter)
      data<-selectedData()
      data <-subset(data, group_name == input$groupChartFilter)

      return(data)

      })
    
    # Filter data by subsets
    selectedData <- reactive({
      req(input$country)
      req(input$filterSubsets)
      req(input$years)
      req(input$filterIndicators)
      data_table <- subset(indicators, country_code == input$country)  
      data_table <- data_table  %>% select(countries_name, group_name, year, sdg_code, indicator_value, description, population_definition, comment, latitude, longitude)
      if(!is.na(input$filterSubsets)){
        data_table <- subset(data_table, group_name %in% input$filterSubsets)  
      }
      if(input$filterIndicators!=""){
        data_table <- subset(data_table, sdg_code %in% input$filterIndicators)  
      }
      if(input$years!=""){
        data_table <- subset(data_table, year >= min(input$years) & year <= max(input$years) )  
      }
      
      return(data_table)
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
                           lat = (mixed$latitude-1), radius = mixed$indicator_num, stroke=FALSE, color = "#08306b", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         mixed$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         mixed$group_name,
                                         "<h5><b>Indicators n:</b>", mixed$indicator_num , "</h5>"
                           )) %>% 
          addCircleMarkers(layerId = refugees$id, lng = refugees$longitude, 
                           lat = refugees$latitude, radius = refugees$indicator_num, stroke=FALSE, color = "#08519c", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         refugees$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         refugees$group_name,
                                         "<h5><b>Indicators n:</b>", refugees$indicator_num , "</h5>"
                                         
                           )) %>% 
          addCircleMarkers(layerId = idps$id, lng = (idps$longitude+1), 
                           lat = idps$latitude, radius = idps$indicator_num, stroke=FALSE, color = "#2171b5", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         idps$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         idps$group_name,
                                         "<h5><b>Indicators n:</b>", idps$indicator_num , "</h5>"
                           )) %>%
          addCircleMarkers(layerId = isdps_not_camp$id, lng = (isdps_not_camp$longitude+1), 
                           lat = (isdps_not_camp$latitude+1), radius = isdps_not_camp$indicator_num, stroke=FALSE, color = "#4292c6", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         isdps_not_camp$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         isdps_not_camp$group_name,
                                         "<h5><b>Indicators n:</b>", idps$indicator_num , "</h5>"
                           )) %>%
          addCircleMarkers(layerId = isdps_camp$id, lng = isdps_camp$longitude, 
                           lat = (isdps_camp$latitude+1), radius = isdps_camp$indicator_num, stroke=FALSE, color = "#6baed6", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         isdps_camp$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         isdps_camp$group_name,
                                         "<h5><b>Indicators n:</b>", isdps_camp$indicator_num , "</h5>"
                           )) %>%
          addCircleMarkers(layerId = asylum_seekers$id, lng = (asylum_seekers$longitude+1), 
                           lat = (asylum_seekers$latitude-1), radius = asylum_seekers$indicator_num, stroke=FALSE, color = "#9ecae1", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         asylum_seekers$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         asylum_seekers$group_name,
                                         "<h5><b>Indicators n:</b>", asylum_seekers$indicator_num , "</h5>"
                           )) 
        
      
      } else if(input$country!=""){
        
        leafletProxy("mymap") %>%
          setView(lng = 0, lat = 0, zoom = 2.5) %>%
          clearMarkers() 
        }
    })
    
    observe({
      req(input$filterIndicators)
        data_maps <- selectedData()
        refugees <- subset(data_maps, group_name == "Refugees")
        idps <- subset(data_maps, group_name == "IDPs")
        isdps_not_camp <- subset(data_maps, group_name == "IDPs (not in camp/settlements)")
        isdps_camp <- subset(data_maps, group_name == "Asylum Seekers")
        asylum_seekers <- subset(data_maps, group_name == "Asylum Seekers")
        mixed <- subset(data_maps, group_name == "Mixed")
        leafletProxy("mymap") %>%
          setView(lng = 0, lat = 0, zoom = 2.5) %>%
          #clearMarkers() %>%
          addCircleMarkers(layerId = mixed$id, lng = mixed$longitude, 
                           lat = (mixed$latitude-1), radius = mixed$indicator_value*15, stroke=FALSE, color = "#08306b", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         mixed$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         mixed$group_name,
                                         "<h5><b>Indicators n:</b>", mixed$indicator_num , "</h5>"
                           )) %>% 
          addCircleMarkers(layerId = refugees$id, lng = refugees$longitude, 
                           lat = refugees$latitude, radius = refugees$indicator_value*15, stroke=FALSE, color = "#08519c", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         refugees$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         refugees$group_name,
                                         "<h5><b>Indicators n:</b>", refugees$indicator_num , "</h5>"
                                         
                           )) %>% 
          addCircleMarkers(layerId = idps$id, lng = (idps$longitude+1), 
                           lat = idps$latitude, radius = idps$indicator_value*15, stroke=FALSE, color = "#2171b5", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         idps$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         idps$group_name,
                                         "<h5><b>Indicators n:</b>", idps$indicator_num , "</h5>"
                           )) %>%
          addCircleMarkers(layerId = isdps_not_camp$id, lng = (isdps_not_camp$longitude+1), 
                           lat = (isdps_not_camp$latitude+1), radius = isdps_not_camp$indicator_value*15, stroke=FALSE, color = "#4292c6", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         isdps_not_camp$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         isdps_not_camp$group_name,
                                         "<h5><b>Indicators n:</b>", idps$indicator_num , "</h5>"
                           )) %>%
          addCircleMarkers(layerId = isdps_camp$id, lng = isdps_camp$longitude, 
                           lat = (isdps_camp$latitude+1), radius = isdps_camp$indicator_value*15, stroke=FALSE, color = "#6baed6", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         isdps_camp$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         isdps_camp$group_name,
                                         "<h5><b>Indicators n:</b>", isdps_camp$indicator_num , "</h5>"
                           )) %>%
          addCircleMarkers(layerId = asylum_seekers$id, lng = (asylum_seekers$longitude+1), 
                           lat = (asylum_seekers$latitude-1), radius = asylum_seekers$indicator_value*15, stroke=FALSE, color = "#9ecae1", 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         asylum_seekers$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         asylum_seekers$group_name,
                                         "<h5><b>Indicators n:</b>", asylum_seekers$indicator_num , "</h5>"
                           )) 
    
    })
    
    ## 
    ## table in main page tab 1
    output$tableTab1 = DT::renderDataTable({
      DT::datatable(
        selectedData(),
        filter = 'top',
        extensions = 'Buttons',
        options = list(
          dom = 'Blfrtip',
          buttons = c(I('colvis'), 'csv', 'pdf'),
          text = 'Download',
          br()
        ),
        class = "display"
      )
    })
    
    ## Chart
    
    observe({


      output$chart <- renderPlot({
        charts <-ggplot(data = ChartGroupsSdg(), aes(x=year, y=indicator_value)) +
          geom_line(aes(color = group_name, linetype= group_name, fill="SDGs")) +
          geom_point(size = 3, alpha = 0.75) +
          labs(y="sdg indicators", x = "years")+
          ggtitle("SDG Indicator by indicator") +
          scale_x_continuous(breaks=years)
          charts <- charts +
           scale_fill_discrete(name = "New Legend Title")

        charts
      
      })

      output$chartSdgsGroup <- renderPlot({
        charts <-ggplot(data = ChartSdgsGroup(), aes(x=year, y=indicator_value)) +
          geom_line(aes(color = sdg_code, linetype= sdg_code)) +
          geom_point(size = 3, alpha = 0.75) +
          labs(y="sdg indicators", x = "years")+
          ggtitle("SDG Indicators by Subset") +
          scale_x_continuous(breaks=years)
          
        charts
      
      })
      
    })
    
    ##end server
  }
)