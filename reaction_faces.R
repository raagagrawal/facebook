#loading libraries
library(dplyr)
library(tidyr)
library(rvest)
library(ggplot2)
library(lubridate)
library(XML)
library(rvest)
library(gplots)

#define the address to the message.html file of interest in the chat directory you are interested in
directory <- "YOUR_FOLDER_NAME/messages/inbox/YOUR_CHAT_OF_INTEREST/message.html"
scraping <- read_xml(directory)

#Generate data.frame of all facebook messenger reactions 
reactions <- scraping %>%
  html_nodes("li") %>%
  html_text()%>% 
  data_frame()

#seperate out the reaction face and the name of the person who made it
reactions$emoji <- substr(reactions$.,1,1)
reactions$names <- substr(reactions$.,2,15)
reactions <- reactions[,c("emoji","names")]
reactions$emoji <- as.factor(reactions$emoji)
reactions$names <- as.factor(reactions$names)

#replace emoji with description since emoji don't play nice with ggplot
reactions$emoji <- gsub("\U0001f44d","Thumbs Up",reactions$emoji)
reactions$emoji <- gsub("\U0001f44e","Thumbs Down",reactions$emoji)
reactions$emoji <- gsub("\U0001f606","Laughing Face",reactions$emoji)
reactions$emoji <- gsub("\U0001f60d","Heart Eyes",reactions$emoji)
reactions$emoji <- gsub("\U0001f622","Crying Face",reactions$emoji)
reactions$emoji <- gsub("\U0001f620","Angry Face",reactions$emoji)
reactions$emoji <- gsub("\U0001f62e","Wow Face",reactions$emoji)

# Basic barplot
g <- ggplot(reactions, aes(emoji))
g <- g + geom_bar(aes(fill = names))
g <- g + labs(title = "Facebook Emoji Reactions", subtitle = "Data taken from conversations with Anonymous Friend",x = "Emoji",y="Count")
g <- g + guides(fill=guide_legend(title="Person")) + theme(axis.text.x = element_text(angle = 90, hjust = 1))
g
