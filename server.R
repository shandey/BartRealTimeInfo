library(shiny)
library(RCurl)
library(xml2)
library(rjson)
library(plyr)
library(devtools)

# Define server logic for real-time BART station information
shinyServer(function(input, output,session) {
#
# 
  observe({
    output$addressText <- renderText({
          paste("Real time departure information by Destination and direction")
    })
    
    ## updateSelectInput(session, "iRoute", getBARTRoutesDF$name)

    
    # Populate the Station list in the select input based on the selected route
    # First get the station data frame
    stationDF <- data.frame(name=getBARTStationsForRouteDF(input$iRoute)$name, abbr=getBARTStationsForRouteDF(input$iRoute)$abbr)
    stationChoices <- as.list(stationDF$abbr)
    names(stationChoices) <- stationDF$name
    # print(stationChoices)
    updateSelectInput(session, "iStation",choices = stationChoices)
    
    # Now populate the Estimated current Time of Departure (ETD) fro the selected station
    output$outputDataTable <- renderTable({
      getBARTStationsETDDF(input$iStation) 
    })
  }) # End Observe
})