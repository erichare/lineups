library(shiny)
library(RMySQL)

## DB Information
dbname <- "mahbub_test"
user <- "turkuser"
password <- "Turkey1sdelicious"
host <- "localhost"

shinyServer(function(input, output, session) {
    
    values <- reactiveValues(result = "")
    
    picture_details <- reactive({
        if (is.null(input$picture_details) | is.null(input$try_picture_details)) return(NULL)
        
        picture_details <- read.csv(input$picture_details$datapath, stringsAsFactors = FALSE)
        try_picture_details <- read.csv(input$try_picture_details$datapath, stringsAsFactors = FALSE)
        
        ### Cleanup
        # picture_details$pic_name <- gsub("Images/Lineups/svgs/", "", as.character(picture_details$pic_name))
        # picture_details$difficulty1 <- NULL; picture_details$difficulty2 <- NULL; picture_details$difficulty3 <- NULL
        # picture_details$trial <- 0
        # try_picture_details$pic_name <- gsub("Images/Lineups/svgs/", "", as.character(try_picture_details$pic_name))
        # try_picture_details$trial <- 1
        
        deets <- rbind(picture_details, try_picture_details)
        
        return(deets)
    })
    
    experiment_details <- reactive({
        if (input$experiment == "") return(NULL)
        
        my.df <- data.frame(experiment = input$experiment, 
                            question = input$experiment_question, 
                            reasons = input$experiment_reasons,
                            lpp = input$lpp, 
                            trials_req = input$trials_req)
        
        return(my.df)
    })
    
    observeEvent(input$submit, {
        con <- dbConnect(MySQL(), user = user, password = password,
                         dbname = dbname, host = host)
        
        dbWriteTable(con, "picture_details", picture_details(), append = TRUE, row.names = FALSE)
        dbWriteTable(con, "experiment_details", experiment_details(), append = TRUE, row.names = FALSE)
                
        values$result <- "Submitted Successfully!"
        
        dbDisconnect(con)
    })
    
    output$result <- renderText({
        return(values$result)
    })
    
})
