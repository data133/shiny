# Title: Exploring scatterplots of mtcars data
# Description: Shiny app that shows a scatterplot, including regression line,
# and faceting, using the package "ggplot2", and rendering via ggplotly().
# Details: The layout of this app is a shiny dashboard using functions from
# the package "bslib"
# Data: "mtcars"
# Author: Gaston Sanchez
# Date: Fall 2023


# =======================================================
# Packages (you can use other packages if you want)
# =======================================================
library(shiny)
library(bslib)     # for creating nice shiny dashboards
library(tidyverse) # for data manipulation and graphics
library(plotly)    # for web-interactive graphics
library(DT)        # to work with HTML table widgets


# =======================================================
# Define UI for application
# =======================================================
ui <- page_sidebar(
  title = "Exploring mtcars",
  fillable = FALSE,
  
  # -------------------------------------------------------
  # Bootstrap theme
  # (feel free to comment-out the theme commands)
  # -------------------------------------------------------
  theme = bs_theme(
    version = 5,
    bootswatch = "lumen",
    base_font = font_google("Inter")
  ),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebar = sidebar(
    title = "Inputs",
    selectInput(inputId = "xvar", 
                label = "variable for x-axis", 
                choices = names(mtcars)[1:7], 
                selected = 'mpg'),
    selectInput(inputId = "yvar", 
                label = "variable for y-axis", 
                choices = names(mtcars)[1:7], 
                selected = 'hp'),
    sliderInput(inputId = "size",
                label = "size of dots:",
                min = 0.1,
                max = 10,
                value = 3),
    sliderInput(inputId = "alpha",
                label = "transparency of dots:",
                min = 0,
                max = 1,
                value = 0.5),
    radioButtons(inputId = "regline", 
                 label = "Show regression line?",
                 choices = c("no", "yes"), 
                 selected = "no"),
    radioButtons(inputId = "facet", 
                 label = "Facet by transmission",
                 choices = c("no", "yes"), 
                 selected = "no")
  ), # closes sidebar (of inputs)
  
  # -------------------------------------------------------
  # Main content area with outputs: plots and table
  # Note: outputs are wrapped inside cards() 
  # -------------------------------------------------------
  card(
    card_header("Scatterplot"),
    height = 500,
    plotlyOutput(outputId = "plot")
  ),
  card(
    card_header("Table"),
    height = 600,
    style = "resize:vertical;",
    card_body(
      min_height = 500,
      dataTableOutput(outputId = "table")
    )
  )
  
) # closes page_sidebar (UI)


# ======================================================
# Define server logic
# ======================================================
server <- function(input, output) {
  
  # ------------------------------------------------------------
  # Scatterplot
  # ------------------------------------------------------------
  output$plot <- renderPlotly({
    # draw the scatterplot
    p <- ggplot(data = mtcars, aes(x = .data[[input$xvar]],
                                   y = .data[[input$yvar]])) +
      geom_point(size = input$size, color = "#387EFF", 
                 alpha = input$alpha) + 
      theme_minimal()
    
    # display regression line
    if (input$regline == "yes") {
      p <- p + stat_smooth(method = "lm", se = FALSE)
    }
    
    # facet by transmission
    if (input$facet == "no") {
      p +
        labs(title = paste(input$xvar, "and", input$yvar))
    } else {
      p + facet_wrap(. ~ am) +
        labs(title = paste(input$xvar, "and", input$yvar, "by transmission"))
    }
  })
  
  
  # ------------------------------------------------------------
  # Table
  # ------------------------------------------------------------
  output$table <- renderDataTable({
    mtcars |>
      select(input$xvar, input$yvar, am)
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
