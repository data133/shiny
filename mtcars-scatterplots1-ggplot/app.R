# Stat 133
# Author: Gaston Sanchez
# Description: Shiny app that shows a scatterplot, including regression line,
# and faceting, using the package "ggplot2"
# Data: "mtcars"

library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Exploring Data mtcars"),

    # Sidebar with a slider input for size of dots
    sidebarLayout(
        sidebarPanel(
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
                         choices = list("no" = 1, 
                                        "yes" = 2), 
                         selected = 1),
            radioButtons(inputId = "facet", 
                         label = "Facet by transmission",
                         choices = list("no" = 1, 
                                        "yes" = 2), 
                         selected = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a scatterplot
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # draw the scatterplot
        p <- ggplot(data = mtcars, aes(x = .data[[input$xvar]], 
                                       y = .data[[input$yvar]])) +
               geom_point(size = input$size, 
                          alpha = input$alpha) + 
               theme_minimal()
        
        # display regression line
        if (input$regline == 2) {
            p <- p + stat_smooth(method = "lm", se = FALSE)
        }
        
        # facet by transmission
        if (input$facet == 1) {
            p
        } else {
            p + facet_wrap(. ~ am)
        }
            
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
