##########################
###### Assignment 2 ######
###### Natakorn Kam ######
######### 1244661 ########
##########################

##########################
######## LIBRARIES #######
##########################
library(shiny)
library(shinydashboard)
library(plotly)
library(tidyr)
library(dplyr)
library(RColorBrewer)
library(shinydashboardPlus)
library(leaflet)
library(geojsonio)
library(sf)
library(shinyjs)
library(rjson)
library(scales)
library(wordcloud2)

##########################
######## FUNCTION ######## 
##########################
## This function beautify the large number, by adding Billion (B) or Million (M) or add comma to
## make these number easier to intrepret
format_number_with_suffix = function(x) {
  if (x >= 1e9) {
    billions = x / 1e9
    formatted = sprintf("%.1f", billions)
    return(paste0(formatted, " B"))
  } else if (x >= 1e6) {
    millions = x / 1e6
    formatted = sprintf("%.1f", millions)
    return(paste0(formatted, " M"))
  } else {
    formatted = format(x, big.mark = ",", scientific = FALSE, trim = TRUE)
    return(formatted)
  }
}
## This function manages the information during pre-processing data (merging country-related data)
extract_info = function(x, column_name) {
  match_row = country_code[country_code$alpha.2 == x['Abbreviation'], ]
  match_row = na.omit(match_row)
  return(match_row[column_name][1, ])
}
## This function is added for word cloud not rendering problem
## the source of this code is mentioned in the design summary
## https://github.com/rstudio/shinydashboard/issues/281#issuecomment-615888981
wordcloud2a = function (data, size = 1, minSize = 0, gridSize = 0, fontFamily = "Segoe UI", fontWeight = "bold", color = "random-dark", backgroundColor = "white", minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE, rotateRatio = 0.4, shape = "circle", ellipticity = 0.65, widgetsize = NULL, figPath = NULL, hoverFunction = NULL){
  if ("table" %in% class(data)) {
    dataOut = data.frame(name = names(data), freq = as.vector(data))
  }
  else {
    data = as.data.frame(data)
    dataOut = data[, 1:2]
    names(dataOut) = c("name", "freq")
  }
  if (!is.null(figPath)) {
    if (!file.exists(figPath)) {
      stop("cannot find fig in the figPath")
    }
    spPath = strsplit(figPath, "\\.")[[1]]
    len = length(spPath)
    figClass = spPath[len]
    if (!figClass %in% c("jpeg", "jpg", "png", "bmp", "gif")) {
      stop("file should be a jpeg, jpg, png, bmp or gif file!")
    }
    base64 = base64enc::base64encode(figPath)
    base64 = paste0("data:image/", figClass, ";base64,", 
                    base64)
  }
  else {
    base64 = NULL
  }
  weightFactor = size * 180/max(dataOut$freq)
  settings <- list(word = dataOut$name, freq = dataOut$freq, 
                   fontFamily = fontFamily, fontWeight = fontWeight, color = color, 
                   minSize = minSize, weightFactor = weightFactor, backgroundColor = backgroundColor, 
                   gridSize = gridSize, minRotation = minRotation, maxRotation = maxRotation, 
                   shuffle = shuffle, rotateRatio = rotateRatio, shape = shape, 
                   ellipticity = ellipticity, figBase64 = base64, hover = htmlwidgets::JS(hoverFunction))
  chart = htmlwidgets::createWidget("wordcloud2", settings, 
                                    width = widgetsize[1], height = widgetsize[2], sizingPolicy = htmlwidgets::sizingPolicy(viewer.padding = 0, 
                                                                                                                            browser.padding = 0, browser.fill = TRUE))
  chart
}

############################
#### DATA PRE-PROCESSING ###
############################
## This is where you could set you working directory
# setwd('~/Desktop/Information_Visualisation/Assignment2')
##

## This section loads data to the working space
youtube_data = read.csv('GlobalYouTubeStatistics.csv')
country_code = read.csv('country_code.csv')
world = geojson_read('world.geojson', what = "sp")
world_sf = st_as_sf(world)

## This section merging data between youtube_data and country_code
country_code = country_code[c('name', 'alpha.2', 'alpha.3', 'region', 'sub.region')]
youtube_data$code3 = apply(youtube_data, 1, extract_info, column_name = 'alpha.3')
youtube_data$region = apply(youtube_data, 1, extract_info, column_name = 'region')
youtube_data$subRegion = apply(youtube_data, 1, extract_info, column_name = 'sub.region')

## This section remove all na and nan (string) data
## The extreme outliers (possibly error) data is removed eg. created year 1970, rate exceeds 100
youtube_data = na.omit(youtube_data)
youtube_data = subset(youtube_data, category!="nan")
youtube_data = subset(youtube_data, channel_type!="nan")
youtube_data = subset(youtube_data, created_year!=1970)
youtube_data[youtube_data$Country == "Australia", "Education.rate"] = max(subset(youtube_data, Country != 'Australia')$Education.rate)
## Additional data is calculated to enhance visualisation
youtube_data$average_monthly_earning = (youtube_data$lowest_monthly_earnings + youtube_data$highest_monthly_earnings)/2
youtube_data$average_yearly_earning = (youtube_data$lowest_yearly_earnings + youtube_data$highest_yearly_earnings)/2

############################
####### DATA FUNCTION ######
############################
## This is where the function to create data for each page is
## if the visualisation use similar data, these function will be called
general_overview_data = function(new_data){
  return (general_overview_data = new_data %>%
            group_by(Country, Abbreviation, Latitude, Longitude, channel_type, created_year) %>%
            summarise(count= n(), totalViews = sum(video.views), totalSub = sum(subscribers), totalUploads=sum(uploads), .groups='keep'))
}
heatMap = function(new_data){
  heat_map = new_data %>%
    group_by(created_month, created_date) %>%
    summarise(count = n(), .groups='keep') %>%
    mutate(
      created_month = factor(created_month, levels = month.abb)
    ) %>%
    arrange(created_month)
  
  heat_map_2 = heat_map %>%
    pivot_wider(names_from = created_date, values_from = count)
  
  heat_map_2 = data.matrix(heat_map_2)
  heat_map_2 = heat_map_2[,-1]
  rownames(heat_map_2) = unique(heat_map$created_month)
  heat_map_2[is.na(heat_map_2)] = 0
  heat_map_2 = heat_map_2[,as.character(1:31)]
  return (heat_map_2)
}
earning = function(new_data){
  return (new_data %>%
            group_by(Country, Abbreviation) %>%
            summarise(sub = sum(subscribers), average=mean(average_monthly_earning), 
                      min=mean(lowest_monthly_earnings), max=mean(highest_monthly_earnings),
                      averageYear = mean(average_yearly_earning), .groups='keep')%>%
            arrange(sub))
}
population_data = function(new_data){
  return (new_data %>%
            group_by(Country, Abbreviation, Latitude, Longitude) %>%
            summarise(total_population = sum(Population),
                      unemployment.rate = mean(Unemployment.rate),
                      education.rate = mean(Education.rate), .groups='keep')%>%
            arrange(desc(total_population)))
}

####################
######## UI ######## 
####################
ui = dashboardPage(
  skin='red',
  title="Youtube Analysis",
  dashboardHeader(title = p(icon("youtube"), "Youtube Analysis"),userOutput("user")),
  dashboardSidebar(
    sidebarMenu(
      id = "mypage",
      menuItem("General Overview", tabName = "General_Overview", icon = icon("home")),
      menuItem("Earning Analysis", tabName = "Earning_Analysis", icon = icon("money-bill")),
      menuItem("Population Analysis", tabName = "Population_Analysis", icon = icon("person"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "General_Overview",
              fluidRow(
                box(
                  id = "topic_general_overview_id",
                  htmlOutput("topic_general_overview"),
                  width=12
                ),
                ## remove box header
                tags$head(tags$style('#topic_general_overview_id .box-header{ display: none}'))
              ),
              fluidRow(
                valueBoxOutput("TotalViews"),
                valueBoxOutput("TotalSub"),
                valueBoxOutput("TotalUploads")
              ),
              fluidRow(
                box(title='Filter',
                    status = "primary",
                    background = 'gray',
                    solidHeader = TRUE,
                    width=2, 
                    sliderInput(
                      inputId='rank',
                      label='Channel Rank',
                      min=min(unique(youtube_data$rank)),
                      max=max(unique(youtube_data$rank)),
                      value=max(unique(youtube_data$rank))
                    ),
                    selectInput(
                      inputId='category',
                      label='Category',
                      choices=c('All', youtube_data$category),
                      selected='All'
                    ),
                    radioButtons(
                      inputId='region',
                      label='Region',
                      choices=c('All', unique(sort(youtube_data$region))),
                      selected='All'
                    ),
                    actionButton("reset_input", "Reset", 
                                 style="color: #fff; background-color: #018571; border-color: #f5f5f5; width: 100%")
                ),
                box(title='Channels per Country Overview',
                    status = "primary",
                    solidHeader = TRUE,
                    leafletOutput('channels_map'), width=10)
              ),
              fluidRow(
                box(id='channel_growth_box', 
                    title='Channel\'s Age and Average Monthly Earnings',
                    status='warning',
                    collapsible = TRUE,
                    width=8, plotlyOutput('channel_growth')),
                box(id='unemploy_ratio_box',
                    collapsible = TRUE,
                    title='Unemployment Ratio',
                    status='warning',
                    width=4, plotlyOutput('unemploy_ratio'))
              ),
              fluidRow(
                box(title='Category Frequency',
                    status = "primary",
                    solidHeader = TRUE,
                    wordcloud2Output('wordcloud'), width=4),
                box(title='Table Data',
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput('table'), width=8),
              ),
              fluidRow(
                box(title='Channel Creation Date Heatmap',
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput('heatmap'), width=12),
              ),
              
      ),
      tabItem(tabName = "Earning_Analysis",
              fluidRow(
                box(
                  id = "topic_earning_analysis_id",
                  htmlOutput("topic_earning_analysis"),
                  width=12
                ),
                tags$head(tags$style('#topic_earning_analysis_id .box-header{ display: none}'))
              ),
              fluidRow(
                valueBoxOutput("average_monthly",width=6),
                valueBoxOutput("average_yearly",width=6)
              ),
              fluidRow(
                box(title='Filter',
                    status = "primary",
                    background = 'gray',
                    solidHeader = TRUE,
                    width=2, 
                    sliderInput(
                      inputId='rank_2',
                      label='Channel Rank',
                      min=min(unique(youtube_data$rank)),
                      max=max(unique(youtube_data$rank)),
                      value=max(unique(youtube_data$rank))
                    ),
                    selectInput(
                      inputId='category_2',
                      label='Category',
                      choices=c('All', youtube_data$category),
                      selected='All'
                    ),
                    radioButtons(
                      inputId='region_2',
                      label='Region',
                      choices=c('All', unique(sort(youtube_data$region))),
                      selected='All'
                    ),
                    actionButton("reset_input_2", "Reset", 
                                 style="color: #fff; background-color: #018571; border-color: #f5f5f5; width: 100%")
                ),
                box(title='Channels Average Monthly Earning Overview',
                    status = "primary",
                    solidHeader = TRUE,
                    leafletOutput('monthly_earning_map'), width=10)
              ),
              fluidRow(
                box(title='Monthly Earning Trends by Country',
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput('monthly_earning_fig'), width=12),
              )
              
      ),
      tabItem(tabName = "Population_Analysis",
              fluidRow(
                box(
                  id = "topic_population_analysis_id",
                  htmlOutput("topic_population_analysis"),
                  width=12
                ),
                tags$head(tags$style('#topic_population_analysis_id .box-header{ display: none}'))
              ),
              fluidRow(
                valueBoxOutput("education_rate"),
                valueBoxOutput("unemploy_rate"),
                valueBoxOutput("total_population"),
              ),
              fluidRow(
                box(title='Filter',
                    status = "primary",
                    background = 'gray',
                    solidHeader = TRUE,
                    width=2, 
                    selectInput(
                      inputId='country',
                      label='Country', 
                      choices=c(sort(unique(youtube_data$Country))),
                      selected=sort(unique(youtube_data$Country))[1]
                    ),
                    actionButton("reset_input_3", "Reset", 
                                 style="color: #fff; background-color: #018571; border-color: #f5f5f5; width: 100%")
                ),
                box(title='Category Counts vs. Subscribers',
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput('category_sub'), width=10),
              )
      )
    )
    
  )
)
########################
######## Server ######## 
########################

server = function(input, output,session) {
  ## Force the box to close on default
  updateBox('channel_growth_box', action='toggle')
  updateBox('unemploy_ratio_box', action='toggle')
  
  ######## User Profile ########
  output$user = renderUser({
    dashboardUser(
      name = "Natakorn Kam", 
      image = "https://cdn-icons-png.flaticon.com/512/6833/6833605.png", 
      title = "Dashboard Creator",
      subtitle = "Assignment 2 GEOM90007"
    )
  })
  ######## User Profile ########
  
  ######## GENERAL OVERVIEW ########
  ######## GENERAL OVERVIEW: Filter ########
  ## This valuable will be set as the value from map
  selected_country = reactiveVal(NULL)
  
  ## reset all filter and close collapsible box, if it opens
  observeEvent(input$reset_input, {
    updateSliderInput(session, 'rank', value=max(youtube_data$rank))
    updateSelectInput(session, 'category', selected='All',choices=c('All', youtube_data$category))
    updateRadioButtons(session, 'region', selected='All',choices=c('All', unique(sort(youtube_data$region))))
    selected_country(NULL)
    if(!input$channel_growth_box$collapsed){
      updateBox('channel_growth_box', action='toggle')
    }
    if(!input$unemploy_ratio_box$collapsed){
      updateBox('unemploy_ratio_box', action='toggle')
    }
  })
  getFilteredData_1 = reactive({
    filter(youtube_data, 
           rank <= input$rank,
           if (input$category == 'All') TRUE else category == input$category,
           if (input$region == 'All') TRUE else region == input$region
    )
  })
  ## When the map is clicked, update selected_country data to change visualisation
  ## Additionally, the collapsible box is opened
  ## Additionally, the filter box gets updated according to selected_country value to prevent NA value shown
  observeEvent(input$channels_map_shape_click, {
    selected_country(input$channels_map_shape_click)
    
    currentData = getFilteredData_1() %>%
      filter(selected_country()$id == Abbreviation)
    
    updateSelectInput(session, 'category',
                      choices = c('All', unique(currentData$category)),
                      selected='All')
    updateRadioButtons(session, 'region',
                       choices = c('All', sort(unique(currentData$region))),
                       selected='All')
    
    if(is.null(selected_country)) {
      if(!input$channel_growth_box$collapsed){
        updateBox('channel_growth_box', action='toggle')
      }
      if(!input$unemploy_ratio_box$collapsed){
        updateBox('unemploy_ratio_box', action='toggle')
      }
    }else{
      if(input$channel_growth_box$collapsed){
        updateBox('channel_growth_box', action='toggle')
      }
      if(input$unemploy_ratio_box$collapsed){
        updateBox('unemploy_ratio_box', action='toggle')
      }
    }
  })
  ######## GENERAL OVERVIEW: Filter ########
  ## selected_country variable is given to all visualisation except for heat map to change dynamically
  ## according to the selected_country (from map)
  output$topic_general_overview = renderText({
    if (is.null(selected_country()$id)) {
      "<b><span style='font-size: 40px;'>General Overview: All</span></b>"
    } else {
      current_country = country_code %>%
        filter(selected_country()$id == alpha.2)
      paste("<b><span style='font-size: 40px;'>General Overview: ", current_country$name, "</span></b>")
    }
  })
  ######## Value Box ########
  output$TotalViews = renderValueBox({
    if(is.null(selected_country())){
      valueBox(
        format_number_with_suffix(sum(general_overview_data(getFilteredData_1())$totalViews)), "Total Views", icon = icon("eye"),
        color = "red"
      )
    }else{
      valueBox(
        format_number_with_suffix(sum(general_overview_data(getFilteredData_1() %>% filter(selected_country()$id==Abbreviation))$totalViews)), "Total Views", icon = icon("eye"),
        color = "red"
      )
    }
    
  })
  output$TotalSub = renderValueBox({
    if(is.null(selected_country())){
      valueBox(
        format_number_with_suffix(sum(general_overview_data(getFilteredData_1())$totalSub)), "Total Subscribers", icon = icon("envelope"),
        color = "green"
      )
    }else{
      valueBox(
        format_number_with_suffix(sum(general_overview_data(getFilteredData_1() %>% filter(selected_country()$id==Abbreviation))$totalSub)), "Total Subscribers", icon = icon("envelope"),
        color = "green"
      )
    }
    
  })
  output$TotalUploads = renderValueBox({
    if(is.null(selected_country())){
      valueBox(
        format_number_with_suffix(sum(general_overview_data(getFilteredData_1())$totalUploads)), "Total Uploads", icon = icon("upload"),
        color = "blue"
      )
    }else{
      valueBox(
        format_number_with_suffix(sum(general_overview_data(getFilteredData_1()%>% filter(selected_country()$id==Abbreviation))$totalUploads)), "Total Uploads", icon = icon("upload"),
        color = "blue"
      )
    }
    
  })
  ######## Leaflet Map ########
  output$channels_map = renderLeaflet({
    if(is.null(selected_country())){
      country_group = getFilteredData_1() %>%
        group_by(Abbreviation) %>%
        summarise(count = n())
    }else{
      country_group = getFilteredData_1() %>%
        filter(selected_country()$id == Abbreviation) %>%
        group_by(Abbreviation) %>%
        summarise(count = n())
    }
    
    data = world_sf %>%
      left_join(country_group, by = c("id" = "Abbreviation"))
    
    leaflet(data) %>%
      addProviderTiles(providers$CartoDB) %>%
      addTiles("MapBox",
               options = providerTileOptions(id = "mapbox.light"),layerId = ~id) %>%
      addPolygons(
        layerId = ~id,
        fillColor = ~colorBin("YlGnBu", count)(count),
        weight = 1,
        opacity = 1,
        color = "#dfc27d",
        dashArray = "3",
        fillOpacity = 0.7,
        highlightOptions = highlightOptions(
          weight = 2,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = ~lapply(paste("<b><span style='font-size: 14px;'>", name ,"</span></b>", "<br>", 
                              "Number of Channels: ", count), htmltools::HTML),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "12px",
          direction = "auto")
      ) %>% 
      addLegend(pal = colorBin("YlGnBu", data$count),
                values = ~count, opacity = 0.7, title = NULL,
                position = "bottomright")
  })
  ######## Graph ########
  output$channel_growth = renderPlotly({
    if(is.null(selected_country())) return()
    
    data = getFilteredData_1() %>%
      filter(selected_country()$id == Abbreviation) %>%
      group_by(age=as.integer(format(Sys.Date(), "%Y")) - created_year) 
    
    if(dim(data)[1] == 0) {
      if(!input$channel_growth_box$collapsed){
        updateBox('channel_growth_box', action='toggle')
      }
      return()
    }
    
    data = data %>%
      summarise(count = n(), average = mean(average_monthly_earning))
    
    plot_ly(data, x=~age, y=~count, type='bar', name='Channel\'s Age',
            marker = list(color = '#dfc27d',line = list(color = '#a6611a', width = 1)),
            hoverinfo = "text",
            hovertext = paste("Channel\'s Age: ", data$age, "<br>Number of Channels: ", data$count,
                              "<br>Average Monthly Earnings: ", comma(data$average))
    ) %>% 
      add_trace(y=~average, type='scatter', mode='lines+markers', yaxis = 'y2', name='Average Monthly Earnings',
                line = list(color = '#018571', width = 2,shape = 'spline', smoothing = 1.3,dash='dash'), 
                marker=list(color="#018571",line = list(color = 'white', width = 1))) %>%
      layout(xaxis = list(showgrid=F, title="Channel\'s Age"),
             yaxis = list(title="Number of Channels",showgrid=F),
             yaxis2 = list(overlaying = "y",side = "right",
                           title = "Average Monthly Earnings", 
                           automargin = TRUE,
                           zeroline = FALSE,
                           range = c(0, max(data$average)*1.1)),
             legend = list(orientation = 'h', bgcolor = "#E2E2E2", y= -0.3)
             
      )
  })
  output$unemploy_ratio = renderPlotly({
    if(is.null(selected_country())) {
      return()
    }
    
    data = getFilteredData_1() %>%
      filter(selected_country()$id == Abbreviation) %>%
      group_by(Country)
    if(dim(data)[1] == 0){
      if(!input$channel_growth_box$collapsed){
        updateBox('unemploy_ratio_box', action='toggle')
      }
      return()
    } 
    data = data %>%
      summarise(unemp = mean(Unemployment.rate))
    
    plot_ly(data, labels = c('Unemployment Rate', 'Others'), values=c(data$unemp, 100-data$unemp),
            type = 'pie',textposition = 'inside', 
            hoverinfo ='none',
            textinfo = 'label+percent', insidetextfont = list(color = '#FFFFFF'),
            showlegend = FALSE,
            marker = list(colors = c('#a6611a','#dfc27d'),
                          line = list(color = '#FFFFFF', width = 1)))
  })
  output$heatmap = renderPlotly({
    heat_map = heatMap(youtube_data)
    plot_ly(z=heat_map,y=rownames(heat_map), x=colnames(heat_map),type='heatmap',
            hovertemplate = paste("Date: %{x} %{y} <br>Number of Channel Created: %{z}<extra></extra>")
    )
  })
  output$table = renderPlotly({
    if(is.null(selected_country())) {
      data = getFilteredData_1() %>%
        select(Rank = rank, ChannelName = Youtuber, Category=category, Country, Region=region)
    }else{
      data = getFilteredData_1() %>%
        filter(selected_country()$id == Abbreviation) %>%
        select(Rank = rank, ChannelName = Youtuber, Category=category, Country, Region=region)
    }
    
    plot_ly(type="table",
            header=list(values=names(data),
                        fill = list(color = rep('#a6611a', length(names(data)))),
                        font = list(size = 14, color = "white")),
            cells=list(values=unname(data),
                       fill = list(color = rep('#f5f5f5', length(unname(data)))))
            )
  })
  output$wordcloud = renderWordcloud2({
    if(is.null(selected_country())) {
      data = getFilteredData_1() %>%
        group_by(category) %>%
        summarise(count = n())
    }else{
      data = getFilteredData_1() %>%
        filter(selected_country()$id == Abbreviation) %>%
        group_by(category) %>%
        summarise(count = n())
    }
    wordcloud2a(data)
  })
  
  ######## EARNING ANALYSIS ######## 
  ######## EARNING ANALYSIS: Filter ########
  ## The reset button resets filter
  observeEvent(input$reset_input_2, {
    updateSliderInput(session, 'rank_2', value=max(youtube_data$rank))
    updateSelectInput(session, 'category_2', selected='All')
    updateRadioButtons(session, 'region_2', selected='All')
  })
  ## When the country on map is clicked, transfer data of the selected country to population analysis tab
  ## to act as the filter for that page
  observeEvent(input$monthly_earning_map_shape_click, {
    updateSelectInput(session, 'country', selected=input$monthly_earning_map_shape_click$id)
    updateTabItems(session, 'mypage',selected = 'Population_Analysis')
  })
  getFilteredData_2 = reactive({
    filter(youtube_data, 
           rank <= input$rank_2,
           if (input$category_2 == 'All') TRUE else category == input$category_2,
           if (input$region_2 == 'All') TRUE else region == input$region_2
    )
  })
  ######## EARNING ANALYSIS: Filter ########
  output$topic_earning_analysis = renderText({
    "<b><span style='font-size: 40px;'>Earning Analysis</span></b>"
  })
  ######## Value Box ########
  output$average_monthly = renderValueBox({
    if(dim(getFilteredData_2())[1] == 0){
      valueBox(
        paste('$',NA), "Average Monthly Earnings", icon = icon("calendar"),
        color = "red"
      )
    }else{
      valueBox(
        paste('$',format_number_with_suffix(mean(earning(getFilteredData_2())$average))), "Average Monthly Earnings", icon = icon("calendar"),
        color = "red"
      )
    }
    
  })
  output$average_yearly = renderValueBox({
    if(dim(getFilteredData_2())[1] == 0){
      valueBox(
        paste('$',NA), "Average Yearly Earnings", icon = icon("calendar"),
        color = "green"
      )
    }else{
      valueBox(
        paste('$',format_number_with_suffix(mean(earning(getFilteredData_2())$averageYear))), "Average Yearly Earnings", icon = icon("calendar"),
        color = "green"
      )
    }
    
  })
  ######## Leaflet Map ########
  output$monthly_earning_map = renderLeaflet({
    country_group = earning(getFilteredData_2()) %>%
      group_by(Abbreviation) %>%
      summarise(average = mean(average), .groups='keep')
    if(dim(country_group)[1] == 0){
      leaflet() %>%
        addProviderTiles(providers$CartoDB)
    }else{
      data = world_sf %>%
        left_join(country_group, by = c("id" = "Abbreviation"))
      
      leaflet(data) %>%
        addProviderTiles(providers$CartoDB) %>%
        addTiles("MapBox",
                 options = providerTileOptions(id = "mapbox.light"),layerId = ~name) %>%
        addPolygons(
          layerId = ~name,
          fillColor = ~colorNumeric("YlGnBu", average)(average),
          weight = 1,
          opacity = 1,
          color = "#dfc27d",
          dashArray = "3",
          fillOpacity = 0.7,
          highlightOptions = highlightOptions(
            weight = 2,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE),
          label = ~lapply(paste("<b><span style='font-size: 14px;'>", name ,"</span></b>", "<br>", 
                                "Average Monthly Earnings: ", comma(average)), htmltools::HTML),
          labelOptions = labelOptions(
            style = list("font-weight" = "normal", padding = "3px 8px"),
            textsize = "12px",
            direction = "auto")
        ) %>% 
        addLegend(pal = colorNumeric("YlGnBu", data$average),
                  values = ~average, opacity = 0.7, title = NULL,
                  position = "bottomright")
    }
    
    
  })
  ######## Graph ########
  output$monthly_earning_fig = renderPlotly({
    monthly_data = earning(getFilteredData_2()) %>% group_by(Country) %>%
      summarise(sub = mean(sub), average=mean(average), min=mean(min), max=mean(max))%>%
      arrange(sub)
    
    if(dim(monthly_data)[1] == 0) return()
    plot_ly(data = monthly_data,x = ~Country,y = ~sub,name = "Number of Subscribers",type = "bar",
            marker = list(color = "#018571"),  
            hoverinfo = "text",
            hovertext = paste(
              "<b><span style='font-size: 14px;'>", monthly_data$Country, "</span></b>",
              "<br>Number of Subscribers: ", comma(monthly_data$sub),
              "<br>Max: ", comma(monthly_data$max),
              "<br>Average: ", comma(monthly_data$average),
              "<br>Min: ", comma(monthly_data$min)
              
            )) %>%
      add_trace(data = monthly_data , x = ~Country, y = ~max, type = 'scatter',yaxis='y2',  mode = 'lines+markers',
                name = 'Maximum Earning',
                line = list(color = 'transparent',shape = 'spline', smoothing = 1.3), 
                showlegend=FALSE,
                marker = list(opacity=0)
                )   %>%
      add_trace(data = monthly_data , x = ~Country, y = ~min, type = 'scatter',yaxis='y2',  mode = 'lines+markers',
                name = 'Min & Max Earning',
                fill = 'tonexty',fillcolor = 'rgba(223,194,125,0.5)', 
                line = list(color = 'transparent',shape = 'spline', smoothing = 1.3),
                marker = list(opacity=0)) %>%
      add_trace(data = monthly_data , x = ~Country, y = ~average, type = 'scatter',yaxis='y2',  mode = 'lines+markers',
                name = 'Average Earning',
                line = list(color = '#a6611a', width = 2,shape = 'spline', smoothing = 1.3),
                marker = list(opacity=0)) %>% 
      layout(xaxis = list(categoryorder = "total ascending",
                          zerolinecolor = '#ffff',zerolinewidth = 2, showgrid=F)
             ) %>% 
      layout(yaxis2 = list(overlaying = "y",side = "right",title = "Average Monthy Earnings",
                           range = c(0, max(monthly_data$max)*1.1),
                           automargin = TRUE),
             yaxis = list(title="Number of Subscribers", showgrid=F)) %>%
      layout(legend = list(orientation = 'h', bgcolor = "#E2E2E2", y= -0.5))
  })

  
  ######## POPULATION ANALYSIS ######## 
  ######## POPULATION ANALYSIS: Filter ########
  ## The reset button resets filter
  observeEvent(input$reset_input_3, {
    updateSelectizeInput(session, 'country', selected=sort(unique(youtube_data$Country))[1])
  })
  getFilteredData_3 = reactive({
    filter(youtube_data,
           Country == input$country
    )
  })
  ######## POPULATION ANALYSIS: Filter ########
  output$topic_population_analysis = renderText({
    current_country = getFilteredData_3()[1,]$Country
    paste("<b><span style='font-size: 40px;'>Population Analysis: ",current_country,"</span></b>")
  })
  ######## Value Box ########
  output$total_population = renderValueBox({
    if(dim(getFilteredData_3())[1] == 0){
      valueBox(
        NA, "Total Population", icon = icon("eye"),
        color = "red"
      )
    }else{
      valueBox(
        format_number_with_suffix(getFilteredData_3()[1,]$Population), "Total Population", icon = icon("eye"),
        color = "red"
      )
    }
    
    
  })
  output$education_rate = renderValueBox({
    if(dim(getFilteredData_3())[1] == 0){
      valueBox(
        paste(NA,'%'), "Education Rate", icon = icon("school"),
        color = "blue"
      )
    }else{
      valueBox(
        paste(getFilteredData_3()[1,]$Education.rate,'%'), "Education Rate", icon = icon("school"),
        color = "blue"
      )
    }
    
  })
  output$unemploy_rate = renderValueBox({
    if(dim(getFilteredData_3())[1] == 0){
      valueBox(
        paste(NA,'%'), "Unemployment Rate", icon = icon("user-doctor"),
        color = "green"
      )
    }else{
      valueBox(
        paste(getFilteredData_3()[1,]$Unemployment.rate,'%'), "Unemployment Rate", icon = icon("user-doctor"),
        color = "green"
      )
    }
    
  })
  ######## Graph ########
  output$category_sub = renderPlotly({
    data = getFilteredData_3() %>%
      group_by(category) %>%
      summarise(count = n(), totalSub = sum(subscribers)) %>%
      arrange(desc(totalSub))
    
    plot_ly(data, x=~category, y=~count, type='bar',name="Category",
            marker = list(color = '#018571'),
            hoverinfo = "text",
            hovertext = paste(
              "<b><span style='font-size: 14px;'>", data$category, "</span></b>",
              "<br>Number of Channels: ", data$count,
              "<br>Number of Subscribers: ", comma(data$totalSub)
            )
            ) %>%
      add_trace(y = ~totalSub,type='scatter', mode='lines+markers',yaxis='y2',name="Total Subscribers",
                line = list(color = '#dfc27d', width = 4,shape = 'spline', smoothing = 1.3), 
                marker=list(color="#dfc27d",line = list(color = '#dfc27d', width = 4))) %>%
      layout(xaxis = list(categoryorder = "total ascending")) %>%
      layout(xaxis = list(showgrid=F, title="Category"),
             yaxis = list(title="Number of Channels",showgrid=F),
             yaxis2 = list(overlaying = "y",side = "right",title = "Total Subscribers", zeroline = FALSE,
                           range = c(0, max(data$totalSub)*1.1),
                           automargin = TRUE),
             legend = list(orientation = 'h', bgcolor = "#E2E2E2"))
  })
  
}

######## Run App ######## 
shinyApp(ui, server)
