# Title: Basic Investing Simulator
# Description: Simulates investing a lump sum, and optional periodic
# contributions, for a number of years. The rate of return for every year
# is a variable rate that is randomly generated according to a normal distrib.
# Author: Gaston Sanchez
# Date: Summer 2023


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)


# ===========================================================
# Define UI for application that graphs investment timelines
# ===========================================================
ui <- fluidPage(
  
  titlePanel("Investing Simulator"),
  fluidRow(
    column(2,
           # initial amount and time (years)
           numericInput(inputId = 'initial', 
                        label = 'Initial Amount ($)', 
                        min=1, 
                        max=10000,
                        value = 100),
           numericInput(inputId = 'years', 
                        label = 'Years', 
                        min = 0, 
                        max = 50,
                        value = 10)
    ),
    column(4, offset = 0.4,
           # Contributions
           numericInput(inputId = 'contribution', 
                        label = 'Periodic Contribution amount ($)', 
                        min = 0, 
                        max = 5000,
                        value = 30)
    ),
    column(3,
           # Average return rate and volatility
           sliderInput(inputId = 'annual_rate', 
                       label = 'Average annual rate (in %)', 
                       min = 0, 
                       max = 30,
                       value = 10,
                       step = 0.1),
           sliderInput(inputId = 'annual_volatility', 
                       label = 'Average annual volatility (in %)', 
                       min = 0, 
                       max = 30,
                       value = 18,
                       step = 0.1),
    ),
    column(3,
           # simulation settings
           numericInput(inputId = 'repetitions', 
                        label = 'Repetitions', 
                        min = 1, 
                        max = 100,
                        value = 10),
           numericInput(inputId = 'seed', 
                        label = 'Random seed', 
                        min = 100, 
                        max = 50000,
                        value = 12345)
    )
  ),
  hr(),
  h4('Timelines'),
  plotOutput('plot'),
  
  hr(),
  h4('Summary Statistics'),
  verbatimTextOutput('stats')
) # closes fluidPage


# ======================================================
# Define server logic required to graph timelines
# ======================================================
server <- function(input, output) {
  
  balance_mat <- reactive({
    # translation
    set.seed(input$seed)
    n <- input$years
    rate_avg <- (input$annual_rate / 100)
    rate_sd <- (input$annual_volatility / 100)
    
    # periods (k=1 year, k=12 monthly)
    periods <- 1
    balances <- matrix(0, nrow = n*periods + 1, ncol = input$repetitions)
    
    for (rept in 1:input$repetitions) {
      balance <- rep(input$initial, n*periods + 1)
      counter <- 0
      
      for (k in 1:(n*periods)) {
        counter <- counter + 1
        if (counter == 1 | counter %% (periods + 1) == 0) {
          # rate of return for current year
          r <- rnorm(1, mean = rate_avg, sd = rate_sd)
        }
        # contribution at the end of period
        balance[k+1] <- input$contribution + balance[k] * (1 + r/periods)^1
      }
      balances[ ,rept] <- balance
    }
    colnames(balances) = paste0("sim-", 1:input$repetitions)
    balances
  })
  
  
  # converting balance matrix into data frame for ggplot
  dat_sim = reactive({
    tbl = as.data.frame(balance_mat())
    tbl$year = 0:input$years
    
    dat = pivot_longer(
      data = tbl, 
      cols = starts_with("sim"), 
      names_to = "simulation",
      values_to = "balance")
    
    dat
  })
  
  
  # timeline graph
  output$plot <- renderPlot({
    ggplot(data = dat_sim(), aes(x = year, y = balance, group = simulation)) +
      geom_line(color = "#77777755", linewidth = 1.25) +
      theme_minimal() +
      xlab("year")
  })
  
  
  # code for statistics
  output$stats <- renderPrint({
    # quantiles 10%, 20%, ..., 100%
    quants <- quantile(balance_mat()[input$years+1,], probs = seq(0.1, 1, 0.1))
    
    quant_df <- data.frame(
      quantile = paste0(seq(from = 10, to = 100, by = 10), "%"),
      end_amount = quants,
      row.names = 1:10
    )
    
    print(quant_df, print.gap = 3)
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)

