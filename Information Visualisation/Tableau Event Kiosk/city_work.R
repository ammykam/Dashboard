##########################
###### Assignment 3 ######
######## Group 84 ########
##########################

##########################
######## LIBRARIES #######
##########################
library(shiny)
library(fontawesome)
library(leaflet)
library(tidyr)
library(dplyr)
library(bslib)
library(bsicons)
library(sf) 

##########################
######## Load Data #######
##########################

## This is where you could set you working directory
# setwd('~/Desktop/GEOM90007_Assignment3_Group84')
##

city_work = read.csv('city_work.csv')
carPark = read.csv('offStreetCarPark.csv')
train = read.csv('train.csv')
tram = read.csv('tram.csv')
event = read.csv('event.csv')

city_work = na.omit(city_work)
carPark = na.omit(carPark)
train = na.omit(train)
tram = na.omit(tram)

city_work = subset(city_work, select = -c(json_geometry,Geometry))
df_split = strsplit(city_work$geo_point_2d, ", ", fixed = TRUE)
city_work$Latitude = sapply(df_split, function(x) as.numeric(x[1]))
city_work$Longitude = sapply(df_split, function(x) as.numeric(x[2]))

df_split = strsplit(train$Geo.Point, ", ", fixed = TRUE)
train$Latitude = sapply(df_split, function(x) as.numeric(x[1]))
train$Longitude = sapply(df_split, function(x) as.numeric(x[2]))

carPark$postalCode = sapply(strsplit(carPark$Building.address, " "), function(x) tail(x, 1))
carPark = carPark %>%
  filter(postalCode %in% c(3000, 3001, 3004, 8001)) %>%
  filter(Parking.type %in% c('Commercial', 'Residential'))

carPark = carPark %>%
  group_by(Property.ID) %>%
  filter(Census.year == max(Census.year))

city_work_sf = st_as_sf(city_work, coords = c("Longitude", "Latitude"))
carPark_sf = st_as_sf(carPark, coords = c("Longitude", "Latitude"))
train_sf = st_as_sf(train, coords = c("Longitude", "Latitude"))
tram_sf = st_as_sf(tram, coords = c("LONGITUDE", "LATITUDE"))

####################
######## UI ######## 
####################

ui = page_fluid(
  leafletOutput("event_map"),
  layout_column_wrap(
    width = 1/4,
    value_box(
      title = "Car Park",
      value = textOutput("carpark_count"),
      showcase = bs_icon("car-front-fill"),
      style = 'background-color: #000000!important;'
    ), 
    value_box(
      title = "Train",
      value = textOutput("train_count"),
      showcase = bs_icon("train-front-fill"),
      style = 'background-color: #0A5BC2!important;'
    ), 
    value_box(
      title = "Tram",
      value = textOutput("tram_count"),
      showcase = bs_icon("train-lightrail-front-fill"),
      style = 'background-color: #67B51A!important;'
    ),
    value_box(
      title = "City Works",
      value = textOutput("citywork_count"),
      showcase = bs_icon("cone-striped"),
      style = 'background-color: #FC4919!important;'
    )
  )
)

########################
######## Server ######## 
########################

server = function(input, output, session) {
  
  ## This where it communicates with Tableau input
  getQueryString = reactive({
    parseQueryString(session$clientData$url_search)
  })
  
  getChosenName = reactive({
    result = c()
    if("event" %in% names(getQueryString())){
      result = strsplit(getQueryString()$event,",")
    }
    result
  })
  
  ## Keep clicked marker in reactiveVal to highlight and calculate nearby markers
  clicked_marker = reactiveValues(lat = NULL, lng = NULL)
  
  ## This is how the default map is drawn
  create_map = function(){
    if(is.null(getChosenName())){
      event_filter = event
    }else{
      event_filter = event[event$event_name %in% getChosenName(),]
    }
    
    original_map = leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addScaleBar(position = "bottomleft") %>%
      setView(lng = 144.9631, lat = -37.8136, zoom = 14) %>%
      addCircleMarkers(data = city_work, 
                       lat = ~Latitude, 
                       lng = ~Longitude,
                       group = 'City Work',
                       radius = 3,  
                       color = 'red', 
                       fill = TRUE,  
                       fillOpacity = 1,  
                       stroke = FALSE,  
                       layerId = ~Activity.ID,
                       popup = ~paste0("<b>City Work: ",Classification,"</b><br/>Notes: ",Notes,"<br/>Location: ",Location)
      ) %>%
      addAwesomeMarkers(data = train, lat=~Latitude, lng=~Longitude,
                        group = 'Train',
                        icon=awesomeIcons(
                          icon = 'train',
                          iconColor = '#ffffff',
                          markerColor = 'blue',
                          library = 'fa'
                        ),
                        popup = ~paste0("<b>", station,"</b>","<br/>","Lift: ",lift),
                        
                        layerId = ~station
      ) %>%
      addAwesomeMarkers(data = carPark, lat=~Latitude, lng=~Longitude,
                        group = 'Car Park',
                        icon=awesomeIcons(
                          icon = 'car',
                          iconColor = 'black',
                          markerColor = 'white',
                          library = 'fa'
                        ),
                        clusterOptions = markerClusterOptions(
                          iconCreateFunction=JS("
                          function (cluster) {    
                            var childCount = cluster.getChildCount(); 
                            var c = ' marker-cluster-'; 
                            if (childCount < 10) {  
                              c += 'large';  
                            } else if (childCount < 25) {  
                              c += 'medium';  
                            } else { 
                              c += 'small';
                            }    
                            return new L.DivIcon({ 
                            html: '<div><span>' + childCount + '</span></div>', 
                            className: 'marker-cluster' + c, 
                            iconSize: new L.Point(40, 40) });}")
                        ),
                        popup = ~paste0("<b>Car Park</b>","<br/>","Address: ",Building.address,
                                        "<br/>","Type: ",Parking.type,
                                        "<br/>","Spaces: ", Parking.spaces),
                        layerId = ~Property.ID
      ) %>%
      addAwesomeMarkers(data = tram, lat=~LATITUDE, lng=~LONGITUDE,
                        group = 'Tram',
                        icon=makeAwesomeIcon(
                          text = fa("train-tram"),
                          iconColor = '#ffffff',
                          markerColor = 'green'
                        ),
                        popup = ~paste0("<b>", STOP_NAME,"</b>"),
                        layerId = ~STOP_ID) %>%
      addAwesomeMarkers(data = event_filter, lat=~lat, lng=~lng,
                        group = 'Events',
                        icon=~awesomeIcons(
                          icon = icon,
                          iconColor = '#ffffff',
                          markerColor = color,
                          library = 'fa'
                        )
      ) %>%
      addLayersControl(overlayGroups = c("Train","Car Park","Tram","City Work"),
                       options = layersControlOptions(collapsed = FALSE)) %>%
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#3D535D",
        completedColor = "#7D4479") %>%
      hideGroup("Train") %>%
      hideGroup("Car Park") %>%
      hideGroup("Tram") %>%
      hideGroup("City Work")
    
    return (original_map)
  }
  
  
  ## This is where the map render, it will consider input from tableau before rendering
  output$event_map = renderLeaflet({
    map = create_map()
    
    # Check if a marker is clicked and add a circle around it
    if (!is.null(clicked_marker$lat) && !is.null(clicked_marker$lng)) {
      map = map %>%
        addCircles(data = data.frame(
          Latitude = clicked_marker$lat, 
          Longitude = clicked_marker$lng),
          radius = 500,
          color = 'yellow',
          fillOpacity = 0.8)%>%
        setView(lng = clicked_marker$lng, lat = clicked_marker$lat, zoom = 15)
    }
    
    if(!is.null(getChosenName())){
      event_filter = event[event$event_name %in% getChosenName(),]
      map = map %>% 
        setView(lng = event_filter$lng, lat = event_filter$lat, zoom = 16)
    }
    
    
    map
  }) 
  
  # This functions counts the marker around the events in 500 metres radius
  count_data_within_radius = reactive({
    if (!is.null(clicked_marker$lat) && !is.null(clicked_marker$lng)) {
      clicked_point = st_sfc(st_point(c(clicked_marker$lng, clicked_marker$lat)))
      
      data_city = st_within(city_work_sf, st_buffer(clicked_point, dist = 0.005))
      data_carPark = st_within(carPark_sf, st_buffer(clicked_point, dist = 0.005))
      data_train = st_within(train_sf, st_buffer(clicked_point, dist = 0.005))
      data_tram = st_within(tram_sf, st_buffer(clicked_point, dist = 0.005))
      return (c(
        sum(as.matrix(data_carPark) == TRUE),
        sum(as.matrix(data_train) == TRUE),
        sum(as.matrix(data_tram) == TRUE),
        sum(as.matrix(data_city) == TRUE)
      ))
      
    } else {
      return(NULL)
    }
  })
  
  ## This is where we keep the marker value
  observeEvent(input$event_map_marker_click, {
    click_info = input$event_map_marker_click

    if("group" %in% names(click_info)){
      if(click_info$group == 'Events'){
        clicked_marker$lat = click_info$lat
        clicked_marker$lng = click_info$lng
      }
    }
  })
  
  ## This is where we show the counted value
  output$carpark_count = renderText({
    count = count_data_within_radius()
    if (!is.null(count)) {
      return(count[1])
    } else {
      return(NA)
    }
  })
  
  output$train_count = renderText({
    count = count_data_within_radius()
    if (!is.null(count)) {
      return(count[2])
    } else {
      return(NA)
    }
  })
  
  
  output$tram_count = renderText({
    count = count_data_within_radius()
    if (!is.null(count)) {
      return(count[3])
    } else {
      return(NA)
    }
  })
  
  output$citywork_count = renderText({
    count = count_data_within_radius()
    if (!is.null(count)) {
      return(count[4])
    } else {
      return(NA)
    }
  })
  
  
  
}

######## Run App ######## 
shinyApp(ui, server, options=list(port=6247))

