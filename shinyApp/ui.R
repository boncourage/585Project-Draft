library(shiny)

shinyUI(fluidPage(
  
  #Top Part-Title
  titlePanel("House Price Index for US states and 25 Metropolitan Cities"),
  br(),
  
  #Left Part-SideBar Panel
  sidebarPanel(
   
  selectInput("variable", "Choose the period of year :",
                c("Year 2007-2008" = "income07_08",
                  "Year 2008-2009" = "income08_09",
                  "Year 2009-2010" = "income09_10",
                  "Year 2010-2011" = "income10_11",
                  "Year 2011-2012" = "income11_12"
                )),
    
  br(),
  
  #Show or Hide Map Legends on the US map
  checkboxInput("legend", "Hide Map Legends", FALSE),
  br(),
  
  # Specification of range of Point Size and Transparency
  sliderInput("max", "Choose Size of Points:",
              min = 6, max = 30, value = 15),
  br(),
  
  sliderInput("alphapoint", "Choose Transparency of Points:",
              min = 0.1, max = 0.8, value = 0.5),
  br(),
  
  #Show or Hide City Labels on the US map and Control These Labels
  checkboxInput("label", "Hide City Labels", FALSE),
  br(),
  
  sliderInput("scale", "Choose Size of Labels:",
              min = 1, max = 10, value = 5),
  br(),
  sliderInput("alphatext", "Choose Transparency of Labels:",
              min = 0.1, max = 0.8, value = 0.5),
  br(),
  
  helpText("First, select a period of time to see Relationship of House Price Index and Per Capita 
           Personal Income of Metropolitan Cities in US. You can change Visualization views by dragging slider
           bars below."),
  br()
  #submitButton("Update View")
  ),
  
  #Right Part-Main Panel
  mainPanel(
   tabsetPanel(type = "tabs",
              
              tabPanel("Plot", h4(textOutput("caption1")), plotOutput("plot")), 
             tabPanel("Summary",h4(textOutput("caption2")),verbatimTextOutput("summary")), 
            tabPanel("Table",h4(textOutput("caption3")),
                     numericInput("obs", "Number of observations to view in Table :",min=1,max=50,value=6),
                     radioButtons('sorting', 'Choose the variable to sort :',
                                  c(HPI='hpi',
                                    Income='income')),
                     
                     #selectInput("sorting", "Choose the variable to sort :",
                    #             c("Descending by house price index" = "hpi",
                    #               "Descending by personal income" = "income")),
                     br(),br(),tableOutput("view"))
  ))
  
))




