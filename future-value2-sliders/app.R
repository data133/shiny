# Title: Future Value (compound interest)
# Description: Shiny app that graphs a FV timeline
# Details: uses three slider input widgets
# Author: Gaston Sanchez
# Date: Spring 2023
# Refs: 
# - https://www.investopedia.com/terms/f/futurevalue.asp


# ===============================================
# Packages
# ===============================================
library(shiny)


# ===========================================================
# Define UI for application that graphs a FV timeline
# ===========================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Future Value"),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "amount",
                  label = "Initial Amount",
                  min = 1,
                  max = 10000,
                  step = 100,
                  value = 1000),
      sliderInput(inputId = "rate",
                  label = "Interest Rate (%)",
                  min = 0,
                  max = 10,
                  step = 0.1,
                  value = 5),
      sliderInput(inputId = "years",
                  label = "Number of Years",
                  min = 1,
                  max = 50,
                  value = 10)
    ),
    
    # -------------------------------------------------------
    # Main Panel with output: plot of the generated distribution
    # -------------------------------------------------------
    mainPanel(
      plotOutput(outputId = "graphic")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the timeline
# ======================================================
server <- function(input, output) {
  
  output$graphic <- renderPlot({
    time = 0:input$years
    fv = input$amount * (1 + input$rate/100)^time
    # main timeline
    plot(x = time, 
         y = fv, 
         type = "l",            # line (type of plot)
         lwd = 2,               # line width
         las = 1,               # style of axis labels
         col = "blue",          # color
         xlab = "time (years)", # x-axis label
         ylab = "amount",       # y-axis label
         main = "Future Value"  # title
    )
    # add points
    points(x = time, y = fv, col = "blue", pch = 20)
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
