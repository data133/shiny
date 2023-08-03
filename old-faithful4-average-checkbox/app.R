# Title: Old Faithful geyser histogram
# Description: Histogram of waiting time 
# Details: uses a checkbox to show line for average waiting time
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)


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
      selectInput(inputId = "variable",
                  label = "Variable",
                  choices = names(faithful),
                  selected = "waiting"),
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      checkboxInput(inputId = "avg", 
                    label = "Show average", 
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
    x    <- faithful[, input$variable]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = paste0('Histogram of ', input$variable, ' times'))
    
    # decide whether to show line of average waiting time
    if (input$avg == TRUE) {
      avg_time = mean(x)
      abline(v = avg_time, col = "red", lwd = 3)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
