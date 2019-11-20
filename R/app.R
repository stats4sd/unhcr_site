library(shiny)
library(leaflet)
library(DT)
library(ggvis)
library(dplyr)
library(RColorBrewer)
source('data.R')


options(shiny.host = '127.0.0.1')
options(shiny.port = 8001)


shinyApp(
  ui = tagList(
    tags$head(
      # style for the page
      tags$style(
#       HTML(
#          ".dt-button.buttons-columnVisibility {
#              background: #FF0000 !important;
#              color: white !important;
#              opacity: 0.5;
#           }
#        .dt-button.buttons-columnVisibility.active {
#              background: black !important;
#              color: white !important;
#              opacity: 1;
#           }"
#        )
      )
    ),
    ## navbarPage 
    navbarPage(
      theme = shinythemes::shinytheme("cosmo"),
    
      "Charts Wash Data",
      tabPanel("Available Data",
               h2("Data available into database"),
               leafletOutput("available_map"),
      ),
      tabPanel("SDG",
            
        # Control Panel for the indicators 
        sidebarPanel(
          h5("Control chart simulation"),
          sliderInput("n",
                      "Number of samples per month:",
                      min = 1,
                      max = 200,
                      value = 30),
          sliderInput("reps",
                      "Number of sites to show in control chart:",
                      min = 1,
                      max = 25,
                      value = 1),
          sliderInput("m",
                      "Number of months to show:",
                      min = 12,
                      max = 48,
                      value = 24),
          numericInput("p",
                       "True defect rate (which of course is unknown in the real world)",
                       min = 0, max = 1, step = 0.01,
                       value = 0.15),
          numericInput("thresh",
                       "Target maximum defect rate",
                       min = 0, max = 1, step = 0.01,
                       value = 0.10),
          p(
            "This is a simulation of a quality control exercise across multiple sites for
12 to 60 months where defect is a binary attribute.  Choose the parameters 
above to see the impact of different 
sample size, number of sites, true defect rate, etc.  It is assumed
that the true defect rate does not change over time or between sites.")

        ),
        mainPanel(
          tabsetPanel(
          # Map
            tabPanel("Map",
              h2("Map"),
              leafletOutput("map"),
              
              
            ),
            tabPanel("Basic needs and living conditions", 
                     # Description of the table
                     h2('Basic needs and living conditions'),
                     "Description of the table",
                     # Dispaly the table 
                     DT::dataTableOutput("tableTab1")
                     ),
            tabPanel("Livelihoods and economic self-reliance", 
                     # Description of the table
                     h2('Livelihoods and economic self-reliance'),
                     "Description of the table",
                     # Dispaly the table 
                     DT::dataTableOutput("tableTab2")
                     
            ),
            tabPanel("Civil, political and legal rights", 
                     # Description of the table
                     h2('Civil, political and legal rights'),
                     "Description of the table",
                     # Dispaly the table 
                     DT::dataTableOutput("tableTab3")
                     
            ),
            tabPanel("Charts", 
                     #Description of the charts
                     h3('Charts example'),
                     "Description of the charts",
                     ggvisOutput("controlChart"),
                     h3("A single site's narrowing confidence interval for defect rate"),
                     ggvisOutput("ribbonChart")
                     
                     )
          )
        )
      )
      #tabPanel("Navbar 3", "This panel is intentionally left blank")
    )
  ),
  server = function(input, output) {
    output$txtout <- renderText({
      paste(input$txt, input$slider, format(input$date), sep = ", ")
    })
    output$table <- renderTable({
      head(cars, 4)
    })
    
    
    # Create the map
    output$map <- renderLeaflet({
      leaflet(quakes, options = leafletOptions(minZoom = 1)) %>%
        
        setView(lng = 25, lat = 26, zoom = 3) %>% 
        # adds different details for the map
        addTiles() %>% 
        # adds marks 
        addMarkers(data=quakes, clusterOptions = markerClusterOptions()) %>% 
        # adds label only markers
        addMarkers(data=quakes,
                            lng=~long, lat=~lat,
                            
                            
                            popup= paste("<h5><strong>","Country name","</strong></h5>",
                                  "<b>Indic1:</b>", quakes$mag, "<br>",
                                   "<b>Indic2:</b>", quakes$stations, "<br>",
                                   "<b>Indic3:</b>", quakes$depth, "<br>",
                                   "<b>Indic4:</b>", quakes$long),
                          
                           
                            clusterOptions = markerClusterOptions(removeOutsideVisibleBounds = F),
                            labelOptions = labelOptions(noHide = T,
                                                        direction = 'top',
                            style = list(
                              "color" = "red",
                              "font-family" = "serif",
                              "font-style" = "italic",
                              "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                              "font-size" = "12px",
                              "border-color" = "rgba(0,0,0,0.5)"
                              )
                            )
                          )
    })
    ## table in main page tab 1
    output$tableTab1 = DT::renderDataTable({
      DT::datatable(
        indicator_table1,
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
    ## table in main page tab 2
    output$tableTab2 = DT::renderDataTable({
      DT::datatable(
        indicator_table2,
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
    
    ## table in main page tab 3
    output$tableTab3 = DT::renderDataTable({
      DT::datatable(
        indicator_table3,
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
    
    
    # Charts in main page tab 4
    samp_data <- reactive({
      # generate some random data
      samp <- data.frame(defects = rbinom(input$m * input$reps, input$n, input$p), 
                         month = 1:input$m,
                         run = as.factor(rep(1:input$reps, each = input$m)),
                         n = input$n)  %>%
        mutate(defectsp = defects / n)
      
      
    })
    
    samp_data_plus <- reactive({
      # add the thresholds based on standard deviations, etc
      
      # overall limits, based on null hypothesis of true rate is the target:
      sigma <- sqrt(input$thresh * (1 - input$thresh) / input$n)
      upper <- input$thresh + 3 * sigma
      
      # create a data frame of the simulated data plus thresholds etc
      tmp <- samp_data() %>%
        # add the overall limits:
        mutate(upper = upper,
               thresh = input$thresh) %>%
        # add the cumulative results for each run including confidence intervals:
        group_by(run) %>%
        mutate(meandefectsp = mean(defectsp),
               cumdefects = cumsum(defects),
               cumn = cumsum(n),
               cumdefectp = cumdefects / cumn,
               cumsigma = sqrt(cumdefectp * (1 - cumdefectp) / cumn),
               cumupper = cumdefectp + 1.96 * cumsigma,
               cumlower = cumdefectp - 1.96 * cumsigma)
      
      return(tmp)
      
    })
    
    # draw the two charts:
    samp_data_plus %>%
      ggvis(x = ~month, y = ~defectsp, stroke = ~run) %>%
      layer_lines() %>%
      layer_points(fill = ~run) %>%
      layer_lines(y = ~upper, stroke := "black", strokeDash := 6, strokeWidth := 3) %>%
      layer_lines(y = ~thresh, stroke := "black", strokeWidth := 3) %>%
      hide_legend(scales = "stroke") %>%
      hide_legend(scales = "fill") %>%
      add_axis("y", title = "Proportion of defects", title_offset = 50) %>%
      bind_shiny("controlChart")
    
    samp_data_plus %>%
      filter(run == 1) %>%
      ggvis(x = ~month) %>%
      layer_ribbons(y = ~cumupper, y2 = ~cumlower, fill := "grey") %>%
      layer_lines(y = ~thresh, stroke := "black", strokeWidth := 3) %>%
      add_axis("y", title = "Proportion of defects", title_offset = 50) %>%
      bind_shiny("ribbonChart")
    
    #Create Available data map
    output$available_map <- renderLeaflet({
      leaflet(quakes, options = leafletOptions(minZoom = 1)) %>%
        
        setView(lng = 25, lat = 26, zoom = 3) %>% 
        # adds different details for the map
        addTiles() 
        
        
    })
    
    
    
    ##end server
  }
)
