server = function(input, output, session) {
  
  #####################################
  # Images SDG
  #####################################
  observe({
    req(input$country)
    indicators <- load_indicators(input$country)
    sdg_code<-unique(indicators$sdg_code)
    
    for(indicator in sdg_code){
      sdg_number <- as.numeric(strsplit(indicator, ".", fixed = TRUE)[[1]][1])
      image_sdg_number <- paste("imageSdg",sdg_number, sep = "")
      print(image_sdg_number)
      output[[image_sdg_number]] <- show_image(sdg_number)
    }
  })
  
  
  # Select all the checkboxs when the select All checkbox is selected
  observe({
    
    if(input$filterSubsets[1]=="Select All"){
      updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', choices = subsets_list, selected = subsets_list)
    }
    #if(input$filterIndicators[1]=="Select All"){
    #  updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', choices = sdg_list, selected = sdg_list)
    #}
    
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
    leaflet() %>% addTiles() %>% addProviderTiles("Esri.WorldStreetMap")
  })
  
  
  observe({
    req(input$filterIndicators)
    if(input$country!=""){
      shinyjs::show(id = "groupfilter") 
      shinyjs::show(id = "sdgfilter")
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
    
    #update the selectInput for SDG Chart Filter
    sdg_code_list <- unique(data_table$sdg_code)
    updateSelectInput(session = session, inputId = 'sdgChartFilter', choices = sdg_code_list)
    
    #update the selectInput for Group Chart Filter
    subsets_list <- unique(data_table$group_name)
    updateSelectInput(session = session, inputId = 'groupChartFilter', choices = subsets_list)
    
    return(data_table)
  })
  
  # Update the Subsets after the filter country has been selected
  
  observe({
    req(input$country)
    
    filter_by_country <- subset(indicators, country_code == input$country & (year >= input$years[1] & year <= input$years[2]))  
    filter_by_country <- filter_by_country  %>% select(countries_name, group_name, year, sdg_code, sdg_description)
    subsets_list_filter <- sort(unique(setNames(filter_by_country$group_name,as.character(filter_by_country$group_name))))
    #subsets_list_filter <- append(as.character(subsets_list_filter), 'Select All', after = 0)# add Select All to the subsets_list
    
    updateCheckboxGroupInput(session = session, inputId = 'filterSubsets', choices = subsets_list_filter, selected = subsets_list_filter)
    
    
  })
  
  # Update Indicators CheckboxGroupinput after the filter Subsets has been selected
  
  observe({
    req(input$country)
    filter_by_country <- subset(indicators, country_code == input$country & (year >= input$years[1] & year <= input$years[2]))  
    filter_by_country <- filter_by_country  %>% select(countries_name, group_name, year, sdg_code, sdg_description)
    filter_by_subsets <- subset(filter_by_country, group_name %in% input$filterSubsets) 
    sdg_list <- setNames(unique(filter_by_subsets$sdg_code),as.character(paste(unique(filter_by_subsets$sdg_code), unique(filter_by_subsets$sdg_description), sep=': ')))
    sdg_list[!is.na(sdg_list)]
    sdg_list <- sort(sdg_list)
    #sdg_list <- append((sdg_list), 'Select All', after = 0)# add Select All to the sdg_list
    
    updateCheckboxGroupInput(session = session, inputId = 'filterIndicators', choices = sdg_list, selected = sdg_list)
    
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
                                       "<h5><b>Subgroup:</b>",
                                       indicators_map$subgroup_name,
                                       "<h5><b>Indicators n:</b>", indicators_map$indicator_num , "</h5>"
                         )) %>% 
        addMarkers(lng = indicators_map$longitude, 
                   lat = indicators_map$latitude, 
                   icon = icons(iconUrl = "images_app/markers/IPD.png",iconWidth = 40, iconHeight = 65, iconAnchorX = 20, iconAnchorY = 64),
                   popup = paste("<h5><b>Country:</b>", 
                                 indicators_map$countries_name, "</h5>",
                                 "<h5><b>Subset:</b>",
                                 indicators_map$group_name,
                                 "<h5><b>Subgroup:</b>",
                                 indicators_map$subgroup_name,
                                 "<h5><b>Indicators n:</b>", indicators_map$indicator_num , "</h5>"
                   )
                   ) %>% 
        addLegend("bottomright",
                  colors = unique(indicators_map$color),
                  labels = unique(indicators_map$group_name),
                  opacity = 0.6)
      
    } else if(input$country!=""){
      removeUI(selector = "#mainmap", session = session)
    }
    
  })
  
  
  ## table in main page tab 1
  output$tableTab1 = DT::renderDataTable({
    #select data from selectedData to display on the table 
    data_download<-selectedData()
    data_download<-data_download %>% select(countries_name, group_name, year, sdg_code, indicator_value, description, population_definition)
    DT::datatable(
      data_download,
      filter = 'top',
      extensions = 'Buttons',
      options = list(
        dom = 'Blfrtip',
        buttons = c('copy', 'excel', 'pdf', 'print'),
        text = 'Download',
        br()
      ),
      class = "display"
    )
  })
  
  ## Create the plot for downloading
  plotSdgByIndicator<- reactive({
    charts <-ggplot(data = ChartGroupsSdg(), aes(x=year, y=indicator_value)) +
      geom_line(aes(color = group_name, linetype= group_name)) +
      geom_point(aes(color = group_name), size = 3, alpha = 0.75) +
      labs(y="sdg indicators", x = "years")+
      ggtitle("SDG Indicator by indicator") +
      scale_x_continuous(breaks=years)+
      scale_y_continuous(limits =c(0,1))+
      #scale_color_discrete("SubSet")+
      scale_linetype("SubSet")+
      scale_color_manual("SubSet",values=palette_indicators)+
      theme(text = element_text(size = 16))
  })
  
  plotSdgBySubset<- reactive({
    charts <-ggplot(data = ChartSdgsGroup(), aes(x=year, y=indicator_value)) +
      geom_line(aes(color = sdg_code, linetype= sdg_code)) +
      geom_point(aes(color = sdg_code), size = 3, alpha = 0.75) +
      labs(y="sdg indicators", x = "years")+
      ggtitle("SDG Indicators by Subset") +
      scale_x_continuous(breaks=years)+
      scale_y_continuous(limits =c(0,1))+
      # scale_color_discrete("SDG")+
      scale_linetype("SDG")+
      scale_color_manual("SDG",values=palette_indicators)+
      theme(text = element_text(size = 16))
  })
  
  # Display Charts
  observe({
    output$chart <- renderPlot({
      charts <-ggplot(data = ChartGroupsSdg(), aes(x=year, y=indicator_value)) +
        geom_line(aes(color = group_name, linetype= group_name)) +
        geom_point(aes(color = group_name), size = 3, alpha = 0.75) +
        labs(y="sdg indicators", x = "years")+
        ggtitle("SDG Indicator by indicator") +
        scale_x_continuous(breaks=years)+
        scale_y_continuous(limits =c(0,1))+
        #scale_color_discrete("SubSet")+
        scale_linetype("SubSet")+
        scale_color_manual("SubSet",values=palette_indicators)+
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
        # scale_color_discrete("SDG")+
        scale_linetype("SDG")+
        scale_color_manual("SDG",values=palette_indicators)+
        theme(text = element_text(size = 16))
      
      charts
      
    })
    
  })
  
  ##end server
}
