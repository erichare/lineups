function getClickPosition(e) {
    var xPosition = e.clientX;
    var yPosition = e.clientY;
    
    var test = lineup.getBoundingClientRect();
            
    xcoord.value = Math.round(xPosition - test.left);
    ycoord.value = Math.round(yPosition - test.top);
    plotwidth.value = Math.round(test.width);
    plotheight.value = Math.round(test.height);
    
    Shiny.onInputChange("xcoord", Math.round(xPosition - test.left));
    Shiny.onInputChange("ycoord", Math.round(yPosition - test.top));
    Shiny.onInputChange("plotwidth", Math.round(test.width));
    Shiny.onInputChange("plotheight", Math.round(test.height));
    
    return [xPosition, yPosition]
}

lineup.addEventListener("click", getClickPosition, false);
