library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Hello Shiny!"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            numericInput("xcoord", "X Coord", value = 0),
            numericInput("ycoord", "Y Coord", value = 0),
            numericInput("plotwidth", "Plot Width", value = 0),
            numericInput("plotheight", "Plot Height", value = 0)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("lineup"),
            textOutput("click")
        )
    ),
    
    includeScript("www/js/additional.js")
))