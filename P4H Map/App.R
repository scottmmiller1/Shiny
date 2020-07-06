
# P4H Interactive Map Shiny App
library(shiny)
library(leaflet)

p4h <- read.csv("Data/P4H_coord.csv")
cof <- colorFactor(c("royalblue", "firebrick", "forestgreen", "goldenrod"), domain=c(1, 2, 3, 4))

ui <- fluidPage(
  leafletOutput("mymap", height=900),
  p()
)

server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
    p4h %>%
      leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      #addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      #addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
      addCircleMarkers(label = p4h$School, color = ~cof(Stage), radius = 4, opacity = .5, fillOpacity = .6, stroke = F,
                       #clusterOptions = markerClusterOptions(showCoverageOnHover = FALSE),
                       popup = paste(p4h$School, "<br>", "<br>",
                                     "Year 1 average pre-test score: ", p4h$Pre1, "<br>",
                                     "Year 1 average post-test score: ", p4h$Post1, "<br>", ifelse(p4h$Stage == 2, "<br>", ""),
                                     ifelse(p4h$Stage == 2, "Year 2 average pre-test score: ", ""), ifelse(p4h$Stage == 2, p4h$Pre2, ""), ifelse(p4h$Stage == 2, "<br>", ""), 
                                     ifelse(p4h$Stage == 2, "Year 2 average post-test score: ", ""), ifelse(p4h$Stage == 2, p4h$Post2, ""))) %>%
      addLegend("topleft", colors= c("royalblue", "firebrick", "forestgreen", "goldenrod"), labels=c("Year 1", "Year 2", "Year 3", "Graduated"), title="Training Stage") %>%
      setView(lat = 18.81228, lng = -72.94282, zoom = 9)
  })
}

shinyApp(ui, server)

