beach_area_burn <- stack("Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/beach/beach_full_alb_raw.tif")



plot(beach_area_burn)



beach_area_burn[beach_area_burn != 999999] <- 0
beach_area_burn[beach_area_burn != 0] <- 1
beach_area_burn[beach_area_burn == 0] <- NA


beach_area_burn <- trim(beach_area_burn)


plot(beach_area_burn)




writeRaster(beach_area_burn, "/Users/clemens/Desktop/beach/beach_only_raw","GTiff",  overwrite=T)


beach_burn_clip <- beach_area_burn

beach_burn_clip <- stack("Desktop/beach/beach_only_raw_clipped.tif")
plot(beach_burn_clip)


r1990 <- stack(i1989, i1990, ndvi_1990)
r1990 <- crop(r1990, extent(beach_burn_clip))

r2022 <- stack(i2022, i2021, ndvi_2022)
r2022 <- crop(r2022, extent(beach_burn_clip))


copy_r1990 <- r1990
r1990 <- copy_r1990
for (i in c(1:15)) {
  r1990[[i]] <- r1990[[i]]  * beach_burn_clip
}


copy_r2022 <- r2022
r2022 <- copy_r2022
for (i in c(1:15)) {
  r2022[[i]] <- r2022[[i]]  * beach_burn_clip
}



writeRaster(r1990, "/Users/clemens/Desktop/beach/beach_area_landsat_1989_90_ndvi_clip","GTiff",  overwrite=T)
writeRaster(r2022, "/Users/clemens/Desktop/beach/beach_area_landsat_2022_ndvi_clip","GTiff",  overwrite=T)



plot(r1990[[15]])
plot(r2022[[9]])



### random forest

r1990 <- stack("Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/beach/beach_area_landsat_1989_90_ndvi_clip.tif")
r2022 <- stack("Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/beach/beach_area_landsat_2022_ndvi_clip.tif")


points <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/beach/beach_area_tp_data.shp")
points <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/beach/beach_area_tp_data_2022.shp")


plot(spatial_df)

spatial_df <- raster::extract(r1990, points, sp=T)
df <- as.data.frame(spatial_df)
str(df)
df$type <- as.factor(df$id)
df[is.na(df)] = 0

spatial_df <- raster::extract(r2022, points, sp=T)
df <- as.data.frame(spatial_df)
str(df)
df$type <- as.factor(df$id)
df[is.na(df)] = 0


ind <- sample(c(TRUE, FALSE), 256, replace=TRUE, prob=c(0.7, 0.3))
ind <- sample(c(TRUE, FALSE), 341, replace=TRUE, prob=c(0.7, 0.3))

set1 <- df[ind,]
set2 <- df[!ind,]

str(set1)



rf <- randomForest(type~., set1[,c(-1,-17,-18)] , ntree=500, importance=TRUE)
rf <- randomForest(type~., set1[,c(-1,-11,-12)] , ntree=500, importance=TRUE)


imp_1 <- importance(rf, type=1)
imp_2 <- importance(rf, type=2)

importance_1990_rf <- cbind(imp_1,imp_2)



predict1 <- predict(r1990, rf)
predict1 <- predict(r2022, rf)

plot(predict1)


spatial_df_val <- raster::extract(predict1, points, sp=T)
df_val <- as.data.frame(spatial_df_val)
df_val$type <- as.factor(df_val$id)
validation_set <- df_val[!ind,]


validation_set[which(validation_set$type != validation_set$layer),]

validation_set$false_clas <- 0
validation_set$false_clas[which(validation_set$type != validation_set$layer)] <- 1

100-100*(nrow(validation_set[which(validation_set$type != validation_set$layer),])/77)
100-100*(nrow(validation_set[which(validation_set$type != validation_set$layer),])/99)


writeRaster(predict1, "/Users/clemens/Desktop/beach/beach_forests_1990_prediction","GTiff",  overwrite=T)
writeRaster(predict1, "/Users/clemens/Desktop/beach_forests_2022_prediction","GTiff",  overwrite=T)


writeRaster(predict1, "/Users/clemens/Desktop/forest_land_predict_20_04_manual","GTiff",  overwrite=T)


write.csv(importance_1990_rf, "/Users/clemens/Desktop/importance_stats_beach_1990.csv")
write.csv(set1, "/Users/clemens/Desktop/set_train_1990_beach.csv")
write.csv(set2, "/Users/clemens/Desktop/set_valid_1990_beach.csv")
write.csv(validation_set, "/Users/clemens/Desktop/accuracy_1990_beach.csv")


write.csv(importance_2022_rf, "/Users/clemens/Desktop/importance_stats_beach_2022.csv")
write.csv(set1, "/Users/clemens/Desktop/set_train_2022_beach.csv")
write.csv(set2, "/Users/clemens/Desktop/set_valid_2022_beach.csv")
write.csv(validation_set, "/Users/clemens/Desktop/accuracy_2022_beach.csv")




