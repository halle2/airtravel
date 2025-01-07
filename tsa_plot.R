
library("dplyr")
library("tidyverse")
library("ggplot2") 
library("plotly")

tsa_numbers_df <- read.csv("tsanumbers.csv",header = TRUE, stringsAsFactors=FALSE)
tsa2 <- tsa_numbers_df[order(as.Date(tsa_numbers_df$Date, format="%m/%d", rev(tsa_numbers_df$X2021))),]

##line plot over 12 months
attempt1 <- ggplot(tsa2, aes(x= Date, y = X2021, group = 1)) + 
  geom_line(col="skyblue4") + 
  geom_line(aes(y= X2020), col="black") + 
  geom_line(aes(y= X2019), col = "red")+
  geom_line(aes(y= X2022),  na.rm = TRUE, col = "darkolivegreen3") +
  scale_x_discrete(limits=tsa2$Date)
attempt <- attempt1+ylab("Count")+ggtitle ("TSA checkpoint numbers")
ggplotly(attempt)


##with legend
tsagraph <- ggplot(tsa2, aes(x= Date, group = 1)) + 
  geom_line(aes(y = X2021, col="X2021")) + 
  geom_line(aes(y= X2020, col="X2020")) + 
  geom_line(aes(y= X2019, col = "X2019"))+
  geom_line(aes(y= X2022, col = "X2022"), na.rm = TRUE) +
  scale_x_discrete(limits=tsa2$Date)+
  scale_colour_manual("", 
                      breaks = c("X2021", "X2020", "X2019","X2022"),
                      values = c("skyblue4", "black", "red", "darkolivegreen3"))
withlegend <- tsagraph+ylab("Count")+ggtitle ("TSA checkpoint numbers")
ggplotly(withlegend)



##The line chart communicates the trend of the number of passengers screened per year from 2019-2022.
## This gives us a clearer idea of how travel attitudes changed throughout the pandemic.
## We saw the lowest travel numbers during March 2020, and we now appear to be approaching similar travel
##numbers to pre-pandemic.