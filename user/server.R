library(shiny)
library(lineupgen)
library(ggplot2)
library(lubridate)
library(RMySQL)

myrows <- 5
mycols <- 3

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    values <- reactiveValues(choice = NULL, starttime = NULL, lppleft = NULL, rows = myrows, columns = mycols)
    
    experiment_props <- reactive({
        con <- dbConnect(MySQL(), user="turkuser", password="Turkey1sdelicious",
                         dbname="mahbub", host="localhost")
        
        myexp <- dbReadTable(con, "experiment_details")[1,]
        
        dbDisconnect(con)
        
        return(myexp)
    })
    
    observe({
        values$lppleft <- experiment_props()[1,"lpp"]
    })
    
    observeEvent(input$submit, {
        x <- ceiling(values$columns * input$xcoord / input$plotwidth)
        y <- ceiling(values$rows * input$ycoord / input$plotheight)
        choice <- x + (values$columns * (y - 1))
        
        reason <- input$reasoning
        if (reason == "oth") reason <- paste(reason, input$other, sep = ": ")
        
        test <- data.frame(ip_address = "0.0.0.0", nick_name = input$turk, start_time = values$starttime, end_time = now(), 
                           pic_id = 0, response_no = choice, conf_level = input$certain, 
                           choice_reason = reason, description = "turkshiny")
        
        con <- dbConnect(MySQL(), user="turkuser", password="Turkey1sdelicious",
                         dbname="mahbub", host="localhost")
        
        dbWriteTable(con, "feedback", test, append = TRUE, row.names = FALSE)
        
        values$lppleft <- values$lppleft - 1
                
        dbDisconnect(con)
    })
    
    output$choice <- renderText({
        x <- ceiling(values$columns * input$xcoord / input$plotwidth)
        y <- ceiling(values$rows * input$ycoord / input$plotheight)
        
        return(paste("Your Choice:", x + (values$columns * (y - 1))))
    })
        
    output$lineup <- renderPlot({
        withProgress(message = paste("Loading plot", experiment_props()[1,"lpp"] - values$lppleft + 1, "of", experiment_props()[1,"lpp"]), expr = {            
            input$submit
            
            values$starttime <- now()
            
            print(
                lineup(mpg, fixed_col = "cty", permute_col = "hwy", rows = myrows, columns = mycols)
            )
        })
    })
    
    output$click <- renderText({
        return(paste("X is", ceiling(values$columns * input$xcoord / input$plotwidth), "and Y is", ceiling(values$rows * input$ycoord / input$plotheight)))
    })
    
    output$ugh <- renderUI({
        return(HTML(readLines("10ed1d7db72bc6fa568d46130fd7ac01.svg")))
    })
})
