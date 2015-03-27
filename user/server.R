library(shiny)
library(lineupgen)
library(ggplot2)
library(RMySQL)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    observeEvent(input$submit, {
        x <- ceiling(4 * input$xcoord / input$plotwidth)
        y <- ceiling(4 * input$ycoord / input$plotheight)
        
        reason <- input$reasoning
        if (reason == "oth") reason <- paste(reason, input$other, sep = ": ")
        
        test <- data.frame(ip_address = "0.0.0.0", nick_name = input$turk, start_time = 0, end_time = 0, 
                           pic_id = 0, response_no = x + (4 * (y - 1)), conf_level = input$certain, 
                           choice_reason = reason, description = "turkshiny")
        
        con <- dbConnect(MySQL(), user="turkuser", password="Turkey1sdelicious",
                         dbname="mahbub", host="localhost")
        
        dbWriteTable(con, "feedback", test, append = TRUE, row.names = FALSE)
        
        dbDisconnect(con)
    })
    
    output$choice <- renderText({
        x <- ceiling(4 * input$xcoord / input$plotwidth)
        y <- ceiling(4 * input$ycoord / input$plotheight)
        
        return(paste("Your Choice:", x + (4 * (y - 1))))
    })
        
    output$lineup <- renderPlot({
        input$submit
        
        print(
            lineup(mpg, fixed_col = "cty", permute_col = "hwy")
        )
    })
    
    output$click <- renderText({
        return(paste("X is", ceiling(4 * input$xcoord / input$plotwidth), "and Y is", ceiling(4 * input$ycoord / input$plotheight)))
    })
})
