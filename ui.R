library(ggplot2)
library(plotly)
library(shiny)
library(dplyr)
library(tidyverse)
library(shiny)
    
    
    
    
 # Define UI for application that draws a histogram
  shinyUI(fluidPage(
      
# Application title
titlePanel("Air Travel During Covid-19"),
tags$style(HTML(type="text/css",
                
  "@import url('https://fonts.googleapis.com/css2?family=Montserrat&display=swap');

  body{
  font-family: 'Montserrat';
   margin: 10px
  }
  
  h5{
  font-size: 14px;
  font-weight:bold;
  color: rgb(97,99,100)
  }
  
  h3,h2,a{
  color:rgb(55,112,137);
  font-weight: bold
  }
  

 p{
 color: gray;
 font-size: 14px;
 }
 
 .control-label{
	color: rgb(55,112,137)
}
}")),

      tabsetPanel(
        #overview tab
        tabPanel(
          "Introduction",fluid = TRUE, sidebarLayout(
            sidebarPanel(
              tags$h3("Research Questions"),
               tags$p( "Are air travel numbers set to recover in the US?" ),
              tags$p("How have the attitudes of US travelers changed throughout the pandemic?"),
              tags$p( "How have the rates of flight cancellations and delays changed since Covid-19?"),
              tags$h3("Datasets"),
              tags$a(href="https://www.tsa.gov/coronavirus/passenger-throughput", 
                     "TSA Dataset"),
              tags$p("This dataset of TSA checkpoint travel numbers is from the TSA website. The TSA keeps track of the number of passengers that are screened throughout airports in the US each day. 
              The set up allows us to easily compare the number of passengers year to year. The website is updated at 9am daily and is periodically adjusted to include Known Crewmembers and later flight travel numbers.
                As the TSA website omits the day that the dataset is viewed in order to update that information, there were 217 entries for 2022 and 364 entries for prior years."),
              tags$a(href="https://covid.cdc.gov/covid-data-tracker/#trends_dailycases_select_00", 
                     "Covid Cases"),
              tags$p("From the CDC website, this dataset tracks the weekly number of people who tested positive for Covid-19 in the US."),
              tags$a(href="https://www.transtats.bts.gov/Data_Elements.aspx?Data=3", 
                     "Domestic vs International"),
              tags$p("This dataset is also from the Bureau of Transportation Statistics website, as part of USDOT. Due to confidentiality agreements for individual routes, data from the last three months (06/2022-08/2022) is currently withheld. 
                     The data covers the count and proportion of passengers travelling international and domestic in the US."),
              tags$a(href="https://www.transtats.bts.gov/homedrillchart.asp", 
                     "Arrival Statistics"),
              tags$p("This dataset is also from the Bureau of Transportation Statistics website, and currently does not include information past May 2022. The information is based on submitted data by reporting carriers.
                     The data covers ontime arrivals, delays, cancellations, and total flight operations per year in both numbers and percentages.
                     A flight is considered delayed if it arrived or departed at least 15 minutes later than the scheduled arrival or departure time.
                     The major carriers that are part of this report are Alaskan Airlines, American West, American Airlines, Continental Airlines, Delta Air Lines, Northwest Airlines, Southwest Airlines
                     Trans World Airways, United Airlines, and US Airways.
                    ")
              ),
      mainPanel(
        tags$h3("Introduction"),
        tags$p("In 2020, air travel fell by about 60% compared to 2019, resulting in the sharpest decline in history.
                On June 26, 2022, almost 2.5 million people passed through security checkpoints, the most travelers who have passed through airports in the US since February 2020.
                Tourism and travel are two of the industries most affected by the pandemic, and current travel trends suggest that air travel demands are starting to recover.
                As Covid-19 restrictions began to ease throughout the past year, international and domestic travel have faced numerous challenges as the daily number of passengers screened reach pre-pandemic levels. 
                Combined with staffing shortages, the annual rise of flight delays and cancellations in the summer, referred to as the “summer air travel mess”, appears to be worse than ever. "),
        tags$h3("Purpose") ,      
         tags$p("Our project explores Covid’s impact on aviation and the attitude of the public in the US throughout the pandemic (2019-2022). "),
        tags$img(src = "https://media.cntraveler.com/photos/5b115f760f509f517884146b/master/pass/crowded-airport-GettyImages-670570760.jpg",
            width = "100%", height = "100%"),
        tags$p("Denver International Airport")
       ))),
 
    tabPanel(
      "TSA Numbers",
      sidebarLayout(
        sidebarPanel(
         radioButtons(
         inputId = "tsa",
         label = "select year",
         choices = list("2019", "2020", "2021", "2022", "all"),
          selected = "all"
          ),
         tags$h3("Purpose and Insight"),
         tags$p("The first graph displays the trends in air travel passengers from 2019-2022.
         The purpose is to give us a better understanding of travel attitudes during the pandemic.
                The reader is able to switch between years or view and compare the number of passengers across all four years.
                We saw a sharp decline in March 2020, and we now appear to be approaching similar travel numbers to pre-pandemic."),
         tags$p("The second graph illustrates the number of Covid cases from January 1, 2020 to August 2, 2022. " )
      ),

      mainPanel(
         tags$h3("Line Plot of TSA Checkpoint Numbers and Covid Numbers"),
        plotlyOutput(outputId="line"),
        plotlyOutput(outputId = "covid")
      ))
      ),
    tabPanel(
      "International vs Domestic",
      sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "choose", 
                      label = h3("Select a year"), 
                      choices = list("2019", "2020", "2021", "2022", "all"), 
                      selected = "all"
          ),
          tags$h3("Purpose and Insight"),
          tags$p("These bar charts charts illustrate the travel trends of US passengers throughout the pandemic. 'All' displays the proportion of passengers who traveled international and domestic from 2019-2022.
        The reader can access different years by clicking through the drop down menu, and specific years display the total number of passengers traveling domestically and internationally for that year (until May 2022).
       We can see that the proportion of passengers travelling international is roughly the same from 2020-2021, and 2022 seems to be approaching a similar level to that of 2019.")
        ),
        mainPanel(
          tags$h3("International vs Domestic"),
          plotlyOutput(outputId = "bar"),
        ))),
    tabPanel(
      "Flight Statistics",
      sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "select", 
                      label = h3("Select a year"), 
                      choices = list("2019", "2020", "2021", "2022"), 
                      selected = "2019"
        ),
        tags$h3("Purpose and Insight"),
        tags$p("These pie charts communicate the proportion of ontime, delayed, and cancelled flights from January 2019 - May 2022.
        The reader can access different years by clicking through the drop down menu, and they are able to view the summary statistics as well.
        Though the number of flight cancellations in 2022 is greater than that of the previous year and 2019, the proportions of each in 2022 appears to be similar to that of 2019 (as of May 2022).",
               "2022 saw the most delays and cancellations, and 2021 saw the least." )
      ),
      mainPanel(
        tags$h3("Airline Statistics"),
        plotlyOutput(outputId = "pie"),
        tableOutput(outputId = "info"),
      ))),
    tabPanel(
      "Conclusion",
      sidebarLayout(
      sidebarPanel(
      
      tags$h3("Further Questions to Consider"),
      tags$p("How have staffing numbers changed over the pandemic? Which sector has been most affected? How has this affected practices in the travel industry?"),
       tags$p("How have international travel trends changed and how does that compare to the US?"), 
      tags$p("Which airports have the most traffic?")
     ),
     mainPanel(
       tags$h3("Takeaways"),
       tags$p(""),
     tags$p("1. With the rise of Covid cases came the decline of air travel as travel restrictions and lockdowns greatly reduced travel demand.
              Now, almost 2.5 years into the pandemic, the travel industry is seeing a steady increase in passenger traffic, nearly reaching pre-pandemic numbers. 
            Like 2019, this year's median number of daily passengers screened has been above 2 million, as compared to 1.65 million and 718,000 in 2021 and 2020 respectively.
            Additionally, the bar charts show that there was a decrease in international travel during 2020 and 2021, and an  increase in 2022.
            Though up-to-date domestic and international statistics have not been released yet, our current data suggests that the proportion of domestic and international travel look to be approaching 2019 statistics (roughly 12% international and 88% domestic). "),
     
     tags$p("
2. By looking at the trends in Covid cases and travel numbers, we can examine patterns in travel behavior, positive cases, and risk perception throughout the pandemic. 
From our graphs, we can see that people tend to travel more during breaks and holidays (regardless of Covid rates), and this is usually followed by a spike in Covid cases the weeks after.
The US lifted its international entry travel ban in November 2021, which was followed by a spike in January 2022, peaking at 810,878 cases on January 15th. 
Despite warnings of the highly contagious Omicron variant, the number of passengers traveling continued to stay above 1.5 million per day during the holiday season.
We can see that passenger numbers steadily rose near late-December 2021 and early-January and dropped throughout the rest of the month before climbing back up in February. 
The Covid surge in January resulted in US hospitalizations skyrocketing and many schools/workplaces going remote.
Although there were still over 50,000 cases of Covid in the US, the public risk perception of contracting Covid appears to be relatively low as the average number of daily passengers screened reached almost 2 million a day.
            "),
     
     tags$p("3. Furthermore, despite the seemingly overwhelming number of travel plans disrupted due to flight delays and cancellations,
              the overall change in on-time performance up until May is relatively slight when compared to pre-pandemic numbers. 
              Looking at the 'Airtime Statistics' pie charts, we can see that there has been a 2% decrease in on-time flights,
          a 2% increase in delayed flights and 1% increase in cancelled flights in comparison to 2019.
           Considering the increase in air travel demand and obstacles caused by staffing shortages, air travel in 2022 as of May has not changed as drastically as many believe."),
       
     
     tags$img(src = "https://i.pinimg.com/originals/90/67/a7/9067a700ebb78f62a508c4139ddca004.jpg",
           width = "75%", height = "75%"),
       tags$p("")
     )
      ))
    )))
 
