library(shiny)
library(shinythemes)
library(shinyTestR)
library(shinyjs)

fluidPage(theme = shinytheme("cerulean"),
          
    titlePanel("Lineups - Shiny"),
    
    sidebarLayout(
        sidebarPanel(
            conditionalPanel(condition = "!input.welcome",
                             h3("Welcome"),
                             
                             helpText("In this survey a series of similar looking charts will be presented.  We would like you to respond to the following questions. 
 	 
                                      1. Pick the plot based on the survey question
                                      2. Provide reasons for choice   
                                      3. How certain are you?

                                      Finally we would like to collect some information about you.
                                      (age category, education and gender)
                                      
                                      Your response is voluntary and any information we collect from you will be kept confidential. By  clicking on the button below you agree that the data we collect may be used in research study."),

                             actionButton("beginexp", "Begin Experiment")                 
            ),
            conditionalPanel(condition = "input.welcome && !input.ready",
                             h3("Demographic Information"),
                             textInput("turk", "Turk ID"),
                             selectizeInput("age", "Age Range", choices = c("", "Under 18", "18-25", "26-30", "31-35", "36-40", "41-45", "46-50", "51-55", "56-60", "Over 60", "I choose not to provide this information")),
                             radioButtons("gender", "Gender", choices = c("Female", "Male", "I choose not to provide this information"), selected = NA),
                             selectizeInput("education", "Highest Education Level", choices = c("", "High School or Less", "Some Undergraduate Courses",
                                                                                                "Undergraduate Degree", "Some Graduate Courses",
                                                                                                "Graduate Degree", "I choose not to provide this information")),
                             
                             actionButton("submitdemo", "Submit Demographics")                 
            ),
            
            conditionalPanel(condition = "input.response_no == null",
                             checkboxInput("welcome", "Welcome", value = FALSE)                
            ),
            
            conditionalPanel(condition = "input.response_no == null",
                checkboxInput("ready", "Ready", value = FALSE)                
            ),
            
            conditionalPanel(condition = "input.ready", 
                 h3("Selection"),
                 textInput("response_no", "Choice (Click on plot to select)", value = NA),
                 br(),
                 checkboxGroupInput("reasoning", "Reasoning", choices = ""),
                 conditionalPanel(condition = "input.reasoning == 'Other'",
                                  textInput("other", "Other Reason")
                 ),
                 selectizeInput("certain", "How certain are you?", choices = c("", "Very Uncertain", "Uncertain", "Neutral", "Certain", "Very Certain")),
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
