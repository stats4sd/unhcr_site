
options(shiny.host = '127.0.0.1')
options(shiny.port = 8002)
jscode <- "shinyjs.refresh = function() { location.reload(); }"
  ui <- tagList(
    tags$style(HTML("
    body, html {
    font-family: proxima-nova, sans-serif;
    font-weight: 400;
    font-style: normal;
    }
    
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
    
    .shiny-input-container:not(.shiny-input-container-inline) {
      width: 100%;
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
      color: #0072BC;
      font-weight: 450;
    }

    h3 {
      color: #0072BC;
      font-weight: bold;
      text-align: center;
      font-size: 27px;
    }

    
    hr {
      display: block;
      border-top: 3px solid #ccc;
      border-color: #0072BC;
      height: 10px;
      margin-bottom: 0px;
    }

    .checkbox, .radio {
      position: relative;
      display: block;
      margin-top: 10px;
      padding-bottom: 3px;
      padding-top: 3px;
      background: #EFF6FB;
      
    }
    
   .checkbox + .checkbox, .radio + .radio {
      margin-top: 0px;
    }

    .checkbox:nth-child(odd) { 
      background: white; 
    }
    
    #select_all_group_id{
     background: #EFF6FB;
    }
    
    table.dataTable tr:nth-child(even) {
      background: #EFF6FB;
    }
   
    table.dataTable.display tbody tr.odd {
      background-color: white;
    }
     
    
    
    table.dataTable table.dataTable tr:nth-child(odd) {
    background-color: #EFF6FB !important;
    }
    
    table.dataTable th {
      background-color: #0072BC !important;
      color: white;
      height: 30px; 
    }
    
    .dataTables_wrapper {
      position: relative;
      clear: both;
      *zoom: 1;
      zoom: 1;
      overflow-x: scroll;
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
     width: 200px;
    }
    
    .container-fluid > .nav > li > a[data-value='AVAILABLE INDICATORS']{
      background-color: #0072BC;   
      color:white;
    } 
    
    .container-fluid > .nav > li > a[data-value='AVAILABLE INDICATORS']:hover{
      background-color: #4089c8;   
      color:white;
    }  
    
    .container-fluid > .nav > li > a[data-value='ADDITIONAL INFORMATION']{
      background-color: #0072BC;   
      color:white;
    }  
   .container-fluid > .nav > li > a[data-value='ADDITIONAL INFORMATION']:hover{
      background-color: #4089c8;   
      color:white;
    }  
    
    .container-fluid > .nav > li > a[data-value='refresh']{
      background-color: #0072BC;   
      color:white;
      
    }
    
    .container-fluid > .nav > li > a[data-value='refresh']:hover{
      background-color: #4089c8;   
      color:white;
    }  
    
    button.dt-button, div.dt-button, a.dt-button{ 
      background:white;
      color: #0072BC!important;
      border-color: white;
      font-weight: bold;
    } 
    
  
    ")),
    
    useShinyjs(),  # Set up shinyjs
    extendShinyjs(text = jscode, functions = "refresh"),
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
                     countries_list(), 
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
                   h4("Filter Groups"),
                   div(id="select_all_group_id",
                   checkboxInput('select_all_groups', 'Select All', value = TRUE)
                   ),
                   checkboxGroupInput("filterSubsets", 
                                      label = NULL,
                                      choices = subsets_list(NULL),  
                                      selected = subsets_list(NULL),
                   ),
                   h4("Filter Subgroups"), 
                   checkboxInput('select_all_subgroups', 'Select All', value = TRUE),
                   checkboxGroupInput("filterSubgroups", 
                                      label = NULL,
                                      choices = subgroup_list(NULL),  
                                      selected = subgroup_list(NULL),
                   ),
                   div(class="indicator_checkbox",
                       h4("Filter Indicators"), 
                       checkboxInput('select_all_sdg', 'Select All', value = TRUE),
                       checkboxGroupInput("filterIndicators", 
                                          label = NULL,
                                          choices = sdg_list(NULL),
                                          selected = sdg_list(NULL),
                       ),
                   ),
               )
        ),
        
        column(8,
              
               
               div(id='mainmap',
                   leafletOutput("mymap", height="85vh"),
               ),
               br(),
               shinyjs::hidden(
                 div(id="available_data",
               navbarPage(title=htmlOutput("navbar_country"), id = "countrybar", 
              ##########################################
              # AVAILABLE INDICATORS PAGE
              ##########################################
              tabPanel("AVAILABLE INDICATORS",
                          
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
                              HTML("<h4 style='color:black; padding-top:30px;'><b>Overall Summary</b></h4>"),
                              htmlOutput("info_indicators"),
                              HTML("<h5 style='color:#0072BC;'><i class='fa fa-info-circle' style='font-size:24px; color: #0072BC;'></i><b> Notes:</b></h5>
                                   <p>It is vital to understand the context of the source data when considering the indicators 
                                   given below. Please refer to the <b>Additional Information</b> tab for details of the scope, 
                                   coverage, limitations and other factors that may affect the relevance, accurancy or
                                   applicability of the indicator information provided.</p>
                                   "),
                              hr(),
                              HTML("<h4 style='color:black; padding-top:30px;'><b>Explore Available Indicators</b></h4>"),
                              HTML("<div class='alert alert-info', style='width:90%;'>
                                  Use the options in the left-hand column to filter the indicators displayed below by years, 
                                  group or SDG indicator</div>"
                              ),
                              HTML("<h5><b>Tabulated Data</h5></b>"),
                              DT::dataTableOutput("tableTab1"),
                              hr(),
                              HTML("<h5><b>Charts</b></h5>"),
                              br(),
                              HTML("<div class='alert alert-info', style='width:90%;'>
                                  Use the options in the left-hand column to filter the indicators displayed below by years, 
                                  group or SDG indicator</div>"
                              ),
                  
                              column(8, 
                                     
                                     plotOutput("chart"),
                                     br(),
                                     br(),
                                     plotOutput("chartSdgsGroup"),
                                     
                                     HTML("<div class='alert alert-info', style='width:90%; margin-top:25px;'>
                                            <b>Note</b>: where there are multiple values for the same indicator, 
                                            goup and year, this is where we have multiple datasets giving different
                                            figures. In most cases, these are from sources with different population 
                                            coverage. You can review the details in the Addition Information tab to 
                                            understand more about how these values were derived.
                                            </div>
                                          "),
                              ),
                              
                              column(4,
                                     
                               
                                     
                                       div(style="display: inline-block;vertical-align:top; width: 200px; ", id="sdgfilter",
                                           
                                           selectizeInput("sdgChartFilter",
                                                          label = NULL,
                                                         # h5("Filter Indicators"), 
                                                          choices = sdg_code_list(),
                                                          selected = sdg_code_list()[[1]]
                                           ),
                                           downloadButton('downloadSDGByIndicator', 'Download Plot')
                                       
                                     ),
                                    
                                     
                                   
                                       div(style="vertical-align:top; width: 200px; padding-top: 300px; margin-top:50px;", id="groupfilter",
                                           selectizeInput("groupChartFilter", 
                                                          label = NULL,
                                                          #h5("Filter Subsets"), 
                                                          choices = subsets_list(NULL),
                                                          selected = subsets_list(NULL)[[1]]
                                           ),
                                           downloadButton('downloadSDGBySubset', 'Download Plot')
                                       )
                                     
                              )
                              
                            )
            
                          ),
               ##########################################
               # ADDITIONAL INFORMATION TAB
               ##########################################
               
               tabPanel("ADDITIONAL INFORMATION",
                        HTML("<h4 style='color:black; padding-top:30px;'><b>Additional Information</b></h4>
                              <p>Here you can find important metadata and other information regarding the datasets used
                              to provide SDG indicator values and how those values were derived. This may include general comments, 
                              warnings and scripts used to make calculations where applicabile.</p>
  
                            "),
                        hr(),
                        htmlOutput("additional_info"),
                        ),
                  
               tabPanel("Return to Map   X", value = "refresh")
               )
              )
            )
        )
      )      
    )
  )
    