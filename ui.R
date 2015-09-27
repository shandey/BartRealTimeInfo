library(shiny)

# Get the route choices
routeChoicesDF <- data.frame(name=getBARTRoutesDF()$name, value=getBARTRoutesDF()$number)
routeChoices <- as.list(routeChoicesDF$value)
names(routeChoices) <- routeChoicesDF$name

# Define UI
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("BART: Real-time Departure Informaton"),
  
  # Sidebar with a input for stations
  sidebarPanel(
    h6("BART (Bay Area Rapid Transit) is the train system in Bay area that connects different parts of the bay.")
    , h6("Please select the route, followed by station to get real-time departure information of the selected statiom.")
    , selectInput(inputId="iRoute", "Select a Route:",choices = routeChoices, selectize = FALSE)
    , selectInput("iStation", "Select a Station:","FRMT",selectize = FALSE)
  ),
  
  # Show the main panel with the real-time departure information.
  mainPanel(
    textOutput("addressText"),
    tableOutput("outputDataTable")
  )
))