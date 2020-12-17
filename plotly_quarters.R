library(TTR)
library(plotly)
res = read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")

# Get data for US only
usRSI <- res[res[,'location'] == 'United States',]

# Calculate RSI using 14 day periods
usRSI['RSI'] <- RSI(usRSI$new_cases, n = 14)


# Plot RSI 
fig <- plot_ly(usRSI, x= ~date, y= ~RSI, type='scatter', mode = 'lines',
               name = 'RSI') %>%
  # Include total cases with separate y axis on right
  add_trace(x = ~date, y = ~total_cases, mode = 'lines', 
            yaxis = 'y2', name = 'Total_Cases' ) %>%
  layout(yaxis2 = list(overlaying = 'y', side = 'right', yaxis = list('Total Cases')), hovermode = 'compare')


# set up shapes

shape = list(type = 'rect', line = list(color = 'rgba(0,0,0,0)'), 
             fillcolor = 'rgba(147,112,219,0.1)', xref='x', yref='y')
shape_offset = 0.5
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

fig <- layout(fig, shapes=shapes)
fig
