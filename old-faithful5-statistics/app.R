# Title: Old Faithful geyser histogram
# Description: Histogram of waiting time 
# Details: 
# - includes an auxiliary function to compute descriptive statistics
# - uses a checkbox to display lines for descriptive statistics
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)


# ===============================================
# Auxiliary function
# ===============================================
# Descriptive Statistics
descriptive = function(x) {
  c(quantile(x, prob = 0.25),
    mean(x),
    median(x),
    quantile(x, prob = 0.75))
}


# ===========================================================
# Define UI for application that graphs a histogram
# ===========================================================
ui <- fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      checkboxInput(inputId = "avg", 
                    label = "Show stats", 
                    value = FALSE)
    ),
    
    # ----------------------------------------------------------
    # Main Panel with output: plot of the generated distribution
    # ----------------------------------------------------------
    mainPanel(
      plotOutput("distPlot")
    )
  ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the histogram
# ======================================================
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
    
    # decide whether to show lines of descriptive statistics
    if (input$avg == TRUE) {
      stats = descriptive(x)
      abline(v = stats, col = "red", lwd = 3, lty = 2)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
