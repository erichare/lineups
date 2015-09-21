library(shiny)
library(shinythemes)

fluidPage(theme = shinytheme("cerulean"),
    
    titlePanel("Lineups - Admin"),
    
    sidebarLayout(
        sidebarPanel(
            textInput("experiment", "Experiment Name"),
            textInput("experiment_question", "Experiment Question", value = "Which plot is the most different from the other plots?"),
            
            hr(),
            
            numericInput("lpp", "Lineups Per Person", 10),
            numericInput("trials_req", "Correct Trials Needed", 2),
            
            hr(),

            fileInput("picture_details", "Upload Picture Details"),
            fileInput("try_picture_details", "Upload Try Picture Details"),
            
            hr(),
            
            actionButton("submit", "Submit Experiment", icon = icon("caret-right"))
        ),
        
        mainPanel(
            textOutput("result")
        )
    )
)