library(shiny)
library(leaflet)
library(DT)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(shinyjs)
library(rgdal)
source('data.R')

options(shiny.host = '127.0.0.1')
options(shiny.port = 8002)


shinyApp(
  ui = tagList(
    tags$style("
    .irs-bar {
      height: 8px;
      top: 25px;
      border-top: 1px solid black;
      border-bottom: 1px solid #428bca;
      background: #0072BC;
    }
    
    .irs-from, .irs-to, .irs-single {
        color: #fff;
        font-size: 11px;
        line-height: 1.333;
        text-shadow: none;
        padding: 1px 3px;
        background: #428bca;
        border-radius: 3px;
        -moz-border-radius: 3px;
    }
    
    "),
    useShinyjs(),  # Set up shinyjs
    ## navbarPage
    fluidPage(
      fluidRow(
        column(4,
               # Control Panel for the indicators
               h3("DISAGGREGATED DATA", align = "center", style = "color:#0072BC"),
               h4("Availability by Location", align = "center", style = "color:#0072BC"),
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
                           value = c(min(years), max(years)),
                           sep = ""
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
      leaflet() %>% addTiles() %>% addProviderTiles("Esri.WorldStreetMap")
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
        data_table <- subset(data_table, year >= min(input$years) & year <= max(input$years))  
      }
      return(data_table)
    })
    
    # Update the Subsets after the filter country has been selected
    
    observe({
      req(input$country)
      filter_by_country <- subset(indicators, country_code == input$country)  
      filter_by_country <- filter_by_country  %>% select(countries_name, group_name, year, sdg_code, sdg_description)
      subsets_list <- sort(unique(setNames(filter_by_country$group_name,as.character(filter_by_country$group_name))))
  
      updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', choices = subsets_list)

      })
    
    # Update Indicators CheckboxGroupinput after the filter Subsets has been selected
    
    observe({
      req(input$country)
      req(input$filterSubsets)
      filter_by_country <- subset(indicators, country_code == input$country)  
      filter_by_country <- filter_by_country  %>% select(countries_name, group_name, year, sdg_code, sdg_description)
        filter_by_subsets <- subset(filter_by_country, group_name %in% input$filterSubsets) 
        sdg_list <- setNames(unique(filter_by_subsets$sdg_code),as.character(paste(unique(filter_by_subsets$sdg_code), unique(filter_by_subsets$sdg_description), sep=': ')))
        sdg_list[!is.na(sdg_list)]
        sdg_list <- sort(sdg_list)
        
        updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', choices = sdg_list)
        
    })
  
    
    observe({
      
      if(input$country=="") {

        leafletProxy("mymap") %>%
          setView(lng = 0, lat = 0, zoom = 2.5) %>%
          addCircleMarkers(lng = indicators_map$longitude, 
                           lat = indicators_map$latitude, radius = 10, stroke=FALSE, color = indicators_map$color, 
                           fillOpacity = 0.6, 
                           popup = paste("<h5><b>Country:</b>", 
                                         indicators_map$countries_name, "</h5>",
                                         "<h5><b>Subset:</b>",
                                         indicators_map$group_name,
                                         "<h5><b>Indicators n:</b>", indicators_map$indicator_num , "</h5>"
                           )) %>% 
          addLegend("bottomright",
                    colors = unique(indicators_map$color),
                    labels = unique(indicators_map$group_name),
                    opacity = 0.6)
          
      } else if(input$country!=""){
        
        leafletProxy("mymap") %>%
          setView(lng = 0, lat = 0, zoom = 2.5) %>%
          clearMarkers()
        }
    })
    
    observe({
      req(input$filterIndicators)
        data_maps <- selectedData()
         
        leafletProxy("mymap") %>%
          setView(lng = 0, lat = 0, zoom = 2.5) %>%
        addCircleMarkers(lng = data_maps$longitude, 
                         lat = data_maps$latitude, radius = 10, stroke=FALSE, color = "blue", 
                         fillOpacity = 0.6, 
                         popup = paste("<h5><b>Country:</b>", 
                                       data_maps$countries_name, "</h5>",
                                       "<h5><b>Subset:</b>",
                                       data_maps$group_name,
                                       "<h5><b>Description:</b>", data_maps$description , "</h5>"
                         )) 
    })
    
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
          geom_line(aes(color = group_name, linetype= group_name)) +
          geom_point(aes(color = group_name), size = 3, alpha = 0.75) +
          labs(y="sdg indicators", x = "years")+
          ggtitle("SDG Indicator by indicator") +
          scale_x_continuous(breaks=years)+
          scale_y_continuous(limits =c(0,1))+
          scale_color_discrete("SubSet")+
          scale_linetype("SubSet")+
          theme(text = element_text(size = 16))

        charts
      
      })

      output$chartSdgsGroup <- renderPlot({
        charts <-ggplot(data = ChartSdgsGroup(), aes(x=year, y=indicator_value)) +
          geom_line(aes(color = sdg_code, linetype= sdg_code)) +
          geom_point(aes(color = sdg_code), size = 3, alpha = 0.75) +
          labs(y="sdg indicators", x = "years")+
          ggtitle("SDG Indicators by Subset") +
          scale_x_continuous(breaks=years)+
          scale_y_continuous(limits =c(0,1))+
          scale_color_discrete("SDG")+
          scale_linetype("SDG")+
          theme(text = element_text(size = 16))
          
        charts
      
      })
      
    })
    
    ##end server
  }
)