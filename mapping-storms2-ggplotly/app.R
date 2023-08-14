# Title: Mapping Storms
# Description: Map of North Atlantic with trajectories of tropical storms 
# Details: uses a slider input to select a given year, and ggplotly
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)      # for syntactic manipulation of tables
library(sf)             # provides classes and functions for vector data
library(rnaturalearth)  # map data sets from Natural Earth
library(plotly)         # for interactive gaphics


# ===============================================
# Auxiliary objects
# ===============================================
# natural earth world country polygons
world_countries = ne_countries(returnclass = "sf")

# ggplot object for north atlantic map
atlantic = ggplot(data = world_countries) +
  geom_sf() +
  coord_sf(xlim = c(-110, 0), ylim = c(5, 70))


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
      plotlyOutput(outputId = "graphic")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the map
# ======================================================
server <- function(input, output) {
  
  output$graphic <- renderPlotly({
    # storms in a selected year
    dat <- filter(storms, year == input$year)
    
    # draw the map
    gg = atlantic +
      geom_point(
        data = dat,
        aes(x = long, y = lat, group = name, color = name)) +
      geom_path(
        data = dat,
        size = 2, # linewidth doesn't seem to work for ggplotly
        lineend = "round",
        alpha = 0.6,
        aes(x = long, y = lat, group = name, color = name)) +
      theme(panel.background = element_blank(),
            legend.position = "none")
    
    ggplotly(gg)
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
