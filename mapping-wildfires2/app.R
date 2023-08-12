# Title: Mapping Forest Fires in California
# Description: Map of Fire Perimeters, and table of top-10 largest fires
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
fire_perims = st_read(
  paste0("../data/California_Fire_Perimeters/",
         "California_Fire_Perimeters__1950__.shp"))

cal_perims = fire_perims |>
  filter(STATE == "CA")


# ===========================================================
# Define UI for application that graphs a map of fires
# ===========================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Forest Fires in California"),
  
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
      plotOutput(outputId = "graphic"),
      hr(),
      h4('Table of 10 largest fires'),
      tableOutput(outputId = 'table')
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the map
# ======================================================
server <- function(input, output) {
  
  # tibble of fires in a selected year
  # (this is a reactive expression!!!)
  dat = reactive({
    cal_perims |> 
      filter(YEAR_ == input$year)
  })
  
  
  # draw the map of fire perimeters
  output$graphic <- renderPlot({
    cal_counties_map +
      geom_sf(data = dat(), fill = "red", color = "orange") +
      labs(title = paste0("Fires in ", input$year))
  })
  
  
  # render table of selected fires
  output$table <- renderTable({
    # Because the cal-perimeters data is not a tibble, we need to 
    # convert it with as_tibble(); also the purpose of the 2nd select() 
    # is to avoid the 'geometry' values from being unnecessarily displayed
    as_tibble(dat() |>
      select(FIRE_NAME, YEAR_, ALARM_DATE, CONT_DATE, GIS_ACRES)) |>
      select(1:5) |>
      arrange(desc(GIS_ACRES)) |>
      slice_head(n = 10)
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
