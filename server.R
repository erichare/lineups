library(shiny)
library(lineupgen)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    output$lineup <- renderPlot({
        print(
            lineup(mpg, fixed_col = "cty", permute_col = "hwy")
        )
    })
    
    output$click <- renderText({
        return(paste("X is", ceiling(4 * input$xcoord / input$plotwidth), "and Y is", ceiling(4 * input$ycoord / input$plotheight)))
    })
})
