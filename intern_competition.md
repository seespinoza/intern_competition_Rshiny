---
title: "R Notebook"
output:
  html_document:
    keep_md: true
---

Import libraries and data

```r
library(shiny)
```

```
## Warning: package 'shiny' was built under R version 4.0.3
```

```r
library(plotly)
```

```
## Warning: package 'plotly' was built under R version 4.0.3
```

```
## Loading required package: ggplot2
```

```
## 
## Attaching package: 'plotly'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     last_plot
```

```
## The following object is masked from 'package:stats':
## 
##     filter
```

```
## The following object is masked from 'package:graphics':
## 
##     layout
```

```r
res = read.csv("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv")
```


```r
# User Interface
ui <- fluidPage(
  
  # Retrieve input
  selectizeInput(
    
    # Country input variable
    inputId = "country", 
    label = "Select a Country", 
    choices = unique(res$location), 
    selected = "Algeria",
    multiple = TRUE
  ),
  plotlyOutput(outputId = "p")
)

# Retreive total cases for selected location
calculate.df <- function(loc)
{
    # Get rows that match location only
    record_country <- res[res[,'location'] == loc,]
    
    return(record_country)
}

# Server variable
server <- function(input, output, ...) {
  
  
  output$p <- renderPlotly({
    
    # Create plot
    plot_ly(res, x = ~date, y= ~total_cases_per_million,
            color = ~location) %>%
      layout(title = 'Total Covid Cases 2020', 
             xaxis = list(title = 'Date'),
             yaxis = list(title = 'Total Cases Per Million')) %>%
      filter(location %in% input$country) %>%
      group_by(location) %>%
      add_lines()
  })
}

# Run shiny app
shinyApp(ui, server)
```

<!--html_preserve--><div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div><!--/html_preserve-->


```r
shinyApp(ui, server)
```

<!--html_preserve--><div style="width: 100% ; height: 400px ; text-align: center; box-sizing: border-box; -moz-box-sizing: border-box; -webkit-box-sizing: border-box;" class="muted well">Shiny applications not supported in static R Markdown documents</div><!--/html_preserve-->
