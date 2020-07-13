
# P4H Interactive Map Shiny App
library(shiny)
library(shinythemes)
library(leaflet)
library(tidyverse)

p4h <- read.csv("Data/P4H_coord.csv")
  p4h$Gap1 <- p4h$Gap1*100
cof <- colorFactor(c("royalblue", "firebrick", "forestgreen", "goldenrod"), domain=c(1, 2, 3, 4))

ui <- fluidPage(
  theme = shinytheme("cosmo"),
  titlePanel("P4H Global Interactive Training Map"), 
  sidebarLayout(    
    sidebarPanel(
      sliderInput('gap', 'Select Minimum Pre-Post Test Score Gap to Display:', 20, 70, 30, step = 1),
      selectInput('org', "Filter by Parent Organization:", choices = c("All", unique(p4h$Org)), selected = "All", multiple = F),
      selectInput('trainer', "Filter by Year 1 Trainers:",
                  choices = c("All", unique(p4h$tr1), unique(p4h$tr2), unique(p4h$tr3), unique(p4h$tr4), unique(p4h$tr5), unique(p4h$tr6), unique(p4h$tr7)), 
                  selected = "All", multiple = F),
      width = 3
    ),
    mainPanel(
      leafletOutput("mymap", height=700, width = 1050) 
    )),
  p()
)

server <- function(input, output, session) {

  
  output$mymap <- renderLeaflet({
    p4h <- if(input$org == "All"){
      p4h
    } else {
      filter(p4h, Org == input$org)
    }
    p4h <- if(input$trainer == "All"){
      p4h
    } else {
      filter(p4h, tr1 == input$trainer | tr2 == input$trainer | tr3 == input$trainer | tr4 == input$trainer | 
                  tr5 == input$trainer | tr6 == input$trainer | tr7 == input$trainer)
    }
    p4h <- filter(p4h, Gap1 >= input$gap)
    
    validate(
      need(nrow(p4h) > 0, 'There are no data points that meet this criteria. Try expanding the minimum pre-post test score gap!'),
      need(input$trainer, 'Please select at least one trainer.')
    )
    
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
      setView(lat = 18.81228, lng = -72.94282, zoom = 8)
  })
}

shinyApp(ui, server)

