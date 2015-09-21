library(shiny)
library(shinyTestR)
library(nullabor)
library(lineupgen)
library(ggplot2)
library(lubridate)
library(RMySQL)

## DB Information
dbname <- "mahbub_test"
user <- "turkuser"
password <- "Turkey1sdelicious"
host <- "localhost"

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    values <- reactiveValues(choice = NULL, starttime = NULL, trialsleft = NULL, lppleft = NULL, rows = NULL, columns = NULL, choice = NULL, correct = NULL, result = "")
    
    experiment_props <- reactive({
        con <- dbConnect(MySQL(), user = user, password = password,
                         dbname = dbname, host = host)
        
        myexp <- dbReadTable(con, "experiment_details")[1,]
        
        dbDisconnect(con)
        
        return(myexp)
    })
    
    observe({
        values$lppleft <- experiment_props()[1,"lpp"]
        values$trialsleft <- experiment_props()[1,"trials_req"]
        values$rows <- experiment_props()[1,"rows"]
        values$columns <- experiment_props()[1,"columns"]
    })
    
    observeEvent(input$submit, {
        x <- ceiling(values$columns * input$xcoord / input$plotwidth)
        y <- ceiling(values$rows * input$ycoord / input$plotheight)
        values$choice <- x + (values$columns * (y - 1))
        
        reason <- input$reasoning
        if (reason == "oth") reason <- paste(reason, input$other, sep = ": ")
        
        if (values$trialsleft == 0 && values$lppleft > 0) {
            values$result <- "Submitted!"
            test <- data.frame(ip_address = "0.0.0.0", nick_name = input$turk, start_time = values$starttime, end_time = now(), 
                               pic_id = 0, response_no = values$choice, conf_level = input$certain, 
                               choice_reason = reason, description = "turkshiny")
            
            con <- dbConnect(MySQL(), user = user, password = password,
                             dbname = dbname, host = host)
            
            dbWriteTable(con, "feedback", test, append = TRUE, row.names = FALSE)
            
            values$lppleft <- values$lppleft - 1
            dbDisconnect(con)
            
            if (values$lppleft == 0) {
                values$result <- "All done! Congratulations! Your code is 32508235"
            }
        } else {
            if (values$correct == values$choice) {
                values$trialsleft <- values$trialsleft - 1
                values$result <- "Correct! :)"
            } else {
                values$result <- "Incorrect :("
            }
        }
    })
    
    output$choice <- renderText({
        if (values$lppleft == 0) return(values$result)
            
        x <- ceiling(values$columns * input$xcoord / input$plotwidth)
        y <- ceiling(values$rows * input$ycoord / input$plotheight)
        
        return(paste("Your Choice:", x + (values$columns * (y - 1))))
    })
        
    output$lineup <- renderPlot({
        if (values$lppleft == 0) return(NULL)
        
        withProgress(message = paste(values$result, "Loading", ifelse(values$trialsleft > 0, "trial", ""), "plot", ifelse(values$trialsleft > 0, paste(experiment_props()[1,"trials_req"] - values$trialsleft + 1, "of", experiment_props()[1,"trials_req"]), paste(experiment_props()[1,"lpp"] - values$lppleft + 1, "of", experiment_props()[1,"lpp"]))), expr = {            
            input$submit
            
            values$starttime <- now()
            values$correct <- sample(1:(values$rows*values$columns), 1)
            
            print(lineupgen::lineup(mpg, fixed_col = "cty", permute_col = "hwy", rows = values$rows, columns = values$columns, correct = values$correct))
        })
    })
    
    output$click <- renderText({
        return(paste("X is", ceiling(values$columns * input$xcoord / input$plotwidth), "and Y is", ceiling(values$rows * input$ycoord / input$plotheight)))
    })
    
    output$ugh <- renderUI({
        return(HTML(readLines("10ed1d7db72bc6fa568d46130fd7ac01.svg")))
    })
})
