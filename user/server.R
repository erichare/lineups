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
        values$experiment <- experiment_props()[1,"experiment"]
        values$lppleft <- experiment_props()[1,"lpp"]
        values$trialsleft <- experiment_props()[1,"trials_req"]
    })
    
    observeEvent(input$submit, {
        reason <- input$reasoning
        if (reason == "oth") reason <- paste(reason, input$other, sep = ": ")
        values$choice <- input$choice
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
        
    output$lineup <- renderUI({
        if (values$lppleft == 0) return(NULL)
        
        withProgress(message = paste(values$result, "Loading", ifelse(values$trialsleft > 0, "trial", ""), "plot", ifelse(values$trialsleft > 0, paste(experiment_props()[1,"trials_req"] - values$trialsleft + 1, "of", experiment_props()[1,"trials_req"]), paste(experiment_props()[1,"lpp"] - values$lppleft + 1, "of", experiment_props()[1,"lpp"]))), expr = {            
            input$submit
            
            values$starttime <- now()
            trial <- as.numeric(values$trialsleft > 0)
            plotpath <- ifelse(values$trialsleft > 0, "trials", "plots")
            
            con <- dbConnect(MySQL(), user = user, password = password,
                             dbname = dbname, host = host)
            nextplot <- dbGetQuery(con, paste0("SELECT * FROM picture_details WHERE experiment = '", values$experiment, "' AND trial = ", trial, " ORDER BY RAND() LIMIT 1"))
            dbDisconnect(con)
            
            values$correct <- nextplot$obs_plot_location

            HTML(readLines(file.path("experiments", values$experiment, plotpath, nextplot$pic_name)))
        })
    })
})
