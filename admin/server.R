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
    
    output$result <- renderText({
        input$submit
        
        if (input$submit == 0) {
            return("")
        }
        
        isolate({
            con <- dbConnect(MySQL(), user="mahbub", password="turkey1sDelicious",
                             dbname="mahbub", host="localhost")
            
            dbWriteTable(con, "picture_details", picture_details(), append = TRUE, row.names = FALSE)
            
            dbDisconnect(con)
            
            return("Submitted successfully!")
        })
    })

})
