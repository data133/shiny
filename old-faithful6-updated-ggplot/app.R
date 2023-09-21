# Title: Old Faithful geyser histograms
# Description: Histograms---via ggplot---of variables from Old Faithful 
# Details: uses a select input, and a slider input
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)


# ===========================================================
# Define UI for application that graphs a histogram
# ===========================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Old Faithful"),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variable",
                  label = "Variable",
                  choices = names(faithful),
                  selected = "waiting"),
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 30,
                  value = 10)
    ),
    
    # ----------------------------------------------------------
    # Main Panel with output: plot of the generated distribution
    # ----------------------------------------------------------
    mainPanel(
      plotOutput(outputId = "graphic")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the histogram
# ======================================================
server <- function(input, output) {
  
  output$graphic <- renderPlot({
    # generate bins based on input$bins from ui.R
    ggplot(data = faithful, aes(x = .data[[input$variable]])) +
      geom_histogram(bins = input$bins, color = "white", fill = "#1967df") +
      labs(title = paste0("Histogram of ", input$variable, " times"),
           x = paste0(input$variable, " time (mins)"))
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
