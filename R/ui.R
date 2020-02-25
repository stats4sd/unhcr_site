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

  ui <- tagList(
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
    
    div.panel {
      width: 100%;
      height: 900px;
      overflow: auto;
      float:left;
      padding:10px;
    }
    
    div.main_panel {
      width: 100%;
      height: 900px;
      overflow: auto;
    }
    
    h4 {
      color:#0072BC;
      font-weight: bold;
    }
    
    h3 {
      color:#0072BC;
      font-weight: bold;
       align:center;
    }
    
    hr{
       
      display: block; 
      height: 5px;
      border-top: 1px solid #ccc;
      border-color: #0072BC;
       
    }
    
    .checkbox { 
      background: #cce3f2; 
    }
      
    .checkbox:nth-child(odd) { 
      background: white; 
      }
  
    "),
    useShinyjs(),  # Set up shinyjs
    ## navbarPage
    fluidPage(
      fluidRow(
        column(4,
               div(class="panel",
                   # Control Panel for the indicators
                   h3("DISAGGREGATED DATA"),
                   hr(),
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
                               h4("Filter Year"), 
                               min = min(years),
                               max = max(years),
                               value = c(min(years), max(years)),
                               sep = ""
                   ),
                   
                   checkboxGroupInput("filterSubsets", 
                                      h4("Filter Subsets"),, 
                                      choices = subsets_list,  
                                      selected = subsets_list,
                   ),
                   div(class="indicator_checkbox",
                       checkboxGroupInput("filterIndicators", 
                                          h4("Filter Indicators"), 
                                          choices = sdg_list,
                                          selected = sdg_list,
                       ),
                   ),
               )
        ),
        
        column(8,
               
               
               br(),
               
               div(id='mainmap',
                   leafletOutput("mymap", height="85vh"),
               ),
               br(),
               
               absolutePanel( class="main_panel",
                              
                              imageOutput("imageSdg1",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg2",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg3",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg4",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg5",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg6",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg7",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg8",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg9",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg10",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg11",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg13",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg14",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg15",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg16",  width = "120px", height = "120px",  inline = TRUE ),
                              imageOutput("imageSdg17",  width = "120px", height = "120px",  inline = TRUE ),
                              
                              p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                              DT::dataTableOutput("tableTab1"),
                              column(4, 
                                     
                                     shinyjs::hidden(
                                       div(style="display: inline-block;vertical-align:top; width: 200px; ", id="sdgfilter",
                                           selectizeInput("sdgChartFilter", 
                                                          h5("Filter Indicators"), 
                                                          choices = sdg_code_list,
                                                          selected = sdg_code_list[[1]]
                                           ),
                                           downloadButton('downloadSDGByIndicator', 'Download Plot')
                                       )
                                     ),
                                     shinyjs::hidden(
                                       div(style="vertical-align:top; width: 200px; padding-top: 300px;", id="groupfilter",
                                           selectizeInput("groupChartFilter", 
                                                          h5("Filter Subsets"), 
                                                          choices = subsets_list,
                                                          selected = subsets_list[[1]]
                                           ),
                                           downloadButton('downloadSDGBySubset', 'Download Plot')
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
  )
    