library(shiny)
library(maps)
library(ggmap)
library(grid)
library(dplyr)
#setwd("E:/RdefaultWorkSpace/STAT585X-FinalProject/shinyApp")
hpi.income<-read.csv("income-hpi-map-shinydata3.csv")
mapdf <- map_data("state")
map<-ggplot(mapdf)+geom_polygon(aes(x=long, y=lat,  group = group),
  fill="grey90",color=I("white"), size=0.5, data=mapdf) + 
  theme_bw() + theme(axis.text=element_blank(), 
                     axis.title=element_blank(),
                     axis.line=element_blank(),
                     axis.ticks=element_blank(),
                     panel.border=element_blank(),
                     panel.grid=element_blank(),
                     aspect.ratio=1/1.5,
                     plot.margin=unit(c(-1,-1,-1,-1), units="cm"))
  
##############################################################################################
#Start Siny Server!
shinyServer(function(input, output){
  inputData=hpi.income
  subset=select(hpi.income,city,state,lat,long)
  
  formulaText1<-reactive({
    paste("hpi ~",input$variable)
  })
  
  
  output$caption1<-renderText({
    paste("Relationship of House Price Index and Personal 
          Income for US largest cities in 1 year period : ",formulaText1()) 
  })
  output$caption2<-renderText({
    paste("A summary of dataset for",formulaText1()) 
  })
  output$caption3<-renderText({
    paste("Show table of dataset and sort cities by ",formulaText1()) 
  })
  
  output$plot<-renderPlot({
    income<-inputData[,which(names(inputData)==input$variable)]
    hpi<-inputData[,which(names(inputData)==input$variable)+5]
    data<-cbind(subset,income,hpi)
    p<-map+geom_point(data=data,mapping=aes(x=long, y=lat,color=hpi,size=income),alpha=I(input$alphapoint))+
      scale_colour_gradient("HPI change",low=("blue"),high=("red"))+  
      scale_size_continuous("Income Change", range = c(4,input$max))
    
    if (input$label) {
      if(input$legend){
        print(p+theme(legend.position="none"))
      }else{
        print(p)
      }
    } else {
      if(input$legend){
        print(p+annotate("text",x=data$long+3,y=data$lat,label=as.character(data$city),
                         size=abs(data$income)/max(abs(data$income))*input$scale+5,
                         alpha=I(input$alphatext))+theme(legend.position="none") )
      }else{
        print(p+annotate("text",x=data$long+3,y=data$lat,label=as.character(data$city),
                         size=abs(data$income)/max(abs(data$income))*input$scale+5,
                         alpha=I(input$alphatext)) )
      }
      
    }
    
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    income<-inputData[,which(names(inputData)==input$variable)]
    hpi<-inputData[,which(names(inputData)==input$variable)+5]
    data<-cbind(subset,income,hpi)
    summary(data[,-which(names(data) %in% c("lat","long"))])
  })
  
  output$view<-renderTable({
    income<-inputData[,which(names(inputData)==input$variable)]
    hpi<-inputData[,which(names(inputData)==input$variable)+5]
    data<-cbind(subset,income,hpi)
    data<-data[,-which(names(data) %in% c("lat","long"))]
    head(data,input$obs)
     #head(arrange(data,desc(input$sorting)),input$obs)
  })
  
})