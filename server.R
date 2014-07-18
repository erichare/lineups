library(shiny)
library(lineupgen)
library(ggplot2)
library(RMySQL)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    output$result <- renderText({            
            input$submit
            
            if (input$submit == 0) {
                return("")
            }
            
            isolate({
                x <- ceiling(4 * input$xcoord / input$plotwidth)
                y <- ceiling(4 * input$ycoord / input$plotheight)
                
                reason <- input$reasoning
                if (reason == "oth") reason <- paste(reason, input$other, sep = ": ")
                
                test <- data.frame(ip_address = "0.0.0.0", nick_name = input$turk, start_time = 0, end_time = 0, 
                                   pic_id = 0, response_no = x + (4 * (y - 1)), conf_level = input$certain, 
                                   choice_reason = reason, description = "turkshiny")
                
                con <- dbConnect(MySQL(), user="root", password="ChrtRt5rt%",
                                 dbname="mahbub", host="localhost")
                
                dbWriteTable(con, "feedback", test, append = TRUE, row.names = FALSE)
                
                dbDisconnect(con)
                
                return("Submitted successfully!")
            })
    })
    
    output$choice <- renderText({
        x <- ceiling(4 * input$xcoord / input$plotwidth)
        y <- ceiling(4 * input$ycoord / input$plotheight)
        
        return(paste("Your Choice:", x + (4 * (y - 1))))
    })
        
    output$lineup <- renderPlot({
        print(
            lineup(mpg, fixed_col = "cty", permute_col = "hwy")
        )
    })
    
    output$click <- renderText({
        return(paste("X is", ceiling(4 * input$xcoord / input$plotwidth), "and Y is", ceiling(4 * input$ycoord / input$plotheight)))
    })
})
