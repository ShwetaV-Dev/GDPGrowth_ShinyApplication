library(shiny)
library(plotly)
library(ggplot2)
library(reshape)
library(plyr)

#load data
GDP_Data <- read.csv("GDPData.csv", skip = 4)
if (is.null(GDP_Data)) 
        return(NULL)

shinyUI(fluidPage(
        
        titlePanel("GDP growth % around the World for Years 1960-2017"),
        
        sidebarLayout(
                sidebarPanel(
                        helpText("Select a range of years between 1960 and 2017 to explore the GDP trends around the world.
                                 Below you can also compare the global growth percentage changes (by country) for selected years. On the right,
                                 they can be visualized in a multiline plot."),
                        tags$hr(),
                        sliderInput('slideryear', 'Select Year Range', 1960, 2017, value = c(1960, 2017), sep = ""),
                        tags$hr(),
                        selectInput('countryname1', 'Choose A Country', GDP_Data$Country.Name, selected = 'Afghanistan'),
                        tags$hr(),
                        selectInput('countryname2', 'Choose Another Country', GDP_Data$Country.Name, selected = 'Afghanistan'),
                        tags$hr(),
                        submitButton("Submit")
                ),
                
                
                mainPanel(
                        plotlyOutput("plotData"),
                        h3("Input Year :"),
                        textOutput("txtYear"),
                        h3("Average GDP growth (%) over the years :"),
                        textOutput("txtAvgGdp1"),
                        textOutput("txtAvgGdp2"),
                        tags$hr(),
                        p(strong(em("Documentation:",a("GDP Growth Percentage Trend For Countries",href="include.Rhtml")))),
                        p(strong(em("Github repository:",a("GDP Growth - Shiny App",href="https://github.com/ShwetaV-Dev/GDPGrowth_ShinyApplication")))),
                        p(strong(em("Source: ", a("Data has been obtained from the Data Worldbank. Note that some values for some years are missing.", 
                                        href = "https://data.worldbank.org/indicator/NY.GDP.PCAP.KD.ZG"))))
                )
                
        )
        
)

)
