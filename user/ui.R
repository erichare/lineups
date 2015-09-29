library(shiny)
library(shinythemes)
library(shinyTestR)
library(shinyjs)

fluidPage(theme = shinytheme("cerulean"),
          
    titlePanel("Lineups - Shiny"),
    
    sidebarLayout(
        sidebarPanel(
            conditionalPanel(condition = "!input.ready",
                             h3("Demographic Information"),
                             textInput("turk", "Turk ID"),
                             selectizeInput("age", "Age Range", choices = c("Under 18", "18-25", "26-30", "31-35", "36-40", "41-45", "46-50", "51-55", "56-60", "Over 60")),
                             radioButtons("gender", "Gender", choices = c("Female", "Male")),
                             selectizeInput("education", "Highest Education Level", choices = c("High School or Less", "Some Undergraduate Courses",
                                                                                                "Undergraduate Degree", "Some Graduate Courses",
                                                                                                "Graduate Degree")),
                             
                             actionButton("submitdemo", "Submit Demographics")                 
            ),
            
            conditionalPanel(condition = "input.response_no == null",
                checkboxInput("ready", "Ready", value = FALSE)                
            ),
            
            conditionalPanel(condition = "input.ready", 
                 h3("Selection"),
                 textInput("response_no", "Choice (Click on plot to select)", value = NA),
                 br(),
                 radioButtons("reasoning", "Reasoning", choices = ""),
                 conditionalPanel(condition = "input.reasoning == 'Other'",
                                  textInput("other", "Other Reason")
                 ),
                 radioButtons("certain", "How certain are you? (1 = least, 5 = most)", choices = 1:5, inline = TRUE, selected = 3),
                 actionButton("submit", "Submit", icon = icon("caret-right")),
                 textOutput("result")            
            ),
            
            inputIP("myip")
        ),
        
        mainPanel(
            h3(textOutput("question")),
            hr(),
            uiOutput("lineup")
        )
    ),
    
    includeScript("www/js/action.js")
)