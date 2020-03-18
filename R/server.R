
server = function(input, output, session) {
  
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
        "<br><br><b>Total number of indicators: </b>",indicators_country$indicator_num, "<br>",
        "<b>Population Definitions: </b>",indicators_country$population_definition, "<br>",
        #"<b>Description: </b>", indicators_country$description, "<br><br>",
        "<b>Data sources: </b>","<br>", indicators_country$source_url, "<br>"
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
    data_selected <- selectedData()
    sdg_code<-unique(data_selected$sdg_code)
    
    for(indicator in sdg_code){
      sdg_number <- as.numeric(strsplit(indicator, ".", fixed = TRUE)[[1]][1])
      image_sdg_number <- paste("imageSdg",sdg_number, sep = "")
      output[[image_sdg_number]] <- show_image(sdg_number)
    }
  })
  
  
  
  #download charts
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
  
  # Create the map
  output$mymap <- renderLeaflet({
    leaflet() %>% addTiles( options = providerTileOptions(minZoom = 2, maxZoom = 10)) %>% 
      addProviderTiles("Esri.WorldStreetMap", options = providerTileOptions(minZoom = 2, maxZoom = 10))
  })
  
  
  observe({
    req(input$filterIndicators)
    if(input$country!=""){
      shinyjs::show(id = "available_data")
    }
  })
  
  
  
  # Create a list of sdg selected from filter
  ChartGroupsSdg <- reactive ({
    req(input$sdgChartFilter)
    data <- selectedData()
    data <- subset(data, sdg_code == input$sdgChartFilter)
    
    return(data)
    
  })
  
  ChartSdgsGroup<- reactive ({
    req(input$groupChartFilter)
    data <- selectedData()
    data <- subset(data, group_name == input$groupChartFilter)
    
    return(data)
    
  })
  
  # Filter data by subsets
  selectedData <- reactive({
    req(input$country)

    data_table <- load_indicators(input$country) %>% select(countries_name, group_name, subgroup_name, year, sdg_code, sdg_description, indicator_value, description, population_definition, comment, latitude, longitude)
    
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
  
  # Update the Subsets, Subgroups and SDG indicators after the filter country has been selected
  
  observe({
    req(input$country)
    
    data <- subset(indicators, country_code == input$country)
    subsets_list_filter <- sort(unique(setNames(data$group_name,as.character(data$group_name))))
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', choices = subsets_list_filter, selected = subsets_list_filter)
    
    subgroups_list_filter <- sort(unique(setNames(data$subgroup_name,as.character(data$subgroup_name))))
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubgroups', choices = subgroups_list_filter, selected = subgroups_list_filter)
    
    sdg_description_list <- setNames(unique(data$sdg_code),as.character(paste(unique(data$sdg_code), unique(data$sdg_description), sep=': ')))
    sdg_description_list[!is.na(sdg_description_list)]
    sdg_description_list <- sort(sdg_description_list)
    
    updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', choices = sdg_description_list, selected = sdg_description_list)
  
  })
  
  #update checkboxGroup if the Select All is unticked/ticked
  observe({
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', selected = if(input$select_all_groups) subsets_list())
    updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', selected = if(!input$select_all_groups) FALSE)
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubgroups', selected = if(input$select_all_subgroups) subgroup_list())
    updateCheckboxGroupInput(session = session, inputId = 'filterSubgroups', selected = if(!input$select_all_subgroups) FALSE)
    
    updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', selected = if(input$select_all_sdg) sdg_list())
    updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', selected = if(!input$select_all_sdg) FALSE)
    
    })
  
  

  observe({
    
    if(input$country=="") {
      
      leafletProxy("mymap") %>%
        setView(lng = 0, lat = 0, zoom = 2.5) %>%
        addMarkers(lng = as.numeric(indicators_map$longitude), 
                   lat = as.numeric(indicators_map$latitude), 
                   icon = icons(iconUrl = indicators_map$icon_url,iconWidth = 40, iconHeight = 65, iconAnchorX = 20, iconAnchorY = 64),
                   popup = paste("<h5><b>Country:</b>", 
                                 indicators_map$countries_name, "</h5>",
                                 "<h5><b>Subset:</b>",
                                 indicators_map$icon_url,
                                 "<h5><b>Subgroup:</b>",
                                 indicators_map$subgroup_name,
                                 "<h5><b>Indicators n:</b>", indicators_map$indicator_num , "</h5>"
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
  
  
  ## table in main page tab 1
  output$tableTab1 = DT::renderDataTable(server = FALSE,{
    #select data from selectedData to display on the table 
    data_download<-selectedData()
    data_download<-data_download %>% select(sdg_code, countries_name, group_name, subgroup_name, year, indicator_value, description, population_definition)
    DT::datatable(
      data_download,
     
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
      #formatStyle('countries_name', color = '#0072BC') 
  })
 #
  wrapper <- function(x, ...) 
  {
    paste(strwrap(x, ...), collapse = "\n")
  }
  
  ## Create the plot for downloading
  plotSdgByIndicator<- reactive({
    data <- ChartGroupsSdg()
    charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
      geom_line(aes(color = group_name, linetype= group_name)) +
      geom_point(aes(color = group_name), size = 3, alpha = 0.75) +
      labs(y="SDG Indicator", x = "year") +
      ggtitle(paste(data$countries_name," \n","SDG Indicator ",  data$sdg_code,"\n",wrapper(data$sdg_description[1], width = 60),"\n", sep = "")) +
      scale_x_continuous(breaks=years) +
      scale_y_continuous(limits =c(0,1)) +
      scale_linetype("SubSet") +
      scale_color_manual("SubSet",values=palette_indicators()) +
      theme(text = element_text(size = 16), 
            plot.title = element_text(size = 14, face = "bold")
            
      )
  })
  
  plotSdgBySubset<- reactive({
    data <- ChartSdgsGroup()
    charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
      geom_line(aes(color = sdg_code, linetype= sdg_code)) +
      geom_point(aes(color = sdg_code), size = 3, alpha = 0.75) +
      labs(y="SDG Indicator", x = "year")+
      ggtitle(paste(data$countries_name," \n","SDG Indicator for ",data$group_name," ",data$subgroup_name," ","\n", sep = "")) +
      scale_x_continuous(breaks=years)+
      scale_y_continuous(limits =c(0,1))+
      scale_linetype("SDG")+
      scale_color_manual("SDG",values=palette_indicators())+
      theme(text = element_text(size = 16),
            plot.title = element_text(size = 14, face = "bold")
      )
  })
  
  # Display Charts
  observe({
    data <- ChartGroupsSdg()
    output$chart <- renderPlot({
      charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
        geom_line(aes(color = group_name, linetype= group_name)) +
        geom_point(aes(color = group_name), size = 3, alpha = 0.75) +
        labs(y="SDG Indicator", x = "year") +
        ggtitle(paste(data$countries_name," \n","SDG Indicator ",  data$sdg_code,"\n",wrapper(data$sdg_description[1], width = 60),"\n", sep = "")) +
        scale_x_continuous(breaks=years) +
        scale_y_continuous(limits =c(0,1)) +
        scale_linetype("SubSet") +
        scale_color_manual("SubSet",values=palette_indicators()) +
        theme(text = element_text(size = 16), 
                plot.title = element_text(size = 14, face = "bold")
              )
      
      charts
      
    })
    
    output$chartSdgsGroup <- renderPlot({
      data <- ChartSdgsGroup()
      charts <-ggplot(data = data, aes(x=as.numeric(year), y=indicator_value)) +
        geom_line(aes(color = sdg_code, linetype= sdg_code)) +
        geom_point(aes(color = sdg_code), size = 3, alpha = 0.75) +
        labs(y="SDG Indicator", x = "year")+
        ggtitle(paste(data$countries_name," \n","SDG Indicator for ",data$group_name," ",data$subgroup_name," ","\n", sep = "")) +
        scale_x_continuous(breaks=years)+
        scale_y_continuous(limits =c(0,1))+
        scale_linetype("SDG")+
        scale_color_manual("SDG",values=palette_indicators())+
        theme(text = element_text(size = 16),
              plot.title = element_text(size = 14, face = "bold")
              )
      
      charts
      
    })
    
  })
  
  ##end server
}
