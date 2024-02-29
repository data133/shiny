# Title: Basic Investing Simulator
# Description: Simulates investing a lump sum for a number of years. 
# The rate of return for every year is a variable rate that is randomly 
# generated according to a uniform distribution.
# Details: The layout of the app uses a dashboard theme from package "bslib" 
# Author: Gaston Sanchez
# Date: Spring 2024


# ===============================================
# Packages
# ===============================================
library(shiny)
library(tidyverse)
library(bslib)
library(plotly)



# =========================================================
# UI
# =========================================================
ui <- page_sidebar(
  title = "Basic Investment Simulation",
  theme = bs_theme(
    version = 5,
    bootswatch = "cerulean",
    base_font = font_google("Inter"),
    navbar_bg = "#567299"
  ),
  fillable = FALSE,
  
  sidebar = sidebar(
    #title = "",
    numericInput(inputId = 'initial', 
                 label = 'Initial Amount ($)', 
                 min=1, 
                 max=10000,
                 value = 100),
    numericInput(inputId = "min_rate", 
                 label = "Minimum rate", 
                 min = -0.05, 
                 max = 0, 
                 step = 0.01,
                 value = -0.05),
    numericInput(inputId = "max_rate", 
                 label = "Maximum rate", 
                 min = 0, 
                 max = 1,
                 step = 0.01,
                 value = 0.18),
    numericInput(inputId = "num_years", 
                 label = "Years invested", 
                 min = 1, 
                 max = 50, 
                 value = 5),
    numericInput(inputId = "num_sims", 
                 label = "Number of simulations", 
                 min = 1, 
                 max = 200,
                 step = 1,
                 value = 5),
    numericInput(inputId = "seed", 
                 label = "Random Seed", 
                 min = 1, 
                 max = 10000,
                 step = 1,
                 value = 133)    
  ),
  
  card(
    card_header("Balance"),
    height = 500,
    plotlyOutput(outputId = "plot")
  ),
  card(
    card_header("Data Table"),
    height = 600,
    style = "resize:vertical;",
    card_body(
      min_height = 500,
      tableOutput(outputId = "table")
    )
  )
)


server <- function(input, output) {
  
  dat <- reactive({
    # setting seed for reproducibility
    set.seed(input$seed)

    # output (ordinary contributions)
    balance = matrix(input$initial, input$num_years + 1, input$num_sims)
    
    # iterations
    for (sim in 1:input$num_sims) {
      rates = runif(n = input$num_years, min = input$min_rate, max = input$max_rate)
      for (y in 1:input$num_years) {
        balance[y+1, sim] = balance[y, sim] * (1 + rates[y])
      }
    }
    rownames(balance) = 1:(input$num_years + 1)
    colnames(balance) = paste0("sim", 1:input$num_sims)
    
    balance = as.data.frame(cbind("year" = 0:input$num_years, balance))
    balance
  })
  
  
  output$plot <- renderPlotly({
    # convert to "long" (tall) format
    tbl = pivot_longer(
      data = dat(), 
      cols = starts_with("sim"), 
      names_to = "simulation", 
      values_to = "amount")
    
    # median balance (by year)
    median_balance = tbl |> 
      group_by(year) |>
      summarise(amount = median(amount))
    
    ggplot(tbl, aes(x = year, y = amount)) +
      geom_line(aes(group = simulation), alpha = 0.3) +
      geom_line(data = median_balance, aes(x = year, y = amount), color = "red") +
      scale_y_continuous(label = scales::comma)
  })
  
  output$table <- renderTable({
    cols = min(5, input$num_sims)
    dat()[1:input$num_years, 1:cols]
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
