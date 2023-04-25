forest1 <- stack("Desktop/create_points/predicts2022.tif")
forest2 <- stack("Desktop/create_points/predicts_2022_date_10_03.tif")


forest1[is.na(forest1)] <- 0
forest2[is.na(forest2)] <- 0


forest2[forest2 == 5] <- 0
forest2[forest2 == 3] <- 1


forest2[forest2 == 1] <- 5
forest2[forest2 == 0] <- 3

forest1[forest1 == 1] <- 11
forest1[forest1 == 0] <- 7


forest_combined <- forest1*forest2


forest_combined[forest_combined == 21] <- 0
forest_combined[forest_combined == 33] <- 1
forest_combined[forest_combined == 35] <- 2
forest_combined[forest_combined == 55] <- 3


writeRaster(forest_combined, "/Users/clemens/Desktop/create_points/forest_combined_10_03","GTiff",  overwrite=T)





