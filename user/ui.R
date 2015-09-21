library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
fluidPage(theme = shinytheme("cerulean"),
    
    # Application title
    titlePanel("Lineups - Shiny"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Selection"),
            numericInput("choice", "Choice", value = NA, min = 1, max = 20),
            br(),
            radioButtons("reasoning", "Reasoning", choices = c("Big vertical difference" = "bvd", "Groups are separated" = "gas", "Spread is different", "Other" = "oth")),
            conditionalPanel(condition = "input.reasoning == 'oth'",
                textInput("other", "Other Reason")
            ),
            radioButtons("certain", "How certain are you? (1 = most, 5 = least)", choices = 1:5, inline = TRUE, selected = 3),
            textInput("turk", "Your Turk ID"),
            actionButton("submit", "Submit", icon = icon("caret-right")),
            textOutput("result")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            h3(textOutput("question")),
            hr(),
            uiOutput("lineup")
        )
    ),
    
    includeScript("www/js/additional.js"),
    includeScript("www/js/action.js")
)