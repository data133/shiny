# Title: Mapping Forest Fires in California
# Description: Map of Fire Perimeters
# Data source: https://gis.data.ca.gov/ 
# Details: uses a slider input to select a given year
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)  # for syntactic manipulation of tables
library(sf)         # provides classes and functions for vector data
library(maps)       # basic map data sets


# ===============================================
# Auxiliary objects
# ===============================================
# Map of US counties (from package "maps") as an "sf" object
counties_sf = st_as_sf(map(database = "county", plot = FALSE, fill = TRUE))

# selecting California counties
cal_counties_sf = subset(
  counties_sf, 
  str_detect(counties_sf$ID, pattern = "california(?=,)"))

# ggplot Map of California counties
# (to be used as our main canvas map)
cal_counties_map = ggplot() +
  geom_sf(data = cal_counties_sf, fill = "black") + 
  theme(panel.background = element_blank())
  

# Load Data (Shape files)
fire_perims = st_read("../data/California_Fire_Perimeters/")

cal_perims = fire_perims |>
  filter(STATE == "CA")


# ===========================================================
# Define UI for application that graphs a map of fires
# ===========================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Wildfires in California"),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "year",
                  label = "Year:",
                  sep = "", # no separator between thousands places
                  min = 1950,
                  max = 2020,
                  value = 2000)
    ),
    
    # ----------------------------------------------------------
    # Main Panel with output: plot map of forest fires
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
    # fires in a selected year
    dat <- cal_perims |>
      filter(YEAR_ == input$year)
    
    # draw the map of fire perimeters
    cal_counties_map +
      geom_sf(data = dat, fill = "red", color = "orange") +
      labs(title = paste0("Fires in ", input$year))
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
