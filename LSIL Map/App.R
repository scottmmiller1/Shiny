
# LSIL Interactive Map Shiny App
library(shiny)
library(leaflet)

lsil <- read.csv("Data/LSIL_map.csv")
cof <- colorFactor(c("royalblue", "firebrick"), domain=c(1, 0))

ui <- fluidPage(
  leafletOutput("mymap", height=900),
  p()
)

server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
    lsil %>%
      leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      #addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      #addLayersControl(baseGroups = c("Toner Lite", "World Imagery")) %>%
      addCircleMarkers(label = lsil$idx, color = ~cof(treat), radius = 4, opacity = .5, fillOpacity = .65, stroke = F,
                       popup = paste(lsil$idx, "<br>", "<br>", 
                                     "Number of members: ",lsil$MAN3, "<br>", 
                                     "2018 Annual revenue per member: $", lsil$totrev_member, " (USD)", "<br>",
                                     "Coordinates goat sales: ", ifelse(lsil$CO_SER15 == 1, "Yes", "No"), "<br>",
                                     "Region: ",lsil$region, "<br>",
                                     "District: ",lsil$district, sep = "")) %>%
      addLegend("topright", colors= c("royalblue", "firebrick"), labels=c("Treatment", "Control"), title="VCC Assignment") %>%
      setView(lat = 27.80930, lng = 84.30950, zoom = 7.25)
  })
}

shinyApp(ui, server)