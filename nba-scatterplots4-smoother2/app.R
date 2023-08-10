# Title: Scatterplots of NBA variables
# Description: Shiny app that graphs a scatterplot
# Details: allows you to color by position, and add smoother
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
dat = read_csv("nba2022-clean.csv")

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
      radioButtons(inputId = "position",
                  label = "Color by position?",
                  choices = c("no", "yes"), 
                  selected = "no"),
      radioButtons(inputId = "fit",
                   label = "Fit regression line?",
                   choices = c("no", "yes"), 
                   selected = "no")
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

    if (input$position == "no") {
      gg = ggplot(dat, aes_string(x = input$xvar, y = input$yvar)) +
        geom_point() +
        theme_minimal()
    } else {
      gg = ggplot(dat, aes_string(x = input$xvar, 
                             y = input$yvar, 
                             color = "position")) +
        geom_point() +
        theme_minimal()
    }
    
    if (input$fit == "yes") {
      gg = gg + stat_smooth(method = "lm", se = FALSE)
    }
    
    gg
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
