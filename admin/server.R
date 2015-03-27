library(shiny)
library(RMySQL)

shinyServer(function(input, output, session) {
    picture_details <- reactive({
        if (is.null(input$picture_details) | is.null(input$try_picture_details)) return(NULL)
        
        picture_details <- read.csv(input$picture_details$datapath)
        try_picture_details <- read.csv(input$try_picture_details$datapath)
        
        deets <- rbind(picture_details, try_picture_details)
        
        return(deets)
    })
    
    experiment_details <- reactive({
        if (input$experiment == "") return(NULL)
        
        my.df <- data.frame(experiment = input$experiment, lpp = input$lpp, trials_req = input$trials_req)
        
        return(my.df)
    })
    
    observeEvent(input$submit, {
        con <- dbConnect(MySQL(), user="turkuser", password="Turkey1sdelicious",
                         dbname="mahbub", host="localhost")
        
        dbWriteTable(con, "picture_details", picture_details(), append = TRUE, row.names = FALSE)
        dbWriteTable(con, "experiment_details", experiment_details(), append = TRUE, row.names = FALSE)
        
        cat("Submitted\n")
        
        dbDisconnect(con)
    })
    
})
