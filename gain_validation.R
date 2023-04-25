library(rgdal)
library(raster)



albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")
alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)
albania <- crop(albania_raw, alb_ext)
albania[albania == 0] <- NA
plot(albania)


loss <- stack("/Users/clemens/Desktop/Albania_Thesis/data/01_final_results_rasters/detect_alb_(12_03).tif")
gain <- stack("/Users/clemens/Desktop/sep_ind_alb_gain_(12_03).tif")[[1]]


loss1 <- loss[[1]] #latest disturbance
loss2 <- loss[[3]] #first disturbance


plot(gain)

valid <- albania
valid[!is.na(valid)] <- 0
valid[!is.na(gain)] <- 1 #gain but unknown if disturbance before 1990
freq(valid)
valid[gain == loss1] <- 7 #gain year = latest disturbance
freq(valid)
valid[gain == loss2] <- 8 #gain year = first disturbance
freq(valid)
valid[gain < loss1] <- 2 #gain before latest disturbance
freq(valid)
valid[gain < loss2] <- 3 #gain before first disturbance                 !!!
freq(valid)
valid[gain > loss2] <- 4 #gain after first disturbance
freq(valid)
valid[gain > loss1] <- 5 #gain after latest disturbance                 !!!
freq(valid)
valid[(gain < loss1) & (gain > loss2)] <- 6 #gain between disturbances  !!!

valid[valid == 2] <- NA
valid[valid == 4] <- NA
valid[valid == 8] <- NA
valid[valid == 3] <- 2
valid[valid == 5] <- 3
valid[valid == 6] <- 4


valid[valid == 0] <- NA

valid <- valid[[4]]

validt1 <- valid
validt1[!is.na(validt1)] <- 1
gain<- gain*validt1



valid <- stack(gain, valid)
writeRaster(valid, "/Users/clemens/Desktop/valid_gain","GTiff",  overwrite=T)

valid <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/valid_gain.tif")
gain_between1 <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/gain_between.tif")

gain_between <- valid[[2]]



gain_between[gain_between < 3] <- NA

gain_between[!is.na(gain_between)] <- 1


plot(loss2)
plot(gain_between)


freq(valid[[1]] - loss2)

gain_between <- gain_between*(valid[[1]] - loss1)

freq(gain_between)


writeRaster(gain_between, "/Users/clemens/Desktop/Albania_Thesis/data/01_final_results_rasters/gain_between","GTiff",  overwrite=T)



gain_between[[1]] == gain_between1[[1]]







442800+26045+720188+60559


