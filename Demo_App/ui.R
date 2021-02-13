#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)

# Define UI for application that has a plot and a map on two different tabs
shinyUI(fluidPage(

    # Application title
    titlePanel("History of seismic events near Fiji"),
    # Note: this application is using the r default data set quakes
    
    # Sidebar with app controls
    sidebarLayout(
        sidebarPanel(
            
            # A slider that takes in 2 values to determine both a maximum and 
            # minimum value for the depth variable
            sliderInput("depths", "Choose seismic event depth range:",
                        min = 25, max = 700, value = c(100, 620)),
            
            # a checkbox that turns on/off the line for the mean depth value
            checkboxInput("meanDep", "Show the Mean Depth", value = TRUE),
            
            # A slider that takes in 2 values to determine both a maximum and 
            # minimum value for the magnitude variable, the step was changed to 
            # 0.1 to allow for fractional increments
            sliderInput("mags", "Choose the seismic event magnitude range:",
                        min = 3.5, max = 7, step = 0.1, value = c(4, 6)),
            
            # a checkbox that turns on/off the line for the mean magnitude value
            checkboxInput("meanMag", "Show the Mean Magnitude", value = TRUE)
        ),

        # create a tabset panel with two tabs
        mainPanel(
            tabsetPanel(type = "tabs",
                        
                        # this tab shows a plot of the magnitude versus the depth
                        tabPanel("Data", br(), h4("Magnitude versus Depth of Seismic Events"), 
                                 plotOutput("dataPlot")),
                        
                        # this tab shows a map of all the seismic event locations
                        tabPanel("Map", br(), h4("Map of Seismic Events colored by Magnitude"), 
                                 leafletOutput("mapPlot"))
            )
        )
    )
))
