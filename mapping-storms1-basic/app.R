# Title: Mapping Storms
# Description: Plots a map of North Atlantic with trajectories of tropical 
# storms, and displays a table with the starting date of the storm.
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
  geom_sf(fill = "gray95") +
  coord_sf(xlim = c(-110, 0), ylim = c(5, 65)) +
  theme(panel.background = element_blank(),
        axis.ticks = element_blank(), # hide tick marks
        axis.text = element_blank()) + # hide degree values of lat & lon
  labs(x = "", y = "") # hide axis labels


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
                  label = "Select a Year:",
                  sep = "", # no separator between thousands places
                  min = 1975,
                  max = 2021,
                  value = 1975)
    ),
    
    # ----------------------------------------------------------
    # Main Panel with output: plot map of storms
    # ----------------------------------------------------------
    mainPanel(
      plotOutput(outputId = "plot_map"),
      hr(),
      dataTableOutput(outputId = "summary_table")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the map
# ======================================================
server <- function(input, output) {
  
  # reactive table of filtered storms
  tbl = reactive({
    # storms in a selected year
    storms %>% 
      filter(year == input$year)
  })
  
  # map of storms
  output$plot_map <- renderPlot({
    # draw the map with trajectories of storms
    atlantic_map +
      geom_point(
        data = tbl(), 
        aes(x = long, y = lat, group = name, color = name)) +
      geom_path(
        data = tbl(), 
        aes(x = long, y = lat, group = name, color = name))
  })

  # summary table
  output$summary_table <- renderDataTable({
    tbl() %>%
      group_by(name) %>%
      summarise(start_date = paste0(first(month), "-", first(day)))
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
