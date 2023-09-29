# title: NBA Top-n players
# description: Creates barcharts of a given numeric variable from NBA data
# author: Gaston Sanchez
# date: Fall 2023


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)


# ===============================================
# NBA data (quick & dirty import)
# ===============================================
dat = read_csv("../data/nba2022-clean.csv")


# =======================================================
# Define UI for graphing barchart, and table
# =======================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("NBA Data"),
  
  # -------------------------------------------------------
  # Sidebar with a select-box input, and a slider input
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variable", 
                  label = "Select a variable", 
                  choices = names(dat)[-(1:3)], 
                  selected = "height"),
      sliderInput(inputId = "n",
                  label = "Top number of players",
                  min = 1,
                  max = 10,
                  value = 5)
    ),
    
    # -------------------------------------------------------------
    # Main Panel with outputs: barchart, and table of top-n players
    # -------------------------------------------------------------
    mainPanel(
      h3("Top-n players"),
      plotOutput(outputId = "graphic"),
      hr(),
      h3("Table"),
      tableOutput(outputId = "table")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ==============================================================
# Server logic to draw barchart, and compute top-n table
# ==============================================================
server <- function(input, output) {
  
  # table of top-n players (this a reactive conductor!!!)
  topn = reactive({
    dat |>
    select(player, team, .data[[input$variable]]) |>
    arrange(desc(.data[[input$variable]])) |>
    slice_head(n = input$n)
  })
  
  # output graphic
  # (notice the use of the reactive conductor, as well as tidy evaluation)
  output$graphic <- renderPlot({
    ggplot(topn(), aes(y = reorder(player, .data[[input$variable]]), 
                       x = .data[[input$variable]])) +
      geom_col() +
      labs(y = "player")
  })
  
  # output table
  # (notice the use of the reactive conductor)
  output$table <- renderTable({
    topn()
  })
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
