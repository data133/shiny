# title: Univariate exploration of Iris data.
# description: Graphs a histogram, and computes descriptive statistics
# for a selected variable from the iris data.
# author: Gaston Sanchez
# date: Sep-22


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)


# =======================================================
# Define UI for graphing histograms, and computing summary stats
# =======================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Iris Data"),
  
  # Sidebar with a select-box input
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variable", 
                  label = "Select a variable", 
                  choices = names(iris)[-5], 
                  selected = "Sepal.Length"),
      sliderInput(inputId = "bins",
                  label = "Number of bins",
                  min = 1, 
                  max = 30,
                  value = 10)
    ), # closes sidebarPanel of inputs
    
    # Outputs: histograms, and table of summary statistics
    mainPanel(
      h3("Histograms"),
      plotOutput(outputId = "graphic"),
      hr(),
      h3("Summary Stats"),
      tableOutput(outputId = "summary")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ==============================================================
# Server logic to draw a histograms, and compute summary stats
# ==============================================================
server <- function(input, output) {
  
  # output histogram
  output$graphic <- renderPlot({
    # notice the use of "tidy evaluation" when mapping the variable!!!
    ggplot(iris, aes(x = .data[[input$variable]])) +
      geom_histogram(bins = input$bins, color = "white", aes(fill = Species)) +
      facet_wrap(~ Species) +
      theme(legend.position = "none")
  })
  
  
  # output table
  output$summary <- renderTable({
    # notice the use of "tidy evaluation" when referring to the variable!!!
    iris %>%
      group_by(Species) %>%
      summarise(
        min = min(.data[[input$variable]]),
        mean = mean(.data[[input$variable]]),
        sd = sd(.data[[input$variable]]),
        max = max(.data[[input$variable]])
      )
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
