#load packages
library(shiny)
library(dplyr)
library(plotly)
library(ggplot2)
library(data.table)

tsa_numbers_df <- read.csv("tsanumbers.csv", header = TRUE, stringsAsFactors=FALSE)
tsa2 <- tsa_numbers_df[order(as.Date(tsa_numbers_df$Date, format="%m/%d", rev(tsa_numbers_df$X2021))),]
travelstats <- read.csv("airtravel.csv",header = TRUE, stringsAsFactors=FALSE)

travelstatistics <- read.csv("departstats_mod.csv",header = TRUE, stringsAsFactors=FALSE)
travelstatistics[, 2:5] <- lapply(travelstatistics[, 2:5], function(x) as.numeric(gsub(",", "", x)))

dataset <- travelstatistics[c(1, 3, 5), ] 

passengermod<- read.csv("ustraveltrends.csv", header = TRUE, stringsAsFactors=FALSE)
passenger_prop <- passengermod[-c(1,3,5),]
passenger_num <- passengermod[-c(2,4,5),]
covid_numbers_df <- read.csv("covid_cases.csv",header = TRUE, stringsAsFactors = FALSE)
covid_numbers_df <- covid_numbers_df%>%
  mutate(Dates = as.Date(Date,format = "%B %d %Y"))%>%
  select(Dates,X7.Day.Moving.Avg)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #line graph
  output$line <- renderPlotly({
    if(input$tsa == "all") {
      options(scipen=5)
      ggplot(tsa2, aes(x= Date, group = 1)) + 
        geom_line(aes(y = X2021, col="X2021")) + 
        geom_line(aes(y= X2020, col="X2020")) + 
        geom_line(aes(y= X2019, col = "X2019"))+
        geom_line(aes(y= X2022, col = "X2022"), na.rm = TRUE) +
        scale_x_discrete(limits=tsa2$Date)+
        scale_colour_manual("", 
                            breaks = c("X2021", "X2020", "X2019","X2022"),
                            values = c("skyblue4", "black", "red", "darkolivegreen3"))+
        ylab("Count")+ggtitle ("TSA checkpoint numbers")
    } else if (input$tsa == "2021") {
      ggplot(tsa2, aes(x= Date, y= X2021, group = 1)) + 
        geom_line() + scale_x_discrete(limits=tsa2$Date) +
        ylab("Count")+ggtitle ("TSA checkpoint numbers 2021")
    }else if (input$tsa == "2020") {
      ggplot(tsa2, aes(x= Date, y= X2020, group = 1)) + 
        geom_line()+ scale_x_discrete(limits=tsa2$Date) +
        ylab("Count")+ggtitle ("TSA checkpoint numbers 2020")
    }  else if (input$tsa == "2019") {
      ggplot(tsa2, aes(x= Date, y= X2019 , group = 1)) + 
        geom_line()+ scale_x_discrete(limits=tsa2$Date)+
        ylab("Count")+ggtitle ("TSA checkpoint numbers 2019")
    } else {
      ggplot(tsa2, aes(x= Date, y= X2022, group = 1)) + 
        geom_line()+ scale_x_discrete(limits=tsa2$Date)+
        ylab("Count")+ggtitle ("TSA checkpoint numbers 2022")
    } 
  })
  output$covid <- renderPlotly({
    attempt1 <- ggplot(covid_numbers_df, aes(x= Dates, y = X7.Day.Moving.Avg, group = 1)) + 
      geom_point(col="cadetblue2") + 
      geom_line(size = 0.25 , alpha = 0.5)+
      scale_x_date(date_labels = "%Y %b %d")
    attemptplot <- attempt1+ylab("Averages per week")+ggtitle ("Weekly Trends in Average Number of COVID-19")
  } )
  
  
  #barchart
  output$bar <- renderPlotly({
    if(input$choose == "all") {
      fig <- plot_ly(passenger_prop, x= ~X, y=~X2019, type = "bar", name = "2019")
      fig <- fig %>% add_trace(y = ~X2020, name = '2020')
      fig <- fig %>% add_trace(y = ~X2021, name = '2021')
      fig <- fig %>% add_trace(y = ~X2022, name = '2022')
      fig <- fig %>% layout(title = "Trends Across All Years (2019-2022)" , xaxis=list(title="Domestic vs International"), yaxis = list(title = 'Proportion'), barmode = 'group')
      fig
    }
    else if (input$choose == "2019") {
      plot_ly(passenger_num, x= ~X, y=~X2019, type = "bar") %>%
        layout(title="2019 Trends", xaxis=list(title="Domestic vs International"), yaxis = list(title = 'Count'))
    } else if (input$choose == "2020"){
      plot_ly(passenger_num, x= ~X, y=~X2020, type = "bar") %>% 
        layout(title="2020 Trends", xaxis=list(title="Domestic vs International"), yaxis = list(title = 'Count'))
    } else if (input$choose == "2021") {
      plot_ly(passenger_num, x= ~X, y=~X2021, type = "bar") %>%
        layout(title="2021 Trends", xaxis=list(title="Domestic vs International"), yaxis = list(title = 'Count'))
    }else if (input$choose == "2022"){
      plot_ly(passenger_num, x= ~X, y=~X2022, type = "bar") %>%
        layout(title="2022 Trends (as of May)", xaxis=list(title="Domestic vs International"), yaxis = list(title = 'Count'))
    }
  })
  
  #pie
  output$pie <- renderPlotly({
    if (input$select == "2019") {
      plot_ly(data = dataset, labels = ~X, values = ~X2019, type = "pie",
              textinfo = "label+percent",
              insidetextorientation = "radial")  %>% layout(title = '2019 Pie Chart')
    } else if (input$select == "2020"){
      plot_ly(data = dataset, labels = ~X, values = ~X2020, type = "pie",
              textinfo = "label+percent",
              insidetextorientation = "radial")  %>% layout(title = '2020 Pie Chart')
    } else if (input$select == "2021") {
      plot_ly(data = dataset, labels = ~X, values = ~X2021, type = "pie",
              textinfo = "label+percent",
              insidetextorientation = "radial")  %>% layout(title = '2021 Pie Chart')
    }else if (input$select == "2022"){
      plot_ly(data = dataset, labels = ~X, values = ~X2022, type = "pie",
              textinfo = "label+percent",
              insidetextorientation = "radial")  %>% layout(title = '2022 Pie Chart')
    }
  })
  output$info <- renderTable({
    travelstatistics[c(1,3,5,7),]
  })
})