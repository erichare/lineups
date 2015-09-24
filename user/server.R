library(shiny)
library(shinyTestR)
library(nullabor)
library(lineupgen)
library(ggplot2)
library(lubridate)
library(RMySQL)
library(shinyjs)

## DB Information
dbname <- "mahbub_test"
user <- "turkuser"
password <- "Turkey1sdelicious"
host <- "localhost"

shinyServer(function(input, output, session) {
    
    outputIP(session)
    
    values <- reactiveValues(submitted = FALSE, choice = NULL, starttime = NULL, trialsleft = NULL, lppleft = NULL, pic_id = 0, choice = NULL, correct = NULL, result = "")
    
    experiment_props <- reactive({
        con <- dbConnect(MySQL(), user = user, password = password,
                         dbname = dbname, host = host)
        
        myexp <- dbReadTable(con, "experiment_details")[1,]
        
        dbDisconnect(con)
        
        return(myexp)
    })

    observe({
        values$experiment <- experiment_props()[1,"experiment"]
        values$question <- experiment_props()[1,"question"]
        values$lppleft <- experiment_props()[1,"lpp"]
        values$trialsleft <- experiment_props()[1,"trials_req"]
    })
    
    observeEvent(input$submitdemo, {
        con <- dbConnect(MySQL(), user = user, password = password,
                         dbname = dbname, host = host)
        
        demoinfo <- data.frame(nick_name = input$turk, 
                               age = input$age,
                               gender = input$gender,
                               academic_study = input$education,
                               ip_address = input$myip)
        
        dbWriteTable(con, "users", demoinfo, append = TRUE, row.names = FALSE)
        dbDisconnect(con)
        
        updateCheckboxInput(session, "ready", value = TRUE)
    })
    
    output$question <- renderText({
        if (!input$ready) return("Please fill out the demographic information to begin.")
        
        return(values$question)
    })
    
    observeEvent(input$submit, {
        if (nchar(input$response_no) > 0 && all(strsplit(input$response_no, ",")[[1]] %in% 1:20) && values$lppleft > 0) {
            
            reason <- input$reasoning
            if (reason == "oth") reason <- paste(reason, input$other, sep = ": ")
            
            values$choice <- as.character(input$response_no)
            
            if (values$trialsleft == 0 && values$lppleft > 0) {
                values$result <- "Submitted!"
                
                test <- data.frame(ip_address = input$myip, nick_name = input$turk, start_time = values$starttime, end_time = now(), 
                                   pic_id = values$pic_id, response_no = values$choice, conf_level = input$certain, 
                                   choice_reason = reason, description = values$experiment)
                
                con <- dbConnect(MySQL(), user = user, password = password,
                                 dbname = dbname, host = host)
                dbWriteTable(con, "feedback", test, append = TRUE, row.names = FALSE)
                dbDisconnect(con)
                
                values$lppleft <- values$lppleft - 1
                
                if (values$lppleft == 0) {
                    values$question <- "All done! Congratulations!\nYour code is 32508235"
                }
            } else {
                if (any(strsplit(values$choice, ",")[[1]] %in% values$correct)) {
                    values$trialsleft <- values$trialsleft - 1
                    values$result <- "Correct! :)"
                } else {
                    values$result <- "Incorrect :("
                }
            }            
            
            values$submitted <- TRUE
        }
    })
        
    output$lineup <- renderUI({
        if (values$lppleft == 0 || !input$ready) return(NULL)
        
        withProgress(message = paste(values$result, "Loading", ifelse(values$trialsleft > 0, "trial", ""), "plot", ifelse(values$trialsleft > 0, paste(experiment_props()[1,"trials_req"] - values$trialsleft + 1, "of", experiment_props()[1,"trials_req"]), paste(experiment_props()[1,"lpp"] - values$lppleft + 1, "of", experiment_props()[1,"lpp"]))), expr = {            
            values$submitted
            
            values$starttime <- now()
            trial <- as.numeric(values$trialsleft > 0)
            plotpath <- ifelse(values$trialsleft > 0, "trials", "plots")
            
            con <- dbConnect(MySQL(), user = user, password = password,
                             dbname = dbname, host = host)
            nextplot <- dbGetQuery(con, paste0("SELECT * FROM picture_details WHERE experiment = '", values$experiment, "' AND trial = ", trial, " ORDER BY RAND() LIMIT 1"))
            dbDisconnect(con)
            
            values$pic_id <- nextplot$pic_id
            values$correct <- strsplit(nextplot$obs_plot_location, ",")[[1]]
            
            values$submitted <- FALSE
            updateTextInput(session, "response_no", value = "")
            HTML(readLines(file.path("experiments", values$experiment, plotpath, nextplot$pic_name)))
        })
    })
})
