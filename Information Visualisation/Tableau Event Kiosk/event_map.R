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

event = read.csv('event.csv')

####################
######## UI ######## 
####################

ui = page_fluid(
  leafletOutput("event_map")
)

########################
######## Server ######## 
########################

server = function(input, output, session) {
  
  ## This where it communicates with Tableau input
  getQueryString = reactive({
    parseQueryString(session$clientData$url_search)
  })
  
  getChosenType = reactive({
    result = c()
    if("type" %in% names(getQueryString())){
      result = strsplit(getQueryString()$type,",")
    }
    result
  })
  
  getChosenName = reactive({
    result = c()
    if("event" %in% names(getQueryString())){
      result = strsplit(getQueryString()$event,",")
    }
    result
  })
  
  getChosenFree = reactive({
    result = c()
    if("free" %in% names(getQueryString())){
      result = strsplit(getQueryString()$free,",")
    }
    result
  })
  
  
  getReset = reactive({
    result = c()
    if("reset" %in% names(getQueryString())){
      result = strsplit(getQueryString()$reset,",")
    }
    result
  })
  
  ## This function is to convert 0,1 value into text
  convertFreeText = function(text){
    if (text == 0) {
      return("No")
    } else {
      return("Yes")
    }
  }
  
  ## This is how the map is drawn
  create_map = function(){
    if(is.null(getChosenType())){
      event_filter = event
    }else{
      event_filter = event[event$type %in% getChosenType(),]
    }
  
    if(is.null(getChosenName())){
      event_filter = event_filter
    }else{
      event_filter = event_filter[event_filter$event_name %in% getChosenName(),]
    }
    
    if(is.null(getChosenFree())){
      event_filter = event_filter
    }else{
      free = '1'
      if(getChosenFree() == 'No'){
        free = '0'
      }
      event_filter = event_filter[event_filter$Free %in% free,]
    }
    
    if(is.null(getReset())){
      event_filter = event_filter
    }else{
      event_filter = event
    }
   
    original_map = leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addScaleBar(position = "bottomleft") %>%
      setView(lng = 144.9631, lat = -37.8136, zoom = 14) %>%
      addAwesomeMarkers(data = event_filter, lat=~lat, lng=~lng,
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
      ) %>%
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#3D535D",
        completedColor = "#7D4479")
    return (original_map)
  }


  ## This is where the map render, it will consider input from tableau before rendering
  output$event_map = renderLeaflet({
    map = create_map()
    map
  }) 
  

}

######## Run App ######## 
shinyApp(ui, server, options=list(port=6246))

