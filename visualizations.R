library(RJDBC)
library(ggthemes)
library(tidyverse)
library(scales)
library(readr)
library(reshape2)

vDriver <- JDBC(classPath = '/Users/adrianpascual/Documents/R Drivers/vertica-jdbc-8.1.1-18.jar')

vertica <- dbConnect(drv = vDriver, 
                     "driver",
                     "user", "password")

colors_1 <- c('#F4F7F9', '#E6F5FB', '#E1E1E1', '#48C0EB', '#124F8C',
                     '#414141', '#C41231', '#F7A11A', '#0EC534', '#CDF2FF', 
                     '#5F6974', '#000000')

theme_1 <- theme_minimal()+
  theme(text = element_text(family = 'Avenir Next', size = 10),
        plot.title = element_text(hjust = 0.5, face=c('bold.italic')),
        plot.margin = unit(rep(.5,4),"cm"),
        panel.grid = element_blank())

all_12 <- dbGetQuery(vertica, 'select * from bl_pascuala.cap_12;') %>%
mutate(year = '2012')

all_16 <- dbGetQuery(vertica, 'select * from bl_pascuala.cap_16;')%>%
mutate(year = '2016')

yes_16 <- dbGetQuery(vertica, 'select * from bl_pascuala.yes_16;')

top <- union_all(all_12, all_16, by = c("xtab" = "xtab"))

party<-c("Democrat","Republican")

support<-c("Indifferent","Oppose","Support")

race <- c("Hispanic","White","Other","Black")

ed_name<- c("HS Degree", "Less than HS", "Some College", "Bachelors", "Graduate")

###############################################################################################

draft<- filter(all_16, xtab_type =="vote_16", xtab != "other")
ggplot(draft, aes(x = reorder(xtab, delay_care_yes), delay_care_yes, fill = xtab)) + 
geom_bar(stat = "identity", width = .6)+
theme_1+
labs(title = '2016', y = '% of All Voters', x = 'Voter Choice', fill = "Legend") +
scale_y_continuous(limits = c(0, .3), labels = percent_format(accuracy = 1)) + 
geom_hline(yintercept = .279, linetype = "dashed") +
scale_fill_manual("Legend", values = c("#124F8C", "#C41231")) +
  theme( legend.position = "none"
        , axis.title.y = element_blank()
        , axis.title.x = element_blank()
        , axis.text.y.left = element_blank()
        , plot.title = element_text(size=20)
        , legend.title = element_text(size=18)
        , legend.text = element_text(size =15)
        , axis.text=element_text(size=15)
        , axis.title = element_text(size = 19)) + 
  geom_text(aes(label = percent(delay_care_yes, accuracy = 1), vjust = -.5),size = 5) + 
 scale_x_discrete(labels= party)

ggsave("2016_voter.png", height = 6,width = 7)
  

draft<- filter(all_12, xtab_type =="vote_12", xtab != "other")
ggplot(draft, aes(x = reorder(xtab, -delay_care_yes), delay_care_yes, fill = xtab)) + 
  geom_bar(stat = "identity", width = .5)+
  theme_1+
  labs(title = '2012', y = '% of All Voters', x = 'Voter Choice', fill = "Legend") +
  scale_y_continuous(limits = c(0, .3), labels = percent_format(accuracy = 1)) + 
  geom_hline(yintercept = .22, linetype = "dashed") +
  scale_fill_manual(values = c("#124F8C", "#C41231")) +
  theme(axis.title.x =element_blank(),
        , plot.title = element_text(size=20)
        , legend.position = "none"
        , axis.text=element_text(size=17)
        , axis.title = element_text(size = 19)) + 
  geom_text(aes(label = percent(delay_care_yes, accuracy = 1), vjust = -.5),size = 5) +
scale_x_discrete(labels= party)

ggsave("2012_voter.png", height = 6,width = 7)

###############################################################################################
#Age

draft<- filter(all_16, xtab_type =="age")
ggplot(draft, aes(x = reorder(xtab, -obama_trump_mov), obama_trump_mov, fill = xtab)) + 
  geom_bar(stat = "identity", width = .6)+
  theme_1+
  labs(title = '2016', y = '% of Obama-Trump Voters', x = 'Age', fill = "Legend") +
  scale_y_continuous(limits = c(0, .12), labels = percent_format(accuracy = 1)) + 
  theme( plot.title = element_text(size=20)
        , legend.position = "none"
        , axis.text=element_text(size=15)
        , axis.title = element_text(size = 19)) + 
  geom_text(aes(label = percent(obama_trump_mov, accuracy = 1), vjust = -.5),size = 5) +
  scale_fill_manual(values = colors_1[c(5,8,4,11)])

ggsave("2016_age.png", height = 8,width = 10)

#Race 

draft<- filter(all_16, xtab_type =="race", xtab != "asian")
ggplot(draft, aes(x = reorder(xtab, -obama_trump_mov), obama_trump_mov, fill = xtab)) + 
  geom_bar(stat = "identity", width = .6)+
  theme_1+
  labs(title = '2016', y = '% of Obama-Trump Voters', x = 'Race', fill = "Legend") +
  scale_y_continuous(limits = c(0,.12 ), labels = percent_format(accuracy = 1)) + 
  theme( plot.title = element_text(size=20)
         , legend.position = "none"
         , axis.text=element_text(size=15)
         , axis.title = element_text(size = 19)) + 
  geom_text(aes(label = percent(obama_trump_mov, accuracy = 1), vjust = -.5),size = 5) +
  scale_fill_manual(values = colors_1[c(5,8,4,11)])+
  scale_x_discrete(labels= race)

ggsave("2016_race.png", height = 8,width = 10)

#Education
xaxis <-c("Obama Trump Voter", "Republican"  ,"Democrat", "Romney Clinton Voter" )

names <-c("Obama Trump Voter",  "Romney Clinton Voter","Dem_16","Rep_16" )

draft<- filter(all_16, xtab %in% names)
ggplot(draft, aes(x = reorder(xtab, -delay_care_yes), delay_care_yes, fill = xtab)) + 
  geom_bar(stat = "identity", width = .6)+
  theme_1+
  labs(title = 'Support Breakdown', subtitle = '2016',  y = '% Delaying Care', fill = "Legend") +
  scale_y_continuous(labels = percent_format(accuracy = 1)) + 
  theme( plot.title = element_text(size=20)
         , axis.title.x = element_blank()
         , legend.position = "none"
         , axis.text=element_text(size=15)
         , axis.title = element_text(size = 19)) + 
  geom_text(aes(label = percent(delay_care_yes, accuracy = 1), vjust = -.5),size = 5) +
  scale_fill_manual(values = colors_1[c(11,4,7,5)]) +
  scale_x_discrete(labels= xaxis)


ggsave("2016_party_sup.png", height = 6,width = 10)



###############################################################################################
# Political ID 

draft<- filter(all_16, xtab_type =="party_id")
ggplot(draft, aes(x = factor(xtab,level = c('Strong Dem', 'Lean Dem', 'Independent', 'Lean Rep', 'Strong Rep')), delay_care_yes, fill = xtab)) + 
  geom_bar(stat = "identity", width = .6)+
  theme_1+
  labs(title = 'Delay Care Party ID Breakdown', y = '% of Voters Delaying Care', x = 'Party Identification', fill = "Legend") +
  scale_y_continuous(limits = c(0, .5), labels = percent_format(accuracy = 1)) + 
  theme( plot.title = element_text(size=20)
        , legend.position = "none"
        , legend.text = element_text(size =15)
        , axis.text=element_text(size=15)
        , axis.title.y = element_text(size =15)
        , axis.title.x = element_blank()
        , axis.text.x = element_text(vjust = 4)) + 
  geom_text(aes(label = percent(delay_care_yes, accuracy = 1), vjust = -.5),size = 5) +
  scale_fill_manual(values =c('#808080','#a7d0e4','#f7b799','#3884bb','#ca4842'))

ggsave("2016_party.png", height = 5,width = 11)

draft<- filter(yes_16, xtab_type =="party_id")
ggplot(draft, aes(x = factor(xtab,level = c('Strong Dem', 'Lean Dem', 'Independent', 'Lean Rep', 'Strong Rep')), yes_voted_16, fill = xtab)) + 
  geom_bar(stat = "identity", width = .6)+
  theme_1+
  labs(title = 'Turnout by Party ID', y = '% of Respondent Turnout', x = 'Party Identification', fill = "Legend") +
  scale_y_continuous(labels = percent_format(accuracy = 1)) + 
  theme( plot.title = element_text(size=20)
         , legend.position = "none"
         , legend.text = element_text(size =15)
         , axis.text=element_text(size=15)
         , axis.title.y = element_text(size =15)
         , axis.title.x = element_blank()
         , axis.text.x = element_text(vjust = 4)) + 
  geom_text(aes(label = percent(yes_voted_16, accuracy = 1), vjust = -.5),size = 5) +
  scale_fill_manual(values =c('#808080','#a7d0e4','#f7b799','#3884bb','#ca4842'))

ggsave("2016_turn_out.png", height = 6,width = 10)


###############################################################################################
# ACA Support Breakdown 

draft<- filter(all_16, xtab_type =="aca_support", xtab != "mildly support", xtab != "mildly oppose")
ggplot(draft, aes(x =xtab, pct_of_respondents, fill = xtab)) + 
  geom_bar(stat = "identity", width = .6)+
  theme_1+
  labs(title = 'ACA Support', subtitle = '2016', y = '% of All Voters', x = 'Party Identification', fill = "Legend") +
  scale_y_continuous(limits = c(0, .4), labels = percent_format(accuracy = 1)) + 
  theme( plot.title = element_text(size=20)
         , legend.position = "none"
         , legend.text = element_text(size =15)
         , axis.text=element_text(size=15)
         , axis.title.y = element_text(size =15)
         , axis.title.x = element_blank()
         , axis.text.x = element_text(vjust = 4)) + 
  geom_text(aes(label = percent(pct_of_respondents, accuracy = 1)), vjust = -.5,size = 5) +
  scale_fill_manual(values = colors_1[c(11,7,5)]) +
scale_x_discrete(labels= support)

ggsave("2016_aca1.png", height = 6,width = 7)
                    

draft<- filter(all_16, xtab_type =="aca_support", xtab != "mildly support", xtab != "mildly oppose")
ggplot(draft, aes(x = xtab, delay_care_yes, fill = xtab)) + 
  geom_bar(stat = "identity", width = .6)+
  theme_1+
  labs(title = 'Delaying Care', subtitle = '2016', y = '% Delaying Care', x = 'Party Identification', fill = "Legend") +
  scale_y_continuous(limits = c(0, .4), labels = percent_format(accuracy = 1)) + 
  theme( plot.title = element_text(size=20)
         , legend.position = "none"
         , legend.text = element_text(size =15)
         , axis.text=element_text(size=15)
         , axis.title.y = element_text(size =15)
         , axis.title.x = element_blank()
         , axis.text.x = element_text(vjust = 4)) + 
  geom_text(aes(label = percent(delay_care_yes,accuracy = 1), vjust = -.5),size = 5) +
  scale_fill_manual(values = colors_1[c(11,7,5)]) +
  scale_x_discrete(labels= support)

ggsave("2016_aca2.png", height = 6,width = 7)

###############################################################################################
# Income 

draft<- filter(top, xtab_type =="pre_tot_income")
ggplot(draft,aes(x = reorder(xtab, -delay_care_yes),y = delay_care_yes)) + 
  geom_bar(aes(fill = year),stat = "identity",position = "dodge") +
  labs( y = '% Delaying Care', x = 'Income', fill = "Year") +
  scale_y_continuous(limits = c(0, .4), labels = percent_format(accuracy = 1)) + 
  theme_1 +
  theme( legend.position = 'top'
         ,legend.spacing.x = unit(.2, 'cm')
          ,plot.title = element_text(size=25)
         , legend.title = element_blank()
         , legend.text = element_text(size =20)
         , axis.text=element_text(size=20)
         , axis.title.y = element_text(size =20)
         , axis.title.x = element_blank()
         , axis.text.x = element_text(vjust = 4)) + 
  scale_fill_manual(values = colors_1[c(3,4)])

ggsave("2016_income.png", height = 6,width = 16)
