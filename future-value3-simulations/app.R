# Title: Basic Investing Simulator
# Description: Simulates investing a lump sum for a number of years. 
# The rate of return for every year is a variable rate that is randomly 
# generated according to a uniform distrib.
# Author: Gaston Sanchez
# Date: Spring 2024


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)


# ===========================================================
# Define UI for application that graphs investment timelines
# ===========================================================
ui <- fluidPage(
  
  titlePanel("Basic Investing Simulator"),
  fluidRow(
    column(4,
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
    column(4,
           # Minimum rate of return (for uniform distribution)
           sliderInput(inputId = 'min_rate', 
                       label = 'Minimum rate (in %)', 
                       min = -5, 
                       max = 0,
                       value = -5,
                       step = 1),
           # Maximum rate of return (for uniform distribution)
           sliderInput(inputId = 'max_rate', 
                       label = 'Maximum rate (in %)', 
                       min = 0, 
                       max = 15,
                       value = 10,
                       step = 1),
    ),
    column(4,
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
  dataTableOutput('stats')
) # closes fluidPage


# ======================================================
# Define server logic required to graph timelines
# ======================================================
server <- function(input, output) {
  
  balance_mat <- reactive({
    # translation
    set.seed(input$seed)
    n <- input$years

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
          r <- runif(1, min = input$min_rate/100, max = input$max_rate/100)
        }
        # balance at the end of period
        balance[k+1] <- balance[k] * (1 + r/periods)^1
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
    # reshape table to long format
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
  output$stats <- renderDataTable({
    # quantiles 10%, 20%, ..., 100%
    quants <- quantile(balance_mat()[input$years+1,], probs = seq(0.1, 1, 0.1))
    
    quant_df <- data.frame(
      quantile = paste0(seq(from = 10, to = 100, by = 10), "%"),
      end_amount = quants,
      row.names = 1:10
    )
    
    quant_df
  })
  
} # closes server


# Run the application 
shinyApp(ui = ui, server = server)

