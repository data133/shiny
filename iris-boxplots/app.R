# title: Univariate exploration of Iris data.
# description: Graphs a histogram, and computes descriptive statistics
# for a selected variable from the iris data.
# data: iris
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
      checkboxInput(inputId = "show",
                    label = "Show jittered points",
                    value = FALSE)
    ), # closes sidebarPanel of inputs
    
    # Outputs: histograms, and table of summary statistics
    mainPanel(
      h3("Boxplots"),
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
  
  # output graphic
  output$graphic <- renderPlot({
    p = ggplot(iris, aes(x = Species, y = .data[[input$variable]])) +
      geom_boxplot(aes(fill = Species)) +
      theme(legend.position = "none")
    
    if (input$show) {
      p + geom_jitter(width = 0.1)
    } else {
      p
    }
  })
  
  
  # output table
  output$summary <- renderTable({
    iris %>%
      group_by(Species) %>%
      summarise(
        min = min(.data[[input$variable]]),
        q1 = quantile(.data[[input$variable]], probs = 0.25),
        med = median(.data[[input$variable]]),
        q3 = quantile(.data[[input$variable]], probs = 0.75),
        max = max(.data[[input$variable]])
      )
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
