#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # the output for rendering the Magnitude versus Depth plot
    output$dataPlot <- renderPlot({
        
        # get the values from the slider inputs
        depth_min <- input$depths[1]
        depth_max <- input$depths[2]
        mag_min <- input$mags[1]
        mag_max <- input$mags[2]
        
        # make a subset of the quakes data limited by the slider inputs
        quakeData <- subset(quakes, (mag >= mag_min & mag <= mag_max & 
                                         depth >= depth_min & depth <= depth_max))
        
        # calculate the mean values for the subset of the quakes data
        mag_mean <- mean(quakeData$mag)
        depth_mean <- mean(quakeData$depth)

        # draw the plot of the quakes data and lock the plot size
        plot(quakeData$depth, quakeData$mag, xlim = c(25, 700), ylim = c(3.8, 6.8), 
             xlab = "Depth (km)", ylab = "Richter Magnitude") 
        # check if the checkbox for the depth mean line is checked
        if(input$meanDep){
            # add a vertical line for the depth mean
            abline(v=depth_mean, col = "blue", lwd = 2)
        } 
        # check if the checkbox for the magnitude mean line is checked
        if(input$meanMag){
            # add a horizontal line for the magnitude mean
            abline(h=mag_mean, col = "red", lwd = 2)
        } 
        # add a legend to the plot
        legend("topright", legend = c("Mean Depth", "Mean Magnitude"), pch = 16, 
               col = c("blue", "red"), bty = "n", cex = 1.2)
        
    })
    # the output for generatinga leaflet map
    output$mapPlot <- renderLeaflet({
        
        # get the values from the slider inputs
        depth_min <- input$depths[1]
        depth_max <- input$depths[2]
        mag_min <- input$mags[1]
        mag_max <- input$mags[2]
        
        # make a subset of the quake data limited by the slider inputs
        quakeData <- subset(quakes, (mag >= mag_min & mag <= mag_max & 
                                         depth >= depth_min & depth <= depth_max))
        
        # make a color scale based on magnitude
        colorPal <- colorBin("Reds", quakes$mag, 7)
        
        # create the map with the seismic locations
        quakeData %>% leaflet() %>% addTiles() %>% 
            addCircles(lng = ~long, lat = ~lat, color = ~colorPal(mag))
    })
})
