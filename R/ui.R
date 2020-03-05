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
      padding:5px;
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
      border-top: 5px solid #ccc;
      border-color: #0072BC;
      height: 10px; 
    }
    
    .checkbox { 
      background: #cce3f2; 
    }
      
    .checkbox:nth-child(odd) { 
      background: white; 
    }
    
    table.dataTable tr:nth-child(even) {
      background: #cce3f2;
    }
    
    table.dataTable tr:nth-child(odd) {
      background: white;
    }
    
    table.dataTable th {
      background-color: #0072BC !important;
      color: white;
      height: 30px; 
    }
     
    #downloadSDGByIndicator {
      color: #0072BC !important;
      border-color: #0072BC;
    }
    
    #downloadSDGBySubset {
      color: #0072BC !important;
      border-color: #0072BC;
    }
    
    .navbar-default {
      background-color: #0072BC!important;
      color: white!important;
    }
    
    #navbar_country {
     color: white !important;
     background-color: #0072BC!important;
     width: 300px;
    }
    
    button.dt-button, div.dt-button, a.dt-button{ 
      background:white;
      color: #0072BC!important;
      border-color: white;
      font-weight: bold;
   } 
                   
    
    "),
    
    useShinyjs(),  # Set up shinyjs
    ## navbarPage
    fluidPage(
      fluidRow(
        column(3,
               div(class="panel",
                   # Control Panel for the indicators
                   h3("DISAGGREGATED DATA"),
                   hr(),
                   h4("Availability by Location"),
                   selectizeInput(
                     "country", 
                     "",
                     countries_list(), 
                     options = list(
                       placeholder = "Select a Country", 
                       onInitialize = I('function() { this.setValue(""); }')
                     )
                   ),
                   
                   sliderInput("years",
                               h4("Filter Year"), 
                               min = min(years()),
                               max = max(years()),
                               value = c(min(years()), max(years())),
                               sep = ""
                   ),
                   
                   checkboxGroupInput("filterSubsets", 
                                      h4("Filter Subsets"),, 
                                      choices = subsets_list(),  
                                      selected = subsets_list(),
                   ),
                   div(class="indicator_checkbox",
                       checkboxGroupInput("filterIndicators", 
                                          h4("Filter Indicators"), 
                                          choices = sdg_list(),
                                          selected = sdg_list(),
                       ),
                   ),
               )
        ),
        
        column(9,
               
               
               br(),
               
               div(id='mainmap',
                   leafletOutput("mymap", height="85vh"),
               ),
               br(),
               shinyjs::hidden(
                 div(id="available_data",
               navbarPage(title=htmlOutput("navbar_country"),
              ##########################################
              # AVAILABLE DATA PAGE
              ##########################################
              tabPanel("AVAILABLE DATA",
                          
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
                              htmlOutput("info_indicators"),
                              hr(),
                              
                              DT::dataTableOutput("tableTab1"),
                              br(),
                              hr(),
                              br(),
                              column(8, 
                                     
                                     plotOutput("chart"),
                                     plotOutput("chartSdgsGroup")
                              ),
                           
                              column(4,
                                     
                               
                                     
                                       div(style="display: inline-block;vertical-align:top; width: 200px; ", id="sdgfilter",
                                           
                                           selectizeInput("sdgChartFilter", 
                                                          h5("Filter Indicators"), 
                                                          choices = sdg_code_list(),
                                                          selected = sdg_code_list()[[1]]
                                           ),
                                           downloadButton('downloadSDGByIndicator', 'Download Plot')
                                       
                                     ),
                                   
                                       div(style="vertical-align:top; width: 200px; padding-top: 300px;", id="groupfilter",
                                           selectizeInput("groupChartFilter", 
                                                          h5("Filter Subsets"), 
                                                          choices = subsets_list(),
                                                          selected = subsets_list()[[1]]
                                           ),
                                           downloadButton('downloadSDGBySubset', 'Download Plot')
                                       )
                                     
                              )
                              
                            )
            
                          ),
               ##########################################
               # METADATA PAGE
               ##########################################
               
               tabPanel("METADATA"),
               tabPanel("x")
               )
              )
            )
        )
      )      
    )
  )
    