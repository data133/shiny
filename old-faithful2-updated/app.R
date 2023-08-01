# Title: Old Faithful geyser histograms
# Description: Histograms of variables from Old Faithful 
# Details: uses a select input, and a slider input
# Author: Gaston Sanchez
# Date: Spring 2023


# ===============================================
# Packages
# ===============================================
library(shiny)


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
    x    <- faithful[ ,input$variable]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, 
         col = '#475CFF', 
         border = 'white',
         xlab = paste0(input$variable, ' time (in mins)'),
         main = paste0('Histogram of ', input$variable, ' times'))
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
