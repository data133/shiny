# Title: Binomial Distribution
# Description: Shiny app that graphs a Binomial probability distribution.
# Author: Gaston Sanchez
# Date: Spring 2023
# Refs: 
# - https://en.wikipedia.org/wiki/Binomial_distribution


# ===============================================
# Packages
# ===============================================
library(shiny)


# ===========================================================
# Define UI for application that graphs Binomial distribution
# ===========================================================
ui <- fluidPage(

    # Application title
    titlePanel("Binomial Distribution"),

    # -------------------------------------------------------
    # Sidebar with input widgets 
    # -------------------------------------------------------
    sidebarLayout(
        sidebarPanel(
            sliderInput("trials",
                        "Number of trials:",
                        min = 1,
                        max = 10,
                        value = 5),
            sliderInput("prob_success",
                        "Probability of success:",
                        min = 0,
                        max = 1,
                        value = 0.5)
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
# Define server logic required to graph the distribution
# ======================================================
server <- function(input, output) {

    output$distPlot <- renderPlot({
      x = 0:input$trials
      probs = dbinom(x, size = input$trials, prob = input$prob_success)
      barplot(probs, border = NA, las = 1, names.arg = x)
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
