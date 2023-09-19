# Stat 133, Spring 2020
# Author: Gaston Sanchez
# Description: Shiny app that shows a scatterplot, 
#     including regression line, background themes,
#     and color picker.
# Data: "mtcars" 


# ===============================================
# Packages
# ===============================================
library(shiny)
library(ggplot2)
library(colourpicker)


# ===========================================================
# Define UI for application that draws a scatter plot
# ===========================================================
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
                  value = 4),
      h5("Regression Line"),
      checkboxInput(inputId = "regline", 
                   label = "Show regression line",
                   value = FALSE),
      radioButtons(inputId = "theme",
                   label = "Background theme",
                   choices = list(
                     "default" = "default",
                     "classic" = "classic",
                     "minimal" = "minimal",
                     "bw" = "bw"
                   )),
      colourInput(inputId = "col",
                  label = "Select color",
                  value = "#555555",
                  allowTransparent = TRUE)
    ),
    
    # Show a plot of the selected variables
    mainPanel(
      plotOutput(outputId = "distPlot")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to draw a scatterplot
# ======================================================
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # draw the scatterplot
    p <- ggplot(data = mtcars, aes(x = .data[[input$xvar]], 
                                   y = .data[[input$yvar]])) +
      geom_point(size = input$size,
                 color = input$col)
    
    # display regression line
    if (input$regline) {
      p <- p + stat_smooth(method = "lm", se = FALSE)
    }
    
    # choose background theme
    if (input$theme == "default") {
      p
    } else if (input$theme == "classic") {
      p + theme_classic()
    } else if (input$theme == "minimal") {
      p + theme_minimal()
    } else {
      p + theme_bw()
    }
     
  })
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
