# Title: Mapping Storms
# Description: Map of North Atlantic with trajectories of tropical storms 
# Details: uses a slider input to select a given year
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)      # for syntactic manipulation of tables
library(sf)             # provides classes and functions for vector data
library(rnaturalearth)  # map data sets from Natural Earth


# ===============================================
# Auxiliary objects
# ===============================================
# natural earth world country polygons
world_countries = ne_countries(returnclass = "sf")

# ggplot object for north Atlantic map
# (this is our "canvas" on which storms will be added in the 'server' part)
atlantic_map = ggplot(data = world_countries) +
  geom_sf() +
  coord_sf(xlim = c(-110, 0), ylim = c(5, 65)) +
  theme(panel.background = element_blank())


# ===========================================================
# Define UI for application that graphs a map of storms
# ===========================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("North Atlantic Tropical Cyclones"),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "year",
                  label = "Year:",
                  sep = "", # no separator between thousands places
                  min = 1975,
                  max = 2021,
                  value = 1975)
    ),
    
    # ----------------------------------------------------------
    # Main Panel with output: plot map of storms
    # ----------------------------------------------------------
    mainPanel(
      plotOutput(outputId = "graphic")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the map
# ======================================================
server <- function(input, output) {
  
  output$graphic <- renderPlot({
    # storms in a selected year
    dat <- filter(storms, year == input$year)
    
    # draw the map with trajectories of storms
    atlantic_map +
      geom_point(
        data = dat, 
        aes(x = long, y = lat, group = name, color = name)) +
      geom_path(
        data = dat, 
        aes(x = long, y = lat, group = name, color = name))
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
