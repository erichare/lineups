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
host <- "104.236.245.153"

## Experiment Information
expname <- "turk16"

shinyServer(function(input, output, session) {
    
    outputIP(session)
    
    values <- reactiveValues(pics = NULL, submitted = FALSE, choice = NULL, reasons = NULL, starttime = NULL, trialsleft = NULL, lppleft = NULL, pic_id = 0, choice = NULL, correct = NULL, result = "")
    
    experiment_props <- reactive({
        con <- dbConnect(MySQL(), user = user, password = password,
                         dbname = dbname, host = host)
        
        experiments <- dbReadTable(con, "experiment_details")
        myexp <- experiments[experiments$experiment == expname,]
        
        dbDisconnect(con)
        
        return(myexp)
    })

    observe({
        values$experiment <- experiment_props()[1,"experiment"]
        values$question <- experiment_props()[1,"question"]
        values$reasons <- strsplit(experiment_props()[1,"reasons"], ",")[[1]]
        values$lppleft <- experiment_props()[1,"lpp"]
        values$trialsleft <- experiment_props()[1,"trials_req"]
    })
    
    observe({
        updateRadioButtons(session, "reasoning", choices = values$reasons)
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
            if (reason == "Other") reason <- paste(reason, input$other, sep = ": ")
            
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
                    rand1 <- sample(letters, 3, replace = TRUE)
                    rand2 <- sample(LETTERS, 3, replace = TRUE)
                    rand3 <- sample(1:9, 3, replace = TRUE)
                    
                    code <- paste(sample(c(rand1, rand2, rand3)), collapse = "")
                    
                    values$question <- paste("All done! Congratulations! Your code is", code)
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
            
            lpp <- experiment_props()[1,"lpp"]
            if (trial == 0 && is.null(values$pics)) {
                pic_ids <- sample(1:540, lpp)
                values$pics <- dbGetQuery(con, paste0("SELECT * FROM picture_details WHERE experiment = '", values$experiment, "' AND trial = ", trial, " AND pic_id IN (", paste(pic_ids, collapse = ","), ") ORDER BY FIELD(pic_id, ", paste(pic_ids, collapse = ","), ")"))
                nextplot <- values$pics[1,]
            } else if (trial == 0 && !is.null(values$pics)) {
                nextplot <- values$pics[lpp - values$lppleft + 1,]
            } else if (trial == 1) {
                nextplot <- dbGetQuery(con, paste0("SELECT * FROM picture_details WHERE experiment = '", values$experiment, "' AND trial = ", trial, " ORDER BY RAND() LIMIT 1"))
            }
            
            dbDisconnect(con)
            
            values$pic_id <- nextplot$pic_id
            values$correct <- strsplit(nextplot$obs_plot_location, ",")[[1]]
            
            values$submitted <- FALSE
            updateTextInput(session, "response_no", value = "")
            HTML(readLines(file.path("experiments", values$experiment, plotpath, nextplot$pic_name)))
        })
    })
})
