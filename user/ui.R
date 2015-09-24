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
                             selectizeInput("age", "Age Range", choices = c("Under 18" = 1, "18-25" = 2, "26-30" = 3, "31-35" = 4, "36-40" = 5, "41-45" = 6, "46-50" = 7, "51-55" = 8, "56-60" = 9, "Over 60" = 10)),
                             radioButtons("gender", "Gender", choices = c("Male" = 1, "Female" = 2)),
                             selectizeInput("education", "Highest Education Level", choices = c("High School or Less" = 1, "Some Undergraduate Courses" = 2,
                                                                                                "Undergraduate Degree" = 3, "Some Graduate Courses" = 4,
                                                                                                "Graduate Degree" = 5)),
                             
                             actionButton("submitdemo", "Submit Demographics")                 
            ),
            
            conditionalPanel(condition = "input.response_no == null",
                checkboxInput("ready", "Ready", value = FALSE)                
            ),
            
            conditionalPanel(condition = "input.ready", 
                 h3("Selection"),
                 textInput("response_no", "Choice (Click on plot to select)", value = NA),
                 br(),
                 radioButtons("reasoning", "Reasoning", choices = c("Big vertical difference" = "bvd", "Groups are separated" = "gas", "Spread is different", "Other" = "oth")),
                 conditionalPanel(condition = "input.reasoning == 'oth'",
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
    
    includeScript("www/js/additional.js"),
    includeScript("www/js/action.js")
)