library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Lineups - Shiny"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Selection"),
            textOutput("choice"),
            br(),
            radioButtons("reasoning", "Reasoning", choices = c("Big vertical difference" = "bvd", "Groups are separated" = "gas", "Spread is different", "Other" = "oth")),
            conditionalPanel(condition = "input.reasoning == 'oth'",
                textInput("other", "Other Reason")
            ),
            radioButtons("certain", "How certain are you? (1 = most, 5 = least)", choices = 1:5, inline = TRUE, selected = 3),
            textInput("turk", "Your Turk ID"),
            actionButton("submit", "Submit", icon = icon("caret-right")),
            textOutput("result"),
            hr(),
            h3("Debug Info"),
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