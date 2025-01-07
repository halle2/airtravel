library("dplyr")
library("tidyverse")
library("ggplot2") 
library("plotly")

covid_numbers_df <- read.csv("covid_cases.csv",header = TRUE, stringsAsFactors = FALSE)
covid_numbers_df <- covid_numbers_df%>%
  mutate(Dates = as.Date(Date,format = "%B %d %Y"))%>%
  select(Dates,X7.Day.Moving.Avg)

attempt1 <- ggplot(covid_numbers_df, aes(x= Dates, y = X7.Day.Moving.Avg, group = 1)) + 
  geom_point(col="cadetblue2") + 
  geom_line(size = 0.25 , alpha = 0.5)+
  scale_x_date(date_labels = "%Y %b %d")
attemptplot <- attempt1+ylab("Averages per week")+ggtitle ("Weekly COVID-19 Average Cases")
ggplotly(attemptplot)
