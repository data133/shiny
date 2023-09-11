# Title: Coin Toss
# Description: Shiny app that simulates tossing a coin,
# and displays a linegraph to visualize the proportion
# of heads over a number of tosses
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)


# =======================================================
# Define UI for application that graphs a timeline
# =======================================================
ui <- fluidPage(

    # Application title
    titlePanel("Tossing a coin"),

    # Sidebar with inputs
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "heads",
                        label = "Probability of heads:",
                        min = 0,
                        max = 1,
                        value = 0.5),
            sliderInput(inputId = "times",
                        label = "Number of tosses:",
                        min = 1,
                        max = 5000,
                        value = 30),
            numericInput(inputId = "seed", 
                         label = "Random seed:",
                         value = 123,
                         step = 1),
            hr(),
            tableOutput(outputId = "proportions")
        ),

        # -------------------------------------------------------
        # Main Panel with output: plot of timeline
        # -------------------------------------------------------
        mainPanel(
          hr(),
          h3("Timeline: Cumulative Proportion of Heads"),
          plotOutput("plot")
        )
        
    ) # closes sidebarLayout
) # closes fluidPage


# ======================================================
# Define server logic required to graph the timeline
# ======================================================
server <- function(input, output) {

  # vector of coin tosses (e.g. heads, tails)
  tosses <- reactive({
      set.seed(input$seed)
      coin <- c('heads', 'tails')
      sample(coin, size = input$times, 
            replace = TRUE, 
            prob = c(input$heads, 1 - input$heads))
  })
  
  # cumulative proportion of heads
  propheads <- reactive(
      cumsum(tosses() == 'heads') / 1:input$times
  )
  
  # timeline plot 
  output$plot <- renderPlot({
      plot(propheads(), 
           type = "l", 
           col = "blue",
           lwd = 2, 
           las = 1, 
           ylim = c(0, 1), 
           xlab = "number of tosses",
           ylab = "proportion of heads")
      abline(h = 0.5, lty = 2, col = "gray30")
  })
  
  # table of frequencies
  output$proportions <- renderTable(
      table(tosses()) / input$times
  )

} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
