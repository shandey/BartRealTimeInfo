library(xml2)
library(plyr)
library(RCurl)
library(devtools)
library(XML)

getBARTRoutesDF <- function() {
  # Returns a data.frame for BART routes
  getRoutesXML <- getURL('http://api.bart.gov/api/route.aspx?cmd=routes&key=MW9S-E7SL-26DU-VV8V')
  routesData <- xmlParse(getRoutesXML)
  xmlToDataFrame(nodes = getNodeSet(routesData, "//root/routes/route"))
}

getBARTStationsDF <- function() {
  # Returns a data.frame for BART stations
  getStationsXML <- getURL('http://api.bart.gov/api/stn.aspx?cmd=stns&key=MW9S-E7SL-26DU-VV8V')
  stationsData <- xmlParse(getStationsXML)
  xmlToDataFrame(nodes = getNodeSet(stationsData, "//root/stations/station"))
}

getBARTStationsForRouteDF <- function(iRoute) {
  # Returns a data.frame for BART stations for a route
  url <- paste('http://api.bart.gov/api/route.aspx?cmd=routeinfo&key=MW9S-E7SL-26DU-VV8V&route=',as.character(iRoute),sep="")
  getStationsXML <- getURL(url)
  stationsData <- xmlParse(getStationsXML)
  df <- xmlToDataFrame(nodes = getNodeSet(stationsData, "//root/routes/route/config/station"))
  names(df) <- c("abbr")
  merge(df, getBARTStationsDF(), by="abbr")
}

getBARTStationsETDDF <- function(iStation) {
  # Returns a data.frame for BART stations for a route
  url <- paste('http://api.bart.gov/api/etd.aspx?cmd=etd&key=MW9S-E7SL-26DU-VV8V&orig=',iStation,sep="")
  
  # Reste dfETD data frame
  print(url)
  getStationsXML <- getURL(url)
  stationsData <- xmlParse(getStationsXML)
  # Get ETD data per destination
  etaNodeSet <- getNodeSet(stationsData, "//root/station/etd")
  
  # Now get all the ETDs fro a particular destination
  for (i in 1:length(etaNodeSet)) {
    destination <- xmlValue(etaNodeSet[[i]][[1]])
    dfD <- data.frame(destination = destination)
    getNodeSet(etaNodeSet[[i]], "//root/station/etd/estimate")
    df <- xmlToDataFrame(nodes = getNodeSet(etaNodeSet[[i]], "//root/station/etd/estimate"))
    if ( i > 1) {
      dfETD <- rbind2(dfETD, merge.data.frame(dfD, df, all = TRUE) )
    } else {
      dfETD <- merge.data.frame(dfD, df, all = TRUE)
    }
  }
  print(dfETD)
  dfETD
}