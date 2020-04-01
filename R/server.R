
server = function(input, output, session) {
  indicators_map<-load_indicators_map()  
  
  #####################################
  # refresh page when click on back to the map
  #####################################
  observe({
    if (input$countrybar == "refresh") {
      js$refresh();
    }
  })
  
  #####################################
  # load indicators and maps info
  #####################################
  observe({
    req(input$country)
    indicators <- load_indicators(input$country)   
  })
  
  #####################################
  # Info diplayed below Sdg image
  #####################################
  observe({
    req(input$country)
    indicators_country <- indicators_map %>% filter(country_code == input$country)
    output$info_indicators <- renderUI({ 
     
      HTML(paste0(
        "<b>Number of Indicators Availble: </b>",indicators_country$indicator_num, "<br>",
        "<b>Population Definitions: </b>",indicators_country$population_definition, "<br>",
        "<br><b>Data sources: </b>", "<br>", indicators_country$source_url,
        "<br>"
      ))
    
    })
  })
  #####################################
  # Info diplayed in Additional info Tab
  #####################################
  observe({
    req(input$country)
    datasets <- load_dataset(input$country) 
    scripts_used <- c()
    for (id in datasets$id) {
      
      #scripts_used <- append(scripts_used, additional_info_download(id));  
      
    }
    

    datasets$scripts_used <- scripts_used;
   
    output$additional_info <- renderUI({ 
     
      HTML(paste0(
        "<h4><b>",datasets$description,"</b></h4><br>",
        "<h5><b>Population Definitions: </b>","<br></h5>","<a href=", datasets$source_url,">", datasets$source_url,"</a>","<br>",
        "<h5><b>Comments: </b></h5>",datasets$comment, "<br>",
       #"<h5><b>Scripts Used: </b></h5>",datasets$scripts_used, "<br>",
        "<hr>"
      ))
      
    })
  })
  
  #####################################
  # Country Name in navbar
  #####################################
  
  observe({
    req(input$country)
    indicators_country <- indicators_map %>% filter(country_code == input$country)
    output$navbar_country <- renderUI({ 
      HTML(paste0(
        "<b>", toupper(indicators_country$countries_name), "</b>"
      ))
    })
  })

  #####################################
  # Images SDG
  #####################################
  observe({
    req(input$country)
    #clean the image sdg displayed 
    for (i in 1:16){
      image_sdg_number <- paste("imageSdg",i, sep = "")
      output[[image_sdg_number]] <- NULL
    }
    data_selected <- selectedData()
    sdg_code<-unique(data_selected$sdg_code)
    
    for(indicator in sdg_code){
      sdg_number <- as.numeric(strsplit(indicator, ".", fixed = TRUE)[[1]][1])
      image_sdg_number <- paste("imageSdg",sdg_number, sep = "")
      output[[image_sdg_number]] <- show_image(sdg_number)
    }
  })
  
  #####################################
  # Output for downloading Charts
  #####################################
  
  output$downloadSDGByIndicator <- downloadHandler(
    filename = "chartSDGbyIndicator.png",
    content = function(file) {
      device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
      ggsave(file, plot = plotSdgByIndicator(), device = device)
    }
  )
  
  output$downloadSDGBySubset <- downloadHandler(
    filename = "chartSDGbySubset.png",
    content = function(file) {
      device <- function(..., width, height) grDevices::png(..., width = width, height = height, res = 300, units = "in")
      ggsave(file, plot = plotSdgBySubset(), device = device)
    }
    
  )
  
  #####################################
  # Creating Maps
  #####################################
  
  output$mymap <- renderLeaflet({
    leaflet() %>% addTiles( options = providerTileOptions(minZoom = 2, maxZoom = 10)) %>% 
      addProviderTiles("Esri.WorldStreetMap", options = providerTileOptions(minZoom = 2, maxZoom = 10))
  })
  
  #####################################
  # Show data when country had been 
  # selected
  #####################################
  observe({
    req(input$filterIndicators)
    if(input$country!=""){
      shinyjs::show(id = "available_data")
    }
  })
  
  #####################################
  # Create a list of sdg selected from 
  # filter GroupsSdg
  #####################################
  ChartGroupsSdg <- reactive ({
    req(input$sdgChartFilter)
    data <- selectedData()
    data <- subset(data, sdg_code == input$sdgChartFilter)
    
    return(data)
    
  })
  
  #####################################
  # Create a list of groups selected from 
  # filter SdgsGroup
  #####################################
  ChartSdgsGroup<- reactive ({
    req(input$groupChartFilter)
    data <- selectedData()
    data <- subset(data, group_name == input$groupChartFilter)
    
    return(data)
    
  })
  
  #####################################
  # Filter all indicators by filters in 
  # the control panel
  #####################################
  selectedData <- reactive({
    req(input$country)
    indicators_by_country <- indicators %>% filter(country_code == input$country)
    data_table <- indicators_by_country %>% select(countries_name, group_name, subgroup_name, year, sdg_code, sdg_description, indicator_value, description, population_definition, comment, latitude, longitude)
    if(length(input$filterSubsets)>1){
      data_table <- subset(data_table, group_name %in% input$filterSubsets)  
    }
    if(length(input$filterSubgroups)>1){
      data_table <- subset(data_table, subgroup_name %in% input$filterSubgroups & group_name %in% input$filterSubsets)  
    }
    if(length(input$filterIndicators)>=1){
      data_table <- subset(data_table, sdg_code %in% input$filterIndicators)  
    }
    if(length(input$years)>=1){
      data_table <- subset(data_table, year >= min(input$years) & year <= max(input$years))  
    }
    
    #update the selectInput for SDG Chart Filter
    sdg_code_list <- unique(data_table$sdg_code)
    updateSelectInput(session = session, inputId = 'sdgChartFilter', choices = sdg_code_list)
    
    #update the selectInput for Group Chart Filter
    subsets_list <- unique(data_table$group_name)
    updateSelectInput(session = session, inputId = 'groupChartFilter', choices = subsets_list)
    
    return(data_table)
  })
  
 
  #####################################
  # Update the Subsets, Subgroups and 
  # SDG indicators after the filter 
  # country has been selected
  #####################################
  observe({
    req(input$country)
 
    updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', choices = subsets_list(input$country), selected = subsets_list(input$country))
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubgroups', choices = subgroup_list(input$country), selected = subgroup_list(input$country))

    updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', choices = sdg_list(input$country), selected = sdg_list(input$country))
  
  })
  
 
  #####################################
  # Update checkboxGroup if the 
  # Select All is unticked/ticked
  #####################################
  observe({
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', selected = if(input$select_all_groups) subsets_list(NULL))
    updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', selected = if(!input$select_all_groups) FALSE)
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubgroups', selected = if(input$select_all_subgroups) subgroup_list(NULL))
    updateCheckboxGroupInput(session = session, inputId = 'filterSubgroups', selected = if(!input$select_all_subgroups) FALSE)
    
    updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', selected = if(input$select_all_sdg) sdg_list(NULL))
    updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', selected = if(!input$select_all_sdg) FALSE)
    
    })
  
  #####################################
  # Maps Attributes
  #####################################
  observe({
    
    if(input$country=="") {
      
      leafletProxy("mymap") %>%
        setView(lng = 0, lat = 0, zoom = 2.5) %>%
        addMarkers(lng = as.numeric(indicators_map$longitude), 
                   lat = as.numeric(indicators_map$latitude), 
                   icon = icons(iconUrl = indicators_map$icon_url,iconWidth = 34, iconHeight = 55, iconAnchorX = 17, iconAnchorY = 54),
                
                   popup = paste("<h5><b>Country:</b>", 
                                 indicators_map$countries_name, "</h5>",
                                 "<h5><b>Total number of indicators available:</b>", indicators_map$indicator_num , "</h5>",
                                 "<h5><b>Period covered:</b> ",indicators_map$min_year,"-",indicators_map$max_year, "</h5>",
                                 "<h5>Select the country in the filter to see the indicators</h5>"
                   )
                   ) %>% 
        addLegend("bottomright",
                  colors = c('#18375f','#0072bc', '#00b398'),
                  labels = c('IDPs', 'Refugees', 'Other'),
                  opacity = 0.6)
      
    } else if(input$country!=""){
      removeUI(selector = "#mainmap", session = session)
    }
    
  })
  
  #####################################
  # DataTable on Available Data
  #####################################
  output$tableTab1 = DT::renderDataTable(server = FALSE,{
    #select data from selectedData to display on the table 
    data_download<-selectedData()
    data_download<-data_download %>% select(sdg_code, countries_name, group_name, subgroup_name, year, indicator_value, description, population_definition)
    DT::datatable(
      data_download,
      colnames = c('SDG Indicator', 'Country', 'Group', 'Subgroup', 'Year', 'Indicator Value', 'Dataset', 'Population Definition'),
      extensions = 'Buttons',
      options = list(
        bSort=FALSE,
        dom = '<"float-left"B><"float-right"f>rt<"row"<"col-sm-4"i><"col-sm-4"l><"col-sm-4"p>>',
        buttons = list(list(extend = "csv", text = '<span class="glyphicon glyphicon-download-alt"></span>'),
                       list(extend = "copy", text = '<span>Copy</span>'), 
                       list(extend = "excel", text = '<span>Excel</span>'), 
                       list(extend = "pdf", text = '<span>PDF</span>'), 
                       list(extend = "print", text = '<span>Print</span>')),
        text = 'Download',
        br()
      ),
      class = "display"
    ) %>% 
      formatStyle('sdg_code', fontWeight = 'bold')
  })
 
  wrapper <- function(x, ...) 
  {
    paste(strwrap(x, ...), collapse = "\n")
  }
  
  #####################################
  # Create the plots for downloading
  #####################################
  plotSdgByIndicator<- reactive({
    data <- ChartGroupsSdg()
    charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
      geom_line(aes(color = group_name, linetype= group_name)) +
      geom_point(aes(color = group_name), size = 3, alpha = 0.75) +
      labs(y="SDG Indicator", x = "Year") +
      ggtitle(paste(data$countries_name," \n","SDG Indicator ",  data$sdg_code,"\n",wrapper(data$sdg_description[1], width = 60),"\n", sep = "")) +
      scale_x_continuous(breaks=years) +
      scale_y_continuous(limits =c(0,1)) +
      scale_linetype("Groups") +
      scale_color_manual("Groups",values=palette_indicators()) +
      theme(text = element_text(size = 16, family ="proxima-nova"), 
            plot.title = element_text(margin=margin(0,0,30,0),size = 14, face ="bold", family ="proxima-nova"),
            panel.background = element_blank(),
            panel.grid.major = element_line(colour = "grey"),
            axis.title.x = element_text(margin=margin(30,0,0,0)), 
            axis.title.y = element_text(margin=margin(0,30,0,0))
      )
  })
  
  plotSdgBySubset<- reactive({
    data <- ChartSdgsGroup()
    charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
      geom_line(aes(color = sdg_code, linetype= sdg_code)) +
      geom_point(aes(color = sdg_code), size = 3, alpha = 0.75) +
      labs(y="SDG Indicator", x = "Year")+
      ggtitle(paste(data$countries_name," \n","SDG Indicator for ",data$group_name," ",data$subgroup_name," ","\n", sep = "")) +
      scale_x_continuous(breaks=years)+
      scale_y_continuous(limits =c(0,1))+
      scale_linetype("SDG")+
      scale_color_manual("SDG",values=palette_indicators())+
      theme(text = element_text(size = 16, family ="proxima-nova"), 
            plot.title = element_text(margin=margin(0,0,30,0),size = 14, face ="bold", family ="proxima-nova"),
            panel.background = element_blank(),
            panel.grid.major = element_line(colour = "grey"),
            axis.title.x = element_text(margin=margin(30,0,0,0)), 
            axis.title.y = element_text(margin=margin(0,30,0,0))
      )
  })
  
  #####################################
  # Create the plots for diplaying 
  # on available data
  #####################################
  observe({
    data <- ChartGroupsSdg()
    output$chart <- renderPlot({
      charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
        geom_line(aes(color = group_name, linetype= group_name)) +
        geom_point(aes(color = group_name), size = 3, alpha = 0.75) +
        labs(y="SDG Indicator", x = "Year") +
        ggtitle(paste(data$countries_name," \n","SDG Indicator ",  data$sdg_code,"\n",wrapper(data$sdg_description[1], width = 60),"\n", sep = "")) +
        scale_x_continuous(breaks=years) +
        scale_y_continuous(limits =c(0,1)) +
        scale_linetype("Groups") +
        scale_color_manual("Groups",values=palette_indicators()) +
        theme(text = element_text(size = 16, family ="proxima-nova"), 
                plot.title = element_text(margin=margin(0,0,30,0),size = 14, face ="bold", family ="proxima-nova"),
                panel.background = element_blank(),
                panel.grid.major = element_line(colour = "grey"),
                axis.title.x = element_text(margin=margin(30,0,0,0)), 
                axis.title.y = element_text(margin=margin(0,30,0,0))
              )
      
      charts
      
    })
    
    output$chartSdgsGroup <- renderPlot({
      data <- ChartSdgsGroup()
      charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
        geom_line(aes(color = sdg_code, linetype= sdg_code)) +
        geom_point(aes(color = sdg_code), size = 3, alpha = 0.75) +
        labs(y="SDG Indicator", x = "Year")+
        ggtitle(paste(data$countries_name," \n","SDG Indicator for ",data$group_name," ",data$subgroup_name," ","\n", sep = "")) +
        scale_x_continuous(breaks=years)+
        scale_y_continuous(limits =c(0,1))+
        scale_linetype("SDG")+
        scale_color_manual("SDG",values=palette_indicators())+
        theme(text = element_text(size = 16, family ="proxima-nova"), 
              plot.title = element_text(margin=margin(0,0,30,0),size = 14, face ="bold", family ="proxima-nova"),
              panel.background = element_blank(),
              panel.grid.major = element_line(colour = "grey"),
              axis.title.x = element_text(margin=margin(30,0,0,0)), 
              axis.title.y = element_text(margin=margin(0,30,0,0))
        )
      
      charts
      
    })
    
  })
  
  ##end server
}
