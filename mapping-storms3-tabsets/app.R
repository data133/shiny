# Title: Tropical Cyclones in North Atlantic (NA)
# Description: Web-app to visualize the paths of storms in NA, some
# relevant attributes, and overall statistics.
# Author: Gaston Sanchez
# Date: Spring 2024


# =======================================================
# Packages
# =======================================================
library(shiny)
library(tidyverse)    # data wrangling and graphics
library(lubridate)    # for working with dates
library(sf)           # for working with geospatial vector-data
library(leaflet)      # web interactive maps
library(plotly)       # web interactive graphics


# =======================================================
# Data
# (Manipulations that don't depend on any input widget)
# =======================================================
# for demo purposes, in this example we use storms data
dat <- storms

# adding columns "date", and "id"
dat <- dat |>
  mutate(date = as.Date(paste0(year, "-", month, "-", day)),
         id = paste0(name, "-", year))

# auxiliary table with storm category based on maximum wind
aux_wind_category <- dat |>
  group_by(id) |>
  summarise(max_wind = max(wind)) |>
  mutate(wind_cat = case_when(
    max_wind >= 137 ~ 5,
    max_wind >= 113 ~ 4,
    max_wind >= 96 ~ 3,
    max_wind >= 83 ~ 2,
    max_wind >= 64 ~ 1,
    max_wind >= 34 ~ 0,
    .default = -1))

# merging to have a column for storm category (based on maximum wind)
# and adding color (based on category)
dat <- dat |> 
  inner_join(aux_wind_category, by="id") |>
  mutate(color = case_when(
    wind_cat == 5 ~ "#a50f15",
    wind_cat == 4 ~ "#de2d26",
    wind_cat == 3 ~ "#fb6a4a",
    wind_cat == 2 ~ "#fc9272",
    wind_cat == 1 ~ "#fcbba1",
    .default = "#fee5d9",
  ))



# ===============================================
# Define "ui" for application
# ===============================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Storms Data"),
  
  # -------------------------------------------------------
  # Input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      # ---------------------------------------------
      # input widgets applicable to first tab
      # ---------------------------------------------
      conditionalPanel(
        condition = "input.tabselected==1",
        h4("Map of storms"),
        sliderInput(inputId = "year_slider",
                    label = "Select a Year",
                    min = 1975,
                    max = last(dat$year),
                    value = 2010,
                    sep = ""),
        checkboxGroupInput(inputId = "category",
                           label = "Storm category",
                           choices = list("Category 1" = 1,
                                          "Category 2" = 2,
                                          "Category 3" = 3,
                                          "Category 4" = 4,
                                          "Category 5" = 5,
                                          "Other" = 6),
                           selected = c(1, 2, 3, 4, 5, 6)),
        selectInput(inputId = "tiles",
                    label = "Choose a tile",
                    choices = c("CartoDB.Positron",
                                "OpenStreetMap",
                                "Esri.WorldTerrain",
                                "Esri.WorldGrayCanvas",
                                "OpenTopoMap"),
                    selected = "CartoDB.Positron")
        # more tiles available at: 
        # https://leaflet-extras.github.io/leaflet-providers/preview/
      ), # closes conditionalPanel
      
      # ---------------------------------------------
      # input widgets applicable to second tab
      # ---------------------------------------------
      conditionalPanel(
        condition = "input.tabselected==2",
        h4("Table of storms"),
        selectInput(inputId = "year_select",
                    label = "Select a Year",
                    choices = 1975:last(dat$year),
                    selected = 2010),
        radioButtons(inputId = "topn",
                     label = "Option",
                     choices = c("top-5", "top-10", "top-15", "all"), 
                     selected = "all")
      ), # closes conditionalPanel
      
      # ---------------------------------------------
      # input widgets applicable to third tab
      # ---------------------------------------------
      conditionalPanel(
        condition = "input.tabselected==3",
        h4("Overall Summary"),
        radioButtons(inputId = "stats", 
                     label = "Choose statistic", 
                     choices = c("Number of storms",
                                 "Q1 Wind",
                                 "Median Wind",
                                 "Mean Wind",
                                 "Q3 Wind"),
                     selected = "Number of storms")
      ), # closes conditionalPanel
    ), # closes sidebarPanel
    
    # ----------------------------------------------------------
    # Main Panel with output tabs: map, table, and summary-plot
    # ----------------------------------------------------------
    mainPanel(
      tabsetPanel(
        type = "tabs",
        # first tab (map)
        tabPanel(title = "Map",
                 value = 1,
                 leafletOutput("map", height = 600)),
        # second tab (table)
        tabPanel(title = "Table",
                 value = 2,
                 h3("Storms Information"),
                 dataTableOutput(outputId = "table")),
        # third tab (summary plot)
        tabPanel(title = "Summary",
                 value = 3,
                 h3("Overall Summary"),
                 plotlyOutput(outputId = "plot")),
        # selected tab
        id = "tabselected"
      ) # closes tabsetPanel
    ) # closes mainPanel
    
  ) # closes sidebarLayout
) # closes fluidPage (UI)



# ===============================================
# Define server logic
# ===============================================
server <- function(input, output) {
  
  # -----------------------------------------------
  # Outputs for first TAB (i.e. map)
  # Leaflet map of storms in selected year
  # -----------------------------------------------
  output$map <- renderLeaflet({
    dat |>
      filter(year == input$year_slider) |>
      filter(wind_cat %in% input$category) |>
      mutate(label = paste0(name, ", ", month, "-", day)) |>
      leaflet() |>
      setView(lng = -55, lat = 42, zoom = 3) |>
      addProviderTiles(providers[[input$tiles]]) |>
      addCircles(lng = ~long,
                 lat = ~lat, 
                 color = ~color,
                 fillOpacity = 0.5,
                 radius = ~wind*1000,
                 weight = 1,
                 label = ~label) |>
      addLegend(position = "topleft", 
                colors = c("#a50f15", "#de2d26", "#fb6a4a", "#fc9272", "#fcbba1", "#fee5d9"),
                labels = c(5:1, "other"),
                title = "Category",
                opacity = 1)
  }) # closes renderLeaflet
  
  
  # ------------------------------------------------------------
  # Outputs for second TAB (i.e. table)
  # Table of information for storms in a selected year
  # ------------------------------------------------------------
  output$table <- renderDataTable({
    dat |>
      filter(year == input$year_select) |>
      group_by(name) |>
      summarise(days = as.duration(first(date) %--% last(date)) / ddays(1),
                max_wind = max(wind),
                min_pressure = min(pressure)) |>
      mutate(category = case_when(
        max_wind >= 137 ~ 5,
        max_wind >= 113 ~ 4,
        max_wind >= 96 ~ 3,
        max_wind >= 83 ~ 2,
        max_wind >= 64 ~ 1,
        max_wind >= 34 ~ 0,
        .default = -1)) |>
      arrange(name)
  }) # closes renderDataTable
  
  
  # ------------------------------------------------------------
  # Outputs for third TAB (i.e. plot)
  # Summary Plot (all years)
  # ------------------------------------------------------------
  output$plot <- renderPlotly({
    # all years
    dat_summary = dat |>
      group_by(year) |>
      summarise(num_storms = length(unique(id)),
                Q1_wind = quantile(wind, 0.25),
                med_wind = median(wind),
                avg_wind = round(mean(wind), 2),
                Q3_wind = quantile(wind, 0.75))
    
    gg = ggplot(data = dat_summary)
    
    if (input$stats == "Number of storms") {
      gg + 
        geom_col(aes(x = year, y = num_storms), fill = "skyblue")
    } else if (input$stats == "Q1 Wind") {
      gg + 
        geom_col(aes(x = year, y = Q1_wind), fill = "aquamarine2")
    } else if (input$stats == "Median Wind") {
      gg + 
        geom_col(aes(x = year, y = med_wind), fill = "orange")
    } else if (input$stats == "Mean Wind") {
      gg + 
        geom_col(aes(x = year, y = avg_wind), fill = "tomato")
    } else {
      gg + 
        geom_col(aes(x = year, y = Q3_wind), fill = "magenta2")
    }
  }) # closes renderPlotly
  
} # closes server



# ===============================================
# Run the application
# ===============================================
shinyApp(ui = ui, server = server)
