library(shiny)
library(lineupgen)
library(ggplot2)
library(RMySQL)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    observe({
        input$submit
        
        con <- dbConnect(MySQL(), user="root", password="ChrtRt5rt%",
                          dbname="mahbub", host="localhost")
        
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
