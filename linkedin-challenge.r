library(tidyverse)
library(ggplot2)
library(ggmap)

register_google(key="AIzaSyDk7OPYBAwZBHKX19Kxkpe_x1P71YOO56c")

college <- read_csv("http://672258.youcanlearnit.net/college.csv")
summary(college)
# Factorizing the data
college <- college %>% mutate(state= as.factor(state), region=as.factor(region), highest_degree= as.factor(highest_degree),
                              control=as.factor(control), gender=as.factor(gender),loan_default_rate= as.numeric(loan_default_rate))
summary(college)

#Only consider data from CA state
college <- college %>% filter(state=='CA')

#Fetch Map of California Counties
california=map_data(map="county", region="california")

#Plot select cities names on the map:
city_names <- c("Los Angeles", "San Diego", "San Jose", "Fresno", "Sacramento","San Francisco")

#Fetch the Geocodes of the said cities
locations <- geocode(city_names)
locations

cities <- tibble(name=city_names, lat=locations$lat, lon=locations$lon)
cities


  #Adding Text Labels
  ggplot(california)+
    geom_polygon(mapping=aes(x=long, y=lat, group=group), color="grey", fill="beige")+
    coord_map()+
    theme(plot.background = element_blank(), 
          panel.background =element_blank(), 
          axis.title = element_blank(), 
          axis.ticks=element_blank(),
          axis.text = element_blank())+ 
    geom_point(data=college, mapping=aes(x=lon, y=lat, color=control, size=undergrads),  alpha=0.5)+
    geom_text(data=cities, mapping = aes(x=lon, y=lat, label=name))+
    scale_size_continuous(name="Undergraduate Population")+
    scale_color_discrete(name="Institutional Control")+ 
    theme(legend.key=element_blank())+ 
    ggtitle("Most California Colleges are located in Large Cities", subtitle="Source: U.S. Department of Education")
  
  
