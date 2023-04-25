library(rgdal)
library(raster)



forest1 <- stack("Desktop/create_points/predicts2.tif")
forest2 <- stack("Desktop/create_points/predicts2_new_26_02.tif")
prob1 <- stack("Desktop/create_points/pred_prob.tif")
prob2 <- stack("Desktop/create_points/pred_prob_new_26_02.tif")

forest1[is.na(forest1)] <- 0
forest2[is.na(forest2)] <- 0


forest2[forest2 == 5] <- 0
forest2[forest2 == 3] <- 1


prob1 <- (prob1-1)*(-1)


forest2[forest2 == 1] <- 5
forest2[forest2 == 0] <- 3

forest1[forest1 == 1] <- 11
forest1[forest1 == 0] <- 7


forest_combined <- forest1*forest2
freq(forest_combined)
forest_combined[forest_combined == 21] <- 0
forest_combined[forest_combined == 33] <- 1
forest_combined[forest_combined == 35] <- 2
forest_combined[forest_combined == 55] <- 3


staX <- stack(forest1, forest2, prob1, prob2)


prob3 <- prob1*prob2




albania_blank <- stack("Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")

plot(albania_blank)
freq(albania_blank)



calc_raster <- albania_blank * forest_combined
freq(calc_raster)


23076608+5278433+268312+13884174


23076608/42507527
13884174/42507527



plot(calc_raster)


plot(prob3)

writeRaster(forest_combined, "/Users/clemens/Desktop/create_points/forest_combined_03_03","GTiff",  overwrite=T)
writeRaster(prob3, "/Users/clemens/Desktop/create_points/prob3_combined","GTiff",  overwrite=T)
