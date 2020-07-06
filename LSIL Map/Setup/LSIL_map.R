
library(shiny)
library(leaflet)

lsil <- read.csv("/Users/scottmiller/GitHub/Shiny/LSIL Map/Data/LSIL_map.csv")

cof <- colorFactor(c("royalblue", "firebrick"), domain=c(1, 0))

lsil %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  #addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  #addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
  addCircleMarkers(label = lsil$idx, color = ~cof(treat), radius = 4, opacity = .5, fillOpacity = .65, stroke = F,
                   #clusterOptions = markerClusterOptions(showCoverageOnHover = FALSE))  %>%
                   popup = paste("Number of members: ",lsil$MAN3, "<br>", 
                                 "2018 Annual revenue per member: $", lsil$totrev_member, " (USD)", "<br>",
                                 "Coordinates goat sales: ", ifelse(lsil$CO_SER15 == 1, "Yes", "No"), "<br>",
                                 "Region: ",lsil$region, "<br>",
                                 "District: ",lsil$district, sep = "")) %>%
  addLegend("bottomright", colors= c("royalblue", "firebrick"), labels=c("Treatment", "Control"), title="VCC Assignment") %>%
  setView(lat = 27.80930, lng = 84.30950, zoom = 7.25)