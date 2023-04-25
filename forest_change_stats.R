library(rgdal)
library(raster)
library(terra)
library(dplyr)
library(ggplot2)
library(tidyr)
library(rgdal)

albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")
alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)
albania <- crop(albania_raw, alb_ext)

plot(albania_raw)

plot(albania)


#####  dem cat ####
dem <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/DEM_albania_cut_4326.tif")




dem <- crop(dem, albania)
dem <- resample(dem, albania)
dem <- dem*albania

plot(dem)

dem_cat <- dem
dem_cat[dem_cat < 50] <- 3000
dem_cat[dem_cat < 150] <- 3001
dem_cat[dem_cat < 500] <- 3002
dem_cat[dem_cat < 1000] <- 3003
dem_cat[dem_cat < 1500] <- 3004
dem_cat[dem_cat < 2000] <- 3005

plot(dem_cat)

dem_cat[dem_cat == 3000] <- 1
dem_cat[dem_cat == 3001] <- 2
dem_cat[dem_cat == 3002] <- 3
dem_cat[dem_cat == 3003] <- 4
dem_cat[dem_cat == 3004] <- 5
dem_cat[dem_cat == 3005] <- 6
dem_cat[dem_cat > 7] <- 7



writeRaster(dem_cat, "/Users/clemens/Desktop/dem_cat","GTiff",  overwrite=T)
dem <- stack("Desktop/dem_cat.tif")
dem <- dem_cat




#### stats #####


national_parks <- stack(stack("/Users/clemens/Desktop/national_parks_raster.tif"),stack("/Users/clemens/Desktop/national_parks_raster_year.tif"))
national_parks[[1]][national_parks[[1]] == 1] <- NA
national_parks[[2]][national_parks[[2]] == 1] <- NA
national_parks <- crop(national_parks, albania)


plot(national_parks[[2]])


forest_loss <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/detect_alb_(12_03).tif")


forest_parks <- national_parks[[2]]-forest_loss
forest_parks2 <- forest_parks
forest_parks2[!is.na(forest_parks2)] <- 1
forest_parks2 <- forest_parks2*forest_loss


forest_parks <- stack(forest_parks,forest_parks2)


plot(forest_parks2)
freq(forest_parks[[2]])


national_park_area <- as.data.frame(freq(national_parks[[2]]))
national_park_area[,2] <- national_park_area[,2]*0.06771299
national_park_area[3,2] <- sum(national_park_area[1:3,2])
national_park_area <- national_park_area[-c(1,2),]


protected_forest_area <- national_parks[[2]]
protected_forest_area[!is.na(protected_forest_area)] <- 1
protected_forest_area <- protected_forest_area*forest_90[[2]]
protected_forest_area <- protected_forest_area*national_parks[[2]]

plot(protected_forest_area)

protected_forest_area_df <- as.data.frame(freq(protected_forest_area))
protected_forest_area_df[,2] <- protected_forest_area_df[,2]*0.06771299



plot(forest_parks[[2]])

patch <- patches(rast(forest_parks[[2]]))
plot(patch)



plot(dem==2)
freq(dem==2)




writeRaster(forest_parks, "/Users/clemens/Desktop/forest_parks","GTiff",  overwrite=T)




before <- forest_parks[[1]]
before[before < 0] <- NA
before[!is.na(before)] <- 1
before <- before * forest_parks[[2]]

plot(before)

after <- forest_parks[[1]]
after[after >= 0] <- NA
after[!is.na(after)] <- 1
after <- after * forest_parks[[2]]



df1 <- as.data.frame(freq(national_parks[[2]]))
df2 <- as.data.frame(freq(forest_parks[[2]]))
df3 <- as.data.frame(freq(before))
df4 <- as.data.frame(freq(after))

names(df3) <- c("year", "before")
names(df4) <- c("year", "after")

before_after_national <- left_join(df4,df3)
before_after_national[,-1] <- before_after_national[,-1]*0.06771299

national_berfore_after <- before_after_national %>% 
  pivot_longer(
    cols = `after`:`before`, 
    names_to = "category",
    values_to = "value"
  )



ggplot(data=national_berfore_after, aes(x=year, y=value, fill=category)) +
  geom_bar(stat="identity")






barplot(df1)




ggplot(df1[-18,], aes(value, count)) + 
  geom_bar(stat="identity", position="dodge") 
  #scale_x_continuous(breaks=1990:2022)

ggplot(df2[-34,], aes(value, count)) + 
  geom_bar(stat="identity", position="dodge") +
  scale_x_continuous(breaks=1990:2022)


ggplot(df3[-30,], aes(value, count)) + 
  geom_bar(stat="identity", position="dodge") +
  scale_x_continuous(breaks=1990:2022)


ggplot(df4[-34,], aes(value, count)) + 
  geom_bar(stat="identity", position="dodge") +
  scale_x_continuous(breaks=1990:2022)






forest_loss2 <- forest_loss 
forest_loss2[!is.na(forest_loss2)] <- 1

dem_loss <- dem*forest_loss2

plot(dem_loss)


df5 <- as.data.frame(freq(dem_loss))
ggplot(df5[-8,], aes(value, count)) + 
  geom_bar(stat="identity", position="dodge") +
  scale_x_continuous(breaks=1:7)





forest_90 <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/forest_albania_90_22_new.tif")

dem_90 <- dem*forest_90[[1]]


df6 <- as.data.frame(freq(dem_90))
ggplot(df6[-8,], aes(value, count)) + 
  geom_bar(stat="identity", position="dodge") +
  scale_x_continuous(breaks=1:7)



df7 <- as.data.frame(freq(dem))
ggplot(df7[-8,], aes(value, count)) + 
  geom_bar(stat="identity", position="dodge") +
  scale_x_continuous(breaks=1:7)


df6[-8,]*0.06771299


df7[-8,]*0.06771299









forest_loss1 <- forest_loss[[3]]
forest_loss2 <- forest_loss[[4]] 
forest_loss3 <- forest_loss[[5]] 
forest_loss1[!is.na(forest_loss1)] <- 1
forest_loss1[forest_loss1!= 1] <- NA
forest_loss2[!is.na(forest_loss2)] <- 1
forest_loss2[forest_loss2!= 1] <- NA
forest_loss3[!is.na(forest_loss3)] <- 1
forest_loss3[forest_loss3!= 1] <- NA

dem_loss1 <- dem*forest_loss1
dem_loss2 <- dem*forest_loss2
dem_loss3 <- dem*forest_loss3

as.data.frame(freq(dem_loss1))*0.06771299
as.data.frame(freq(dem_loss2))*0.06771299
as.data.frame(freq(dem_loss3))*0.06771299



forest_loss4 <- forest_loss[[1]] 
forest_loss4[!is.na(forest_loss4)] <- 1
forest_loss4[forest_loss4!= 1] <- NA
dem_loss4 <- dem*forest_loss4
as.data.frame(freq(dem_loss4))*0.06771299






dem_22 <- dem*forest_90[[2]]
as.data.frame(freq(dem_22))*0.06771299



for (i in c(1:7)){
  tmp_dem <- dem
  tmp_dem[tmp_dem != i] <- NA
  tmp_dem[!is.na(tmp_dem)] <- 1
  tmp_dem1 <- tmp_dem*forest_loss[[3]]
  tmp_dem2 <- tmp_dem*forest_loss[[4]]
  tmp_dem3 <- tmp_dem*forest_loss[[5]]
  
  tmp_df <- as.data.frame(freq(tmp_dem1))
  tmp_df2 <- as.data.frame(freq(tmp_dem2))
  tmp_df3 <- as.data.frame(freq(tmp_dem3))
  tmp_df[,2] <- tmp_df[,2]*0.06771299
  tmp_df2[,2] <- tmp_df2[,2]*0.06771299
  tmp_df3[,2] <- tmp_df3[,2]*0.06771299
  names(tmp_df2) <- c("value","count2")
  names(tmp_df3) <- c("value","count3")
  
  tmp_comb <- left_join(tmp_df,left_join(tmp_df2,tmp_df3))
  tmp_comb[is.na(tmp_comb)] <- 0
  tmp_comb[,5] <- rowSums((tmp_comb[,2:4]))
  tmp_comb <- tmp_comb[,c(1,5)]
  names(tmp_comb) <- c("value", paste0("V",(as.name(i))))
  year_dem <- left_join(year_dem, tmp_comb)
  print(year_dem)
}

year_dem <- year_dem[,1:2]

options("scipen"=100, "digits"=4)



year_dem1 <- year_dem

year_dem <- year_dem[-34,-2]
year_dem[is.na(year_dem)] <- 0
names(year_dem) <- c("year","V1","V2", "V3", "V4", "V5", "V6" , "V7")




dem_year <- year_dem %>% 
  pivot_longer(
    cols = `V1`:`V7`, 
    names_to = "height_cat",
    values_to = "value"
  )


ggplot(data=dem_year, aes(x=year, y=value, fill=height_cat)) +
  geom_bar(stat="identity")



write.csv(year_dem, "Desktop/year_dem.csv")

perc_year_dem <- read.csv("Desktop/year_dem_perc.csv")[,-1]


perc_dem_year <- perc_year_dem %>% 
  pivot_longer(
    cols = `V1`:`V7`, 
    names_to = "height_cat",
    values_to = "value"
  )


ggplot(data=perc_dem_year, aes(x=year, y=value, fill=height_cat)) +
  geom_bar(stat="identity")



boxplot(perc_year_dem[,3])





df_loss1 <- as.data.frame(freq(forest_loss[[1]]))
df_loss1[,2] <- df_loss1[,2]*0.06771299










fire <- stack("/Users/clemens/Desktop/Albania_Thesis/data/01_final_results_rasters/fire_raster.tif")
fire[fire == 4] <- 2
plot(fire)
freq(fire)


fire.prob <- stack("Desktop/predicts.prob2_fire_06_04.tif")
plot(fire.prob)

fire75 <- fire.prob
fire75[fire.prob <= .25] <- 1
fire75[fire75 != 1] <- NA
writeRaster(fire75, "/Users/clemens/Desktop/fire75","GTiff",  overwrite=T)
fire75 <- fire75*forest_loss[[1]]
#freq(fire75)

fire25 <- fire.prob
fire25[fire.prob >= .75] <- 1
fire25[fire25 != 1] <- NA
writeRaster(fire25, "/Users/clemens/Desktop/fire25","GTiff",  overwrite=T)
fire25 <- fire25*forest_loss[[1]]
#freq(fire25)





fire2575 <- fire.prob
fire2575[fire.prob < .75 & fire.prob > .25] <- 1
fire2575[fire2575 != 1] <- NA
fire2575 <- fire2575*forest_loss[[1]]
#freq(fire2575)

#freq(fire25)

#fire.prob.all <- fire.prob
#fire.prob.all[fire.prob.all >= .75] <- 2
#fire.prob.all[fire.prob.all <= .25] <- 1
#fire.prob.all[fire.prob.all != 2 & fire.prob.all != 1] <- 0

#as.data.frame(freq(fire.prob.all))*0.06771299
#as.data.frame(freq(forest_loss[[1]]))
#plot(fire25)


fire1 <- fire
fire1[fire1 != 2] <-NA
fire1[!is.na(fire1)] <- 1
fire1 <- fire1*forest_loss[[1]]
#freq(fire1)

#as.data.frame(freq(fire))#*0.06771299

fire.no <- fire
fire.no[fire.no != 1] <-NA
fire.no[!is.na(fire.no)] <- 1
fire.no <- fire.no*forest_loss[[1]]
#freq(fire.no)


fire1.df <- as.data.frame(freq(fire1))
names(fire1.df)[2] <- "fire"
#fire1.df[,2] <- fire1.df[,2]*0.06771299

fire.no.df <- as.data.frame(freq(fire.no))
names(fire.no.df)[2] <- "no.fire"
#fire.no.df[,2] <- fire.no.df[,2]*0.06771299


fire75.df <- as.data.frame(freq(fire75))
names(fire75.df)[2] <- "fire.75"
#fire75.df[,2] <- fire75.df[,2]*0.06771299

fire25.df <- as.data.frame(freq(fire25))
names(fire25.df)[2] <- "no.fire.75"
#fire25.df[,2] <- fire25.df[,2]*0.06771299


fire_stats1 <- left_join(fire1.df, left_join(fire.no.df, left_join(fire75.df, fire25.df)))
fire_stats2 <- fire_stats1
fire_stats2$fire <- fire_stats2$fire - fire_stats2$fire.75
fire_stats2$no.fire <- fire_stats2$no.fire - fire_stats2$no.fire.75
fire_stats2[,2:5] <- fire_stats2[,2:5]*0.06771299

fire_stats <- read.csv("Desktop/fire_stats.csv")[,-c(6,7)]
fire_stats$no.fire.75 <- fire25.df$count[-34]

names(fire_stats)[1] <- "year"
names(fire_stats2)[1] <- "year"

stats_fire <- fire_stats2 %>% 
  pivot_longer(
    cols = `fire`:`no.fire.75`, 
    names_to = "category",
    values_to = "value"
  )


ggplot(data=stats_fire, aes(x=year, y=value, fill=category)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#ff4d4d", "#cc0000", "#4d4dff", "#0000cc"))


fire_stats3 <- fire_stats1[,-c(4,5)]
fire_stats3[,2:3] <- fire_stats3[,2:3]*0.06771299
names(fire_stats3)[1] <- "year"

stats_fire2 <- fire_stats3 %>% 
  pivot_longer(
    cols = `fire`:`no.fire`, 
    names_to = "category",
    values_to = "value"
  )


ggplot(data=stats_fire2, aes(x=year, y=value, fill=category)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#ff4d4d", "#4d4dff"))




fire_stats_new <- read.csv("Desktop/fire_stats.csv")

boxplot(fire_stats_new[,3])
boxplot(fire_stats3[-34,2])
boxplot(fire_stats3[-34,3])


median(fire_stats3[-34,2])+IQR(fire_stats3[-34,2])*1.5
IQR(fire_stats3[-34,2])*1.5






loss_stats1 <- as.data.frame(freq(forest_loss[[3]]))
loss_stats2 <- as.data.frame(freq(forest_loss[[4]]))
loss_stats3 <- as.data.frame(freq(forest_loss[[5]]))


names(loss_stats1) <- c("year","loss1")
names(loss_stats2) <- c("year","loss2")
names(loss_stats3) <- c("year","loss3")


loss_stats <- left_join(loss_stats1, left_join(loss_stats2, loss_stats3))
loss_stats[,2:4] <- loss_stats[,2:4]*0.06771299
loss_stats[is.na(loss_stats)] = 0
loss_stats <- loss_stats[-34,]
loss_stats[,2:4] <- loss_stats[,4:2]


stats_loss <- loss_stats %>% 
  pivot_longer(
    cols = `loss3`:`loss1`, 
    names_to = "loss",
    values_to = "value"
  )

ggplot(data=stats_loss, aes(x=year, y=value, fill=loss)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#ff4d4d", "#00e600",  "#4d4dff"))








gain <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/valid_gain.tif")


gain.df <- as.data.frame((freq(gain[[1]])))
names(gain.df) <- c("year","gain")
gain.df <- gain.df[-31,]
loss_stats <- left_join(loss_stats,gain.df)
loss_stats[,2:5] <- loss_stats[,2:5]*0.06771299
loss_stats <- loss_stats[-34,]
loss_stats[,2:5] <- loss_stats[,5:2]

freq(gain)


gain.df[,2] <- gain.df[,2]*0.06771299


stats_loss <- loss_stats %>% 
  pivot_longer(
    cols = `loss1`:`gain`, 
    names_to = "type",
    values_to = "value"
  )

ggplot(data=stats_loss, aes(x=year, y=value, fill=type)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values=c("#ff4d4d", "#00e600",  "#4d4dff", "#ffff00"))













for (i in c(1:7)){
  tmp_dem <- dem
  tmp_dem[tmp_dem != i] <- NA
  tmp_dem[!is.na(tmp_dem)] <- 1
  tmp_dem1 <- tmp_dem*gain[[1]]
  
  tmp_df <- as.data.frame(freq(tmp_dem1))

  tmp_df[,2] <- tmp_df[,2]*0.06771299

  tmp_df[is.na(tmp_df)] <- 0

  names(tmp_df) <- c("year", paste0("V",(as.name(i))))
  year_dem <- left_join(year_dem, tmp_df)
  print(year_dem)
}




year_dem <- loss_stats[,1:2]
year_dem$loss1 <- 0







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



boxplot(perc_year_dem[,8])






districts <- stack("Desktop/districts_raster.tif")
districts[districts == 1] <- NA

districts <- crop(districts, albania)
districts <- districts*albania

for (i in c(2:13)){
  tmp_dem <- districts
  tmp_dem[tmp_dem != i] <- NA
  tmp_dem[!is.na(tmp_dem)] <- 1
  tmp_dem1 <- tmp_dem*forest_loss[[3]]
  tmp_dem2 <- tmp_dem*forest_loss[[4]]
  tmp_dem3 <- tmp_dem*forest_loss[[5]]
  
  tmp_df <- as.data.frame(freq(tmp_dem1))
  tmp_df2 <- as.data.frame(freq(tmp_dem2))
  tmp_df3 <- as.data.frame(freq(tmp_dem3))
  tmp_df[,2] <- tmp_df[,2]*0.06771299
  tmp_df2[,2] <- tmp_df2[,2]*0.06771299
  tmp_df3[,2] <- tmp_df3[,2]*0.06771299
  names(tmp_df) <- c("year","count1")
  names(tmp_df2) <- c("year","count2")
  names(tmp_df3) <- c("year","count3")
  
  tmp_comb <- left_join(tmp_df,left_join(tmp_df2,tmp_df3))
  tmp_comb[is.na(tmp_comb)] <- 0
  tmp_comb[,5] <- rowSums((tmp_comb[,2:4]))
  tmp_comb <- tmp_comb[,c(1,5)]
  names(tmp_comb) <- c("year", paste0("C",(as.name(i))))
  year_dem <- left_join(year_dem, tmp_comb)
  print(year_dem)
}



year_dem <- year_dem[,1:2]



districts_90 <- districts*forest_90[[1]]
plot(districts_90)
districts_90 <- as.data.frame(freq(districts_90))
districts_90[,2] <- districts_90[,2]*0.06771299


districts_22 <- districts*forest_90[[2]]
plot(districts_22)
districts_22 <- as.data.frame(freq(districts_22))
districts_22[,2] <- districts_22[,2]*0.06771299



boxplot(c(0.272440436,	0.167538316,	0.260400333,	0.253120584	,0.237747116,
          0.149294791,	0.252264956, 0.211673267	,0.171776543,	0.247060941,
          0.100848725,	0.191599821))



for (i in c(2:13)){
  tmp_dem <- districts
  tmp_dem[tmp_dem != i] <- NA
  tmp_dem[!is.na(tmp_dem)] <- 1
  tmp_dem1 <- tmp_dem*gain[[1]]
  
  tmp_df <- as.data.frame(freq(tmp_dem1))
  
  tmp_df[,2] <- tmp_df[,2]*0.06771299
  
  tmp_df[is.na(tmp_df)] <- 0
  
  names(tmp_df) <- c("year", paste0("V",(as.name(i))))
  year_dem <- left_join(year_dem, tmp_df)
  print(year_dem)
}


year_dem <- year_dem[,1:2]






fo_loss_cat <- forest_loss




loss_gain1 <- gain[[2]]
loss_gain1[loss_gain1 != 4] <- NA
loss_gain1[!is.na(loss_gain1)] <- 1
loss_gain1 <- loss_gain1*forest_loss[[1]]
loss_gain1[!is.na(loss_gain1)] <- 3
loss_gain1[is.na(loss_gain1)] <- 1

loss_gain2 <- gain[[2]]
loss_gain2[loss_gain2 != 3] <- NA
loss_gain2[!is.na(loss_gain2)] <- 1
loss_gain2 <- loss_gain2*forest_loss[[1]]
loss_gain2[!is.na(loss_gain2)] <- 5
loss_gain2[is.na(loss_gain2)] <- 1


loss_gain3 <- forest_loss[[1]]
loss_gain3[!is.na(loss_gain3)] <- 1
loss_gain3[!is.na(loss_gain3)] <- 7
loss_gain3[is.na(loss_gain3)] <- 1


loss_gain5 <- forest_90[[2]]
loss_gain5[!is.na(loss_gain5)] <- 1
loss_gain5 <- loss_gain5*forest_loss[[1]]
loss_gain5[!is.na(loss_gain5)] <- 11
loss_gain5[is.na(loss_gain5)] <- 1


plot(loss_gain5)


loss_gain4 <- loss_gain1*loss_gain2*loss_gain3*loss_gain5

writeRaster(loss_gain4, "/Users/clemens/Desktop/loss_gain_categories","GTiff",  overwrite=T)



loss_gain4 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/stats/rasters/loss_gain_categories.tif")

loss_gain4[loss_gain4 == 1] <- NA
loss_gain4[loss_gain4 == 7] <- 1
loss_gain4[loss_gain4 == 21] <- 2
loss_gain4[loss_gain4 == 35] <- 2
loss_gain4[loss_gain4 == 77] <- 3
loss_gain4[loss_gain4 == 385] <- 4
loss_gain4[loss_gain4 == 231] <- 4



library(viridis)
loss_gain4[loss_gain4 == 1] <- NA
freq(loss_gain4)1
plot(loss_gain4, col=viridis(10))


plot(loss_gain1)
plot(loss_gain2)
plot(loss_gain3)









for (i in c(1:4)){
  tmp_dem <- loss_gain4
  tmp_dem[tmp_dem != i] <- NA
  tmp_dem[!is.na(tmp_dem)] <- 1
  tmp_dem1 <- tmp_dem*forest_loss[[1]]
  
  tmp_df <- as.data.frame(freq(tmp_dem1))
  
  tmp_df[,2] <- tmp_df[,2]*0.06771299
  
  tmp_df[is.na(tmp_df)] <- 0
  
  names(tmp_df) <- c("year", paste0("V",(as.name(i))))
  year_dem <- left_join(year_dem, tmp_df)
  print(year_dem)
}

year_dem <- as.data.frame(freq(forest_loss[[1]]))
names(year_dem)[1] <- "year"
year_dem <- year_dem[-34,]
year_dem$count <- 0
names(year_dem)[2] <- "y"

year_dem[is.na(year_dem)] <- 0
year_dem <- year_dem[,-2]


year_loss_gain <- year_dem

loss_gain_year <- year_loss_gain %>% 
  pivot_longer(
    cols = `V1`:`V4`, 
    names_to = "cat",
    values_to = "value"
  )


ggplot(data=loss_gain_year, aes(x=year, y=value, fill=cat)) +
  geom_bar(stat="identity")






def_loss <- loss_gain4

def_loss[def_loss > 2] <- NA



writeRaster(def_loss, "/Users/clemens/Desktop/def_loss_cat12","GTiff",  overwrite=T)

corine18 <- stack("Desktop/def_loss.tif")
loss_mask18 <- forest_loss[[1]]


loss_mask18[loss_mask18 > 2018] <- NA
loss_mask18[!is.na(loss_mask18)] <- 1


def_loss[!is.na(def_loss)] <- 1


loss_corine <- def_loss*corine18*loss_mask18

plot(loss_corine)
freq(loss_corine)


loss_corine_df <- as.data.frame(freq(loss_corine))
loss_corine_df[,2] <- loss_corine_df[,2]*0.06771299


sum(loss_corine_df$count[1:39])




senf <- stack("Desktop/Albania_Thesis/data/senf_data/senf_stack_albania.tif")[[1]]

plot(senf)
senf_df <- as.data.frame(freq(senf))
senf_df[,2] <- senf_df[,2]*0.06771299











