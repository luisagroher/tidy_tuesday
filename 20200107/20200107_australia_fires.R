suppressWarnings(library(tidyverse))
suppressWarnings(library(ggplot2))
suppressWarnings(library(lubridate))
suppressWarnings(library(leaflet))
suppressWarnings(library(htmlwidgets))

# load the nasa fire data
nasa_fire <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-07/MODIS_C6_Australia_and_New_Zealand_7d.csv')

# convert date to dateformat
nasa_fire$acq_date <- ymd(paste(nasa_fire$acq_date))


# set up color palette
pal <- colorNumeric(palette = "YlOrRd",domain = nasa_fire$brightness)

# create amp
m <- leaflet(data = nasa_fire[nasa_fire$acq_date > '01-01-2019', ]) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>%
    addCircles(lng = ~longitude, lat = ~latitude, weight = 1, color=~pal(brightness),
              radius = ~brightness*10, popup = ~acq_date)


# save map as html file
saveWidget(m, file="australia_fires.html")


