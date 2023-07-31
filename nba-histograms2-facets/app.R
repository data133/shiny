# Title: Histograms of NBA variables
# Description: Shiny app that graphs a histogram (via ggplot2)
# Details: allows you to facet by team or position
# Author: Gaston Sanchez
# Date: Spring 2023
# Data: NBA players


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)


# ===============================================
# Data
# ===============================================
dat = read_csv("../data/nba2022-clean.csv")

# quantitative variables
variables = c(
  'height', 'weight', 'age', 'experience', 'salary',
  'points3', 'points2', 'points1', 'total_rebounds',
  'assists', 'blocks', 'turnovers')


# =======================================================
# Define UI for application that graphs univariate plots
# =======================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Histograms of NBA Players' Data"),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      # input widgets
      selectInput(inputId = "variable",
                  label = "Select variable:", 
                  choices = variables, 
                  selected = "height"),
      sliderInput(inputId = "bins",
                  label = "bins:",
                  min = 1, 
                  max = 30, 
                  step = 1, 
                  value = 10),
      selectInput(inputId = "facet_by",
                  label = "Facet by:",
                  choices = c("none",
                              "team",
                              "position"), 
                  selected = "none")
    ),  # closes sidebarPanel of inputs
    
    # -------------------------------------------------------
    # Main Panel with output: plot of the generated distribution
    # -------------------------------------------------------
    mainPanel(
      plotOutput(outputId = "graphic")
    )
    
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the distribution
# ======================================================
server <- function(input, output) {
  
  output$graphic <- renderPlot({
    gg = ggplot(dat, aes_string(x = input$variable)) +
      geom_histogram(bins = input$bins, fill = "#3B76F5", color = "white") +
      labs(title = paste0(input$variable, " histogram")) +
      theme_minimal()
    
    if (input$facet_by == "position") {
      gg + facet_wrap(. ~ position)
    } else if (input$facet_by == "team") {
      gg + facet_wrap(. ~ team)
    } else {
      # no facets
      gg
    }
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
