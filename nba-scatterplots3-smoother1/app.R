# Title: Scatterplots of NBA variables
# Description: Shiny app that graphs a scatterplot
# Details: allows you to add smoother ("lm" or "loess")
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
# Define UI for application that graphs scatterplots
# =======================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Scatterplots of NBA Players' Data"),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      # input widgets
      selectInput(inputId = "xvar",
                  label = "Select x-axis variable:", 
                  choices = variables, 
                  selected = "height"),
      selectInput(inputId = "yvar",
                  label = "Select y-axis variable:", 
                  choices = variables, 
                  selected = "weight"),
      radioButtons(inputId = "fit",
                   label = "Fit regression line?",
                   choices = c("none", "lm", "loess"), 
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
    
    gg = ggplot(dat, aes(x = .data[[input$xvar]], y = .data[[input$yvar]])) +
      geom_point() +
      theme_minimal()
    # add smoother?
    if (input$fit == "lm") {
      # least-squares regression line
      gg = gg + stat_smooth(method = "lm", 
                            formula = 'y ~ x',
                            se = FALSE)
    } else if (input$fit == "loess") {
      # locally estimated scatterplot smoothing (loess)
      gg = gg + stat_smooth(method = "loess", 
                            formula = 'y ~ x',
                            se = FALSE)
    }
    # print plot
    gg
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
