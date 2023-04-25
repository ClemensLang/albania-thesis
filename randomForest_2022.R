library(rgdal)
library(raster)
library(randomForest)

#1990 set.seed(4444)
set.seed(3333)

dem <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/create_points/rasters_for_points/DEM_albania_cut_4326.tif")
slope <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/slope.tif")
i2022 <- stack("/Users/clemens/Desktop/Albania_Thesis/not_to_copy/old_landsat_rgb/landsat8_2022.tif")[[1:6]]
ndvi_2022 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/unsorted_old_versions/rasters/2022_ndvi_stats.tif")

plot(ndvi_2022)

raster_raw <- i2022[[1]]

points <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/points_shp/2022_train_data_combined_new.shp")


dem <- crop(dem, extent(i2022))
slope <- crop(slope, extent(i2022))

dem_new <- resample(dem, raster_raw)
slope_new <- resample(slope, raster_raw)

geo_data <- stack(dem_new, slope_new)
writeRaster(geo_data, "/Users/clemens/Desktop/create_points/rasters_for_points/geo_data","GTiff",  overwrite=T)


stack <- stack(dem_new, slope_new, i2021, i2022, ndvi_2022) 


spatial_df <- raster::extract(stack, points, sp=T)
df <- as.data.frame(spatial_df)
str(df)
df$type <- as.factor(df$type)
df[is.na(df)] = 0


ind <- sample(c(TRUE, FALSE), 712, replace=TRUE, prob=c(0.7, 0.3))

set1 <- df[ind,]
set2 <- df[!ind,]





rf <- randomForest(type~., set1[,c(-19,-20)] , ntree=500, importance =T)


imp_1 <- importance(rf, type=1)
imp_2 <- importance(rf, type=2)

importance_2022_rf <- cbind(imp_1,imp_2)



rf2 <- randomForest(type~., set1[,c(-2,-3,-19,-20)] , ntree=500)

predict1 <- predict(stack, rf)
writeRaster(predict1, "/Users/clemens/Desktop/create_points/predicts2022","GTiff",  overwrite=T)



predict2 <- predict(stack[[3:17]], rf2)

spatial_df_val <- raster::extract(predict1, points, sp=T)
df_val <- as.data.frame(spatial_df_val)
df_val$type <- as.factor(df_val$type)
validation_set <- df_val[!ind,]


validation_set[which(validation_set$type != validation_set$layer),]
validation_set$false_clas <- 0
validation_set$false_clas[which(validation_set$type != validation_set$layer)] <- 1

100-100*(nrow(validation_set[which(validation_set$type != validation_set$layer),])/229)


write.csv(validation_set, "/Users/clemens/Desktop/validation_set_2022.csv")




writeRaster(predict1, "/Users/clemens/Desktop/create_points/predicts2","GTiff",  overwrite=T)
writeRaster(predict2, "/Users/clemens/Desktop/create_points/predicts3","GTiff",  overwrite=T)






writeRaster(predict1, "/Users/clemens/Desktop/forest_land_2022_predict_20_04_manual","GTiff",  overwrite=T)


write.csv(importance_2022_rf, "/Users/clemens/Desktop/importance_stats_2022_manual.csv")
write.csv(set1, "/Users/clemens/Desktop/set_train_2022_manual.csv")
write.csv(set2, "/Users/clemens/Desktop/set_valid_2022_manual.csv")
write.csv(validation_set, "/Users/clemens/Desktop/accuracy_2022_manual.csv")





