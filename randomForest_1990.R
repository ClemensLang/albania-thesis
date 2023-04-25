library(rgdal)
library(raster)
library(randomForest)
library(e1071)

set.seed(4444)

dem <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/DEM_albania_cut_4326.tif")
i1989 <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/moasic_1989_06_09.tif")[[1:6]]
i1990 <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/moasic_1990_06_09.tif")[[1:6]]
ndvi_1990 <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/NDVI_stats_1990.tif")
slope <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/slope.tif")
raster_raw <- i1989[[1]]

points <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/points_shp/1990_train_data_combined_new.shp")


dem <- crop(dem, extent(i1989))
slope <- crop(slope, extent(i1989))

dem_new <- resample(dem, raster_raw)
slope_new <- resample(slope, raster_raw)

geo_data <- stack(dem_new, slope_new)
writeRaster(geo_data, "/Users/clemens/Desktop/create_points/rasters_for_points/geo_data","GTiff",  overwrite=T)



stack <- stack(dem_new, slope_new, i1989, i1990, ndvi_1990) 


spatial_df <- raster::extract(stack, points, sp=T)
df <- as.data.frame(spatial_df)
str(df)
df$type <- as.factor(df$type)
df[is.na(df)] = 0


ind <- sample(c(TRUE, FALSE), 712, replace=TRUE, prob=c(0.7, 0.3))

set1 <- df[ind,]
set2 <- df[!ind,]





rf <- randomForest(type~., set1[,c(-19,-20)] , ntree=500, importance=TRUE)
rf2 <- randomForest(type~., set1[,c(-2,-3,-19,-20)] , ntree=500)


importance(rf, type=1)

imp_1 <- importance(rf, type=1)
imp_2 <- importance(rf, type=2)

importance_1990_rf <- cbind(imp_1,imp_2)


varImpPlot(rf)



predict1 <- predict(stack, rf)
pred.prob <- predict(stack, rf, type="prob")

predict2 <- predict(stack[[3:17]], rf2)

spatial_df_val <- raster::extract(predict1, points, sp=T)
df_val <- as.data.frame(spatial_df_val)
df_val$type <- as.factor(df_val$type)
validation_set <- df_val[!ind,]


validation_set[which(validation_set$type != validation_set$layer),]

validation_set$false_clas <- 0
validation_set$false_clas[which(validation_set$type != validation_set$layer)] <- 1

100-100*(nrow(validation_set[which(validation_set$type != validation_set$layer),])/211)


write.csv(validation_set, "validation_set.csv")


writeRaster(pred.prob, "/Users/clemens/Desktop/create_points/pred_prob","GTiff",  overwrite=T)



writeRaster(predict1, "/Users/clemens/Desktop/create_points/predicts2","GTiff",  overwrite=T)
writeRaster(predict2, "/Users/clemens/Desktop/create_points/predicts3","GTiff",  overwrite=T)

writeRaster(predict1, "/Users/clemens/Desktop/forest_land_predict_20_04_manual","GTiff",  overwrite=T)


write.csv(importance_1990_rf, "/Users/clemens/Desktop/importance_stats_1990_manual.csv")
write.csv(set1, "/Users/clemens/Desktop/set_train_1990_manual.csv")
write.csv(set2, "/Users/clemens/Desktop/set_valid_1990_manual.csv")
write.csv(validation_set, "/Users/clemens/Desktop/accuracy_1990_manual.csv")




