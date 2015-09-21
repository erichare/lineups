library(shiny)
library(shinythemes)
library(shinyTestR)

fluidPage(theme = shinytheme("cerulean"),
    
    titlePanel("Lineups - Shiny"),
    
    sidebarLayout(
        sidebarPanel(
            inputIP("myip"),
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
        
        mainPanel(
            h3(textOutput("question")),
            hr(),
            uiOutput("lineup")
        )
    ),
    
    includeScript("www/js/additional.js"),
    includeScript("www/js/action.js")
)