#load libraries
library(shiny)
library(plotly)
library(ggplot2)
library(reshape)
library(plyr)

GDP_Data <- read.csv("GDPData.csv", skip = 4)
if (is.null(GDP_Data)) 
        return(NULL)

names(GDP_Data) <- gsub("X", "", names(GDP_Data))

shinyServer(function(input, output) {
        
        dataValues <- reactiveValues()
        observe({
                dataValues$minYear <- as.character(input$slideryear[1])
                dataValues$maxYear <- as.character(input$slideryear[2])
                
                dataValues$dsCountry1 <- subset(GDP_Data, Country.Name == input$countryname1)
                dataValues$ds1 <- select(dataValues$dsCountry1, Country.Name, dataValues$minYear:dataValues$maxYear)
                
                dataValues$dsCountry2 <- subset(GDP_Data, Country.Name == input$countryname2)
                dataValues$ds2 <- select(dataValues$dsCountry2, Country.Name, dataValues$minYear:dataValues$maxYear)
        })
        
        output$plotData <- renderPlotly({
                ds <- rbind.fill(dataValues$ds1, dataValues$ds2)
                ds <- melt(ds, id.vars="Country.Name")
                names(ds) <- c("Country", "Year", "GDP")
                ds$GDP <- round(ds$GDP, 2)   
                
                plot_ly(ds, x = ~Year, y = ~GDP, name = ~Country, type = 'scatter', mode = 'lines')
                
        })
        
        output$txtAvgGdp1 <- renderText({
                d1 <- melt(dataValues$ds1, id.vars="Country.Name")
                names(d1) <- c("Country", "Year", "GDP")
                d1$GDP <- replace(d1$GDP, is.na(d1$GDP), "0")
                
                paste(d1[1, ]$Country, round(mean(as.numeric(d1$GDP)), 2), sep = " - ")
        })
        
        output$txtAvgGdp2 <- renderText({
                d2 <- melt(dataValues$ds2, id.vars="Country.Name")
                names(d2) <- c("Country", "Year", "GDP")
                d2$GDP <- replace(d2$GDP, is.na(d2$GDP), "0")
                
                paste(d2[1, ]$Country, round(mean(as.numeric(d2$GDP)), 2), sep = " - ")
        })
        
        output$txtYear <- renderText({
                paste(input$slideryear[1], input$slideryear[2], sep = " - ")
        })
        
})