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

##########################
######## Load Data #######
##########################

## This is where you could set you working directory
# setwd('~/Desktop/GEOM90007_Assignment3_Group84')
##

carPark = read.csv('offStreetCarPark.csv')
train = read.csv('train.csv')
tram = read.csv('tram.csv')
event = read.csv('event.csv')

carPark = na.omit(carPark)
train = na.omit(train)
tram = na.omit(tram)

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


####################
######## UI ######## 
####################

ui = page_fluid(
  leafletOutput("data_map")
)

########################
######## Server ######## 
########################

server = function(input, output, session) {
  ## Keep clicked transportation markers and events in reactiveVal
  currentData = reactiveVal(NULL)
  currentEvent = reactiveVal(NULL)
  
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
  
  getReset = reactive({
    result = c()
    if("event" %in% names(getQueryString())){
      result = strsplit(getQueryString()$reset,",")
    }
    result
  })
  
  ## This is how the default map is drawn
  original_map = leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    addScaleBar(position = "bottomleft") %>%
    setView(lng = 144.9631, lat = -37.8136, zoom = 14) %>%
    addAwesomeMarkers(data = train, 
                      lat=~Latitude, 
                      lng=~Longitude,
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
    addLayersControl(overlayGroups = c("Train","Car Park","Tram"),
                     options = layersControlOptions(collapsed = FALSE)) %>%
    hideGroup("Train") %>%
    hideGroup("Car Park") %>%
    hideGroup("Tram") %>%
    addMeasure(
      position = "bottomleft",
      primaryLengthUnit = "meters",
      primaryAreaUnit = "sqmeters",
      activeColor = "#3D535D",
      completedColor = "#7D4479")
  
  
  ## This function is to convert 0,1 value into text
  convertFreeText = function(text){
    if (text == 0) {
      return("No")
    } else {
      return("Yes")
    }
  }
  
  ## This is where the map render, it will consider input from tableau before rendering
  output$data_map = renderLeaflet({
    map = original_map
    
    if(!is.null(getChosenName())){
      currentEvent = event[event$event_name %in% getChosenName(),]
      currentEvent(event[event$event_name %in% getChosenName(),])

      map = map %>%
        addAwesomeMarkers(data = currentEvent, lat=~lat, lng=~lng,
                          group = 'Events',
                          icon=~awesomeIcons(
                            icon = icon,
                            iconColor = '#ffffff',
                            markerColor = color,
                            library = 'fa'
                          ),
                          popup = ~paste(
                            "<b>",event_name,"</b><br/>",
                            "Free Event: ", lapply(Free, convertFreeText),"<br/>",
                            "Price: ", price, "<br/>",
                            "Contact: ",contact,"<br/>",
                            "Visit Website: <a href=",link,">",link,"</a>"
                          )
                          )%>%
        setView(lng = currentEvent$lng, lat = currentEvent$lat, zoom = 14)
    }else{
      map = map %>%
        addAwesomeMarkers(data = event, lat=~lat, lng=~lng,
                          group = 'Events',
                          icon=~awesomeIcons(
                            icon = icon,
                            iconColor = '#ffffff',
                            markerColor = color,
                            library = 'fa'
                          ),
                          popup = ~paste(
                            "<b>",event_name,"</b><br/>",
                            "Free Event: ", lapply(Free, convertFreeText),"<br/>",
                            "Price: ", price, "<br/>",
                            "Contact: ",contact,"<br/>",
                            "Visit Website: <a href=",link,">",link,"</a>"
                          )
        )
    }
    

    map
  }) 
  
  
  ## This is where the marker is highlight and draw a line
  myLeafletProxy = leafletProxy(mapId = "data_map", session)
  observeEvent(input$data_map_marker_click,{
    clicked_point = input$data_map_marker_click

    removeMarker(map = myLeafletProxy, layerId = clicked_point$id)
    removeShape(map = myLeafletProxy, layerId = "line")


    if("group" %in% names(clicked_point)){
      if(clicked_point$group == 'Train'){
        currentData = train[train['station'] == clicked_point$id,]
        
        addAwesomeMarkers(map = myLeafletProxy,
                          lat=currentData$Latitude,
                          lng=currentData$Longitude,
                          layerId = currentData$station,
                          group = 'Train',
                          icon=awesomeIcons(
                            icon = 'train',
                            iconColor = '#ffffff',
                            markerColor ='orange',
                            library = 'fa'
                          ),
                          popup = paste("<b>", currentData$STOP_NAME,"</b>")
                          )
        addPolylines(
          map = myLeafletProxy,
          lat = c(currentEvent()$lat, currentData$Latitude),
          lng = c(currentEvent()$lng, currentData$Longitude),
          color = "orange",
          dashArray = "10, 10",
          layerId = 'lines',
          opacity = 1
        )
      }else if(clicked_point$group == 'Tram'){
        currentData = tram[tram['STOP_ID'] == clicked_point$id,]
        addAwesomeMarkers(map = myLeafletProxy,
                          lat=currentData$LATITUDE,
                          lng=currentData$LONGITUDE,
                          layerId = currentData$STOP_ID,
                          group = 'Tram',
                          icon=makeAwesomeIcon(
                            text = fa("train-tram"),
                            iconColor = '#ffffff',
                            markerColor = 'orange'
                          ),
                          popup = paste0("<b>", currentData$station,"</b>","<br/>","Lift: ",currentData$lift))
        addPolylines(
          map = myLeafletProxy,
          lat = c(currentEvent()$lat, currentData$LATITUDE),
          lng = c(currentEvent()$lng, currentData$LONGITUDE),
          color = "orange",
          dashArray = "10, 10",
          layerId = 'lines',
          opacity = 1
        )
      }
    }
    else{
      currentData = carPark[carPark['Property.ID'] == clicked_point$id,]
      addAwesomeMarkers(map = myLeafletProxy,
                        lat=currentData$Latitude,
                        lng=currentData$Longitude,
                        layerId = currentData$Property.ID,
                        group = 'Car Park',
                        icon=awesomeIcons(
                          icon = 'car',
                          iconColor = '#ffffff',
                          markerColor = 'orange',
                          library = 'fa'
                        ),
                        popup = paste0("<b>Car Park</b>","<br/>","Address: ",currentData$Building.address,
                                        "<br/>","Type: ",currentData$Parking.type,
                                        "<br/>","Spaces: ", currentData$Parking.spaces),
                        )
      addPolylines(
        map = myLeafletProxy,
        lat = c(currentEvent()$lat, currentData$Latitude),
        lng = c(currentEvent()$lng, currentData$Longitude),
        color = "orange",
        dashArray = "10, 10",
        layerId = 'lines',
        opacity = 1
      )
    }
  })
}

######## Run App ######## 
shinyApp(ui, server, options=list(port=6245))

