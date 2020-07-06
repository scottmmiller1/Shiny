
# Interactive Map
library("tidyverse")
library("leaflet")
library(dplyr)
library(shiny)
library(htmlwidgets)


#p4h <- read_csv("/Users/scottmiller/Desktop/ShinyMap/P4H_coord.csv")
#  p4h <- p4h %>% separate(GPS, c("Longitude","Latitude"), sep = ',')
#  p4h$Latitude <- as.numeric(p4h$Latitude)
#  p4h$Longitude <- as.numeric(p4h$Longitude)
#  p4h <- p4h[-61,]
#write.csv(p4h, "/Users/scottmiller/Desktop/ShinyMap/P4H_coord.csv")

  
p4h <- read.csv("/Users/scottmiller/Desktop/ShinyMap/Data/P4H_coord.csv")
  
p4h %>%
leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  #addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  #addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
  addCircleMarkers(label = p4h$School, radius = 7, opacity = .5, fillOpacity = .8, stroke = F,
             clusterOptions = markerClusterOptions(showCoverageOnHover = FALSE),
             popup = paste("Average pre-test score: ",p4h$Pre, "<br>", "Average post-test score: ", p4h$Post)) %>%
  setView(lat = 19.01228, lng = -72.94282, zoom = 8)

#saveWidget(P4H_Interactive, file="P4H_Interactive.html", selfcontained=FALSE)


