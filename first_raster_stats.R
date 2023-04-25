library(rgdal)
library(raster)
library(dplyr)

library(ggplot2)


forest_loss <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/detect_alb_(12_03).tif")
forest_gain <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/valid_gain.tif")[[1]]

forest1990 <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/forest_albania_90_22_new.tif")[[1]]
forest2022 <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/forest_albania_90_22_new.tif")[[2]]

hansen_loss <- stack("Desktop/Albania_Thesis/data/hansen_data/hansen_stack_albania.tif")[[5]]
hansen_gain <- stack("Desktop/Albania_Thesis/data/hansen_data/hansen_stack_albania.tif")[[6]]
hansen_loss <- hansen_loss+2000
hansen_loss[hansen_loss == 2000] <- NA

senf_disturbance <- stack("Desktop/Albania_Thesis/data/senf_data/senf_stack_albania.tif")[[1]]
senf_forest <- stack("Desktop/Albania_Thesis/data/senf_data/senf_stack_albania.tif")[[2]]







albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")
alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)
albania <- crop(albania_raw, alb_ext)


plot(albania)

df1 <- as.data.frame(freq(albania[[1]]))
df2 <- as.data.frame(freq(forest1990))
df3 <- as.data.frame(freq(forest_loss[[3]]))
colnames(df3)[2] <- "loss1"
df4 <- as.data.frame(freq(forest_loss[[4]]))
colnames(df4)[2] <- "loss2"
df5 <- as.data.frame(freq(forest_loss[[5]]))
colnames(df5)[2] <- "loss3"
df6 <- as.data.frame(freq(forest_gain))
colnames(df6)[2] <- "gain"
df6.1 <- as.data.frame(freq(hansen_loss))
colnames(df6.1)[2] <- "h_loss"
df6.2 <- as.data.frame(freq(senf_disturbance))
colnames(df6.2)[2] <- "s_loss"








freq(albania)

28783118232/42507527
677.1299


0.06771299

31975233+42507527


freq(forest2022)





plot(df3$value, df3$count)


df7<- left_join(left_join(left_join(left_join(left_join(df3,df4),df5),df6),df6.1),df6.2)

df7[is.na(df7)] <- 0

df7$sum_loss <- rowSums((df7[,2:4]))

df8 <- df7[-34,]

df8[,-1] <- df8[,-1]*0.06771299


plot(df8$value, df8$sum_loss, type="l", col="blue")
lines(df8$value, df8$count, type="l", col="red")
lines(df8$value, df8$sum, type="l", col="blue")
lines(df8$value, df8$gain, type="l", col="green")




ggplot(df8, aes(value, sum_loss)) + 
  geom_bar(stat="identity", position="dodge") + 
  scale_x_continuous(breaks=1990:2022)



df8$added_loss <- 0
df8$added_gain <- 0


df8$forest_left <- df2$count[1]*0.06771299

for (i in c(1:33)){
  df8$added_loss[i] <- sum(df8$sum_loss[1:i])
  df8$added_gain[i] <- sum(df8$gain[1:i])
  if (i<33) {
    df8$forest_left[i+1] <- df8$forest_left[i] - df8$sum_loss[i] + df8$gain[i]
  }

}

#wrong version
for (i in c(1:33)){
  df8$added_loss[i] <- sum(df8$sum_loss[1:i])
  df8$added_gain[i] <- sum(df8$gain[1:i])
  df8$forest_left[i] <- df2$count[1] - df8$added_loss[i] + df8$added_gain[i]
}



df8$diff
  
19493089 + 99404 - 54240


corine_18 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/copernicus_data/corine_forest_2018_rasterized.tif")
hansen_10 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/hansen_data/forest_cover_2010/hansen_fc_only_albania_2010.tif")
corine_00 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/copernicus_data/corine_forest_2000_rasterized.tif")
hansen_00 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/hansen_data/forest_cover_2000/hansen_fc_only_albania.tif")

hansen_10 <- resample(hansen_10,hansen_00)

hansen_00[hansen_00 >= 0.5] <- 1
hansen_00[hansen_00 != 1] <- NA
hansen_10[hansen_10 >= 0.5] <- 1
hansen_10[hansen_10 != 1] <- NA


writeRaster(hansen_10, "/Users/clemens/Desktop/hansen_10","GTiff",  overwrite=T)

corine_18 <- crop(corine_18, albania)
corine_18 <- corine_18 * albania
hansen_10 <- crop(hansen_10, albania)
hansen_10 <- hansen_10 * albania
corine_00 <- crop(corine_00, albania)
corine_00 <- corine_00 * albania
hansen_00 <- crop(hansen_00, albania)
hansen_00 <- hansen_00 * albania



freq(corine_18)
freq(corine_00)
freq(hansen_00)
freq(hansen_10)



plot(df8$value, df8$forest_left, type="l", ylim=c(0,df2$count[1]*0.06771299))
lines(df8$value, df8$sum_loss, type="l", col="red")
lines(df8$value, df8$added_loss, type="l", col="blue")
lines(df8$value, df8$added_gain, type="l", col="green")
points(2018, freq(corine_18)[3]*0.06771299, pch=20, col="green")       #corine2018
points(2010, freq(hansen_2010_5)[3]*0.06771299, pch=20, col="black") #hansen 5% 2010
points(2010, freq(hansen_2010_50)[3]*0.06771299, pch=20, col="black") #hansen 50% 2010
points(2000, freq(corine_00)[3]*0.06771299, pch=20, col="green")     ##corine 2000
points(2000, freq(hansen_2000_5)[3]*0.06771299, pch=20, col="black") #hansen 5% 2000
points(2000, freq(hansen_2000_50)[3]*0.06771299, pch=20, col="black") #hansen 50% 2000
points(2022, freq(senf_forest)[5]*0.06771299, pch=20, col="orange") #senf



freq(senf_forest)[4]


freq(senf_forest)




plot(df8$value, df8$added_loss, type="l", col="blue")
lines(df8$value, df8$gain, type="l", col="red")
lines(df8$value, df8$sum_loss, type="l", col="orange")
lines(df8$value, df8$added_gain, type="l", col="green")





(1-(16144671/19162607)) *100


plot(df7$value, df7$sum_added, type="l")


plot(df3[-34,], type = "l")
lines(df4[-25,], type="l", col="red")
lines(df5[-15,], type="l", col= "blue")


plot(df3[-34,], pch=20, ylim=c(0,5000))
points(df4[-25,], pch=20, col="red")
points(df5[-15,], pch=20, col= "green")
















gfw_loss <- read.csv("Desktop/Albania_Thesis/data/hansen_data/GFW_data/Tree cover loss in Albania/treecover_loss__ha.csv")
names(gfw_loss)[2:3] <- c("value", "gfw_loss")

df9 <- left_join(df8,gfw_loss[,2:3])

ggplot(df9) + 
  geom_line(aes(x=value,y=sum_loss),color='red') + 
  geom_line(aes(x=value,y=gfw_loss),color='blue') + 
  geom_line(aes(x=value,y=gain),color='green') + 
  geom_line(aes(x=value,y=h_loss),color='orange') + 
  geom_line(aes(x=value,y=s_loss),color='pink') + 
  ylab('loss [ha]')+xlab('year')




























