library(tidyverse)
library(lubridate)
sf_trees <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-28/sf_trees.csv')
sf_trees[is.na(sf_trees$date),]$date <- '1949-01-01'



sf_trees %>%
  mutate(date=ymd(date),
         year=year(date),
         decade=year- year%%10,
         common_name = str_split(species, " ::") %>% map_chr(.,2)) %>%
  filter(year >= 1955) %>%
  select(common_name, decade)%>%
  group_by(common_name, decade) %>%
  summarise(count=n()) %>%
  group_by(decade)%>%
  arrange(desc(count))%>%
  slice(1)
  

sf_trees %>% 
  mutate(date = ymd(date),
         year = year(date),
         decade = year - year %% 10,
         caretaker_type = ifelse(caretaker=="Private", "Private", "Public")) %>%
  filter(year >= 1970)%>%
  group_by(year, caretaker_type) %>%
  summarise(count = n()) %>%
  select(year, caretaker_type, count) %>%
  arrange(year) %>%
  ggplot(aes(x=year, y=count, fill=caretaker_type)) + 
  geom_bar(stat="identity", position="stack") +
  labs(title = "Trees planted in San Francisco between 1970 and 2020 by public / private Sources",
       subtitle = "Based on San Francisco's open data portal, packaged by #rstats #TidyTuesday",
       x="Year",
       y="Number of Trees Planted") +
  scale_fill_manual("legend", values = c("Private" = "#669900", "Public" = "#003300")) +
  theme_bw()
ggsave("SFTrees.png", dpi=300, width = 12, height = 9, units = "in")