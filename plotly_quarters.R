library(shiny)
library(plotly)
library(TTR)
res = read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")

# User Interface
ui <- fluidPage(
  
  # Retrieve input
  selectizeInput(
    
    # Country input variable
    inputId = "country", 
    label = "Select a Country", 
    choices = unique(res$location), 
    selected = "Algeria",
    multiple = FALSE
  ),
  plotlyOutput(outputId = "p")
)

# Server variable
server <- function(input, output, ...) {
  
  # Calculate RSI
  locationRSI <- reactive({
    # Filter data by country
    df <- res[res[,'location'] == input$country,]
    
    # Calculate RSI
    df['RSI'] <- RSI(df$new_cases, n = 14)
    return(df)
  })
  
  # Create background shapes
  createShapes <- reactive({
    
    # Shape color
    shape = list(type = 'rect', line = list(color = 'rgba(0,0,0,0)'), 
                 fillcolor = 'rgba(147,112,219,0.1)', xref='x', yref='y')
    
    shapes <- list()
    
    # Q1
    shape[['x0']] <- 0
    shape[['x1']] <- 69
    shape[['y0']] <- 0
    shape[['y1']] <- 95
    shapes <- c(shapes, list(shape))
    
    # Q3
    shape[['x0']] <- 69 + 91
    shape[['x1']] <- 69 + 91 + 92
    shape[['y0']] <- 0
    shape[['y1']] <- 95
    shapes <- c(shapes, list(shape))
    
    return(shapes)
  })
  
  
  output$p <- renderPlotly({
    
    # Create plot
    fig <- plot_ly(locationRSI(), x = ~date, y= ~RSI, type='scatter', 
                   mode = 'lines', name = 'Relative Strenth Index (RSI)') %>%
      layout(xaxis = list(title = 'Date'),
             yaxis = list(title = 'RSI'),
             shapes=createShapes()) %>% 
      add_trace(x = ~date, y = ~total_cases, mode = 'lines', 
                yaxis = 'y2', name = 'Total Cases' ) %>%
      layout(yaxis2 = list(overlaying = 'y', side = 'right',
                           title = 'Total Cases'), hovermode = 'compare')
    
    return(fig)
    
  })
}

# Run shiny app
shinyApp(ui, server)