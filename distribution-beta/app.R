# Title: Beta Distribution
# Description: Shiny app that graphs probability density function of Beta dist.
# Author: Gaston Sanchez
# Date: Spring 2023
# Refs: 
# - https://en.wikipedia.org/wiki/Beta_distribution


# ===============================================
# Packages
# ===============================================
library(shiny)


# =======================================================
# Define UI for application that graphs Beta distribution
# =======================================================
ui <- fluidPage(

    # Application title
    titlePanel("Beta Distribution"),

    # -------------------------------------------------------
    # Sidebar with input widgets 
    # -------------------------------------------------------
    sidebarLayout(
        sidebarPanel(
          # parameters of Beta distribution: "alpha" and "beta"
            sliderInput(inputId = "a",
                        label = "alpha:",
                        min = 0,
                        max = 5,
                        value = 2.5, 
                        step = 0.01),
            sliderInput(inputId = "b",
                        label = "beta:",
                        min = 0,
                        max = 5,
                        value = 2.5, 
                        step = 0.01)
        ),  # closes sidebarPanel of inputs

        # -------------------------------------------------------
        # Main Panel with output: plot of the generated distribution
        # -------------------------------------------------------
        mainPanel(
           plotOutput(outputId = "distPlot")
        )

    ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the distribution
# ======================================================
server <- function(input, output) {

    output$distPlot <- renderPlot({
      # generate terms based on input$bins from ui.R
        x = seq(from = 0, to = 1, by = 0.01)
        constant = 1 / beta(input$a, input$b)
        y = constant * (x^(input$a - 1)) * ((1 - x)^(input$b - 1))
        plot(x, y, las = 1, type = "l", lwd = 3, col = "#3B76F5")
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
