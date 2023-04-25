library(dplyr)
library(ggplot2)
library(tidyr)






perc_year_dem <- read.csv("Desktop/tmp_stats_boxplot.csv")
names(perc_year_dem)[1] <- "year"

perc_dem_year <- perc_year_dem %>% 
  pivot_longer(
    cols = `X1`:`X7`, 
    names_to = "height_cat",
    values_to = "value"
  )


ggplot(data=perc_dem_year, aes(x=year, y=value, fill=height_cat)) +
  geom_bar(stat="identity")





year_loss_gain <- year_dem

loss_gain_year <- year_loss_gain %>% 
  pivot_longer(
    cols = `V1`:`V4`, 
    names_to = "cat",
    values_to = "value"
  )


ggplot(data=loss_gain_year, aes(x=year, y=value, fill=cat)) +
  geom_bar(stat="identity")
