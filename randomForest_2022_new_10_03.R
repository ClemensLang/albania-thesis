library(rgdal)
library(raster)
library(randomForest)
library(e1071)

set.seed(4444)
corine_18 <- stack("Desktop/Albania_Thesis/data/copernicus_data/corine_forest_2018_rasterized.tif")
hansen <- stack("Desktop/Albania_Thesis/data/hansen_data/forest_cover_2010/hansen_fc_only_albania_2010.tif")
lidar <- stack("Desktop/Albania_Thesis/data/LiDAR/LiDAR_data_albania(2015)_4326.tif")

lidar_new <- resample(lidar,hansen)

lidar_new_copy <- lidar_new
lidar_new <- lidar_new_copy

hansen_new <- hansen
hansen_new[hansen_new >= 0.5] <- 1
hansen_new[hansen_new != 1] <- NA

lidar_new[lidar_new >= 10 ] <- 99
lidar_new[lidar_new <= 5 ] <- 0
lidar_new[lidar_new == 0] <- NA
lidar_new[lidar_new != 99] <- 1
lidar_new[lidar_new == 99 ] <- 2

lidar_new[is.na(lidar_new)] <- 2
lidar_new[lidar_new == 1] <- 3
lidar_new[lidar_new == 2 ] <- 4




plot(corine_18)
plot(lidar_new)


extent(hansen)
extent(corine_18)

corine_new <- resample(corine_18,hansen)


comb <- lidar_new*corine_new*hansen_new
comb[!is.na(comb) ] <- 1

plot(comb)

#writeRaster(comb, "/Users/clemens/Desktop/create_points/comb_2022_1st","GTiff",  overwrite=T)


corine_18_new <- corine_new
corine_18_new[is.na(corine_18_new)] <- 0

hansen_new2 <- hansen_new
hansen_new2[is.na(hansen_new2)] <- 0
hansen_new2[hansen_new2 > 0] <- 1

lidar_new2 <- lidar_new
lidar_new2[is.na(lidar_new2)] <- 0
lidar_new2[lidar_new2 == 2] <- 0
lidar_new2[lidar_new2 > 0] <- 1

comb2 <- lidar_new2+corine_18_new+hansen_new2

plot(comb2)
freq(comb2)

comb2[comb2 > 0] <- 1
comb2 <- (comb2-1)*-1

plot(comb2)


comb[is.na(comb)] <- 0

comb3 <- comb*3+comb2*5

plot(comb3)
freq(comb3)

writeRaster(comb3, "/Users/clemens/Desktop/comb3_2022","GTiff",  overwrite=T)

comb3 <- stack("Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/unsorted_old_versions/comb3_2022.tif")

freq(comb3)
plot(comb3)
set.seed(4444)

sample <- sampleRandom(comb3, size=10000, sp=T)
names(sample) <- "layer"

plot(sample)


sample2 <- sample[sample$layer == 3,]
length(sample2)
sample2 <- sample2[sample(1:length(sample2), 1000, replace=F),]

sample3 <- sample[sample$layer == 0,]
length(sample3)
sample3 <- sample3[sample(1:length(sample3), 1000, replace=F),]

sample_1000 <- rbind(sample2,sample3)
names(sample_1000) <- "type"
length(sample_1000)





dem <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/DEM_albania_cut_4326.tif")
i2022 <- stack("/Users/clemens/Desktop/Albania_Thesis/not_to_copy/old_landsat_rgb/landsat8_2022.tif")[[1:6]]
i2021 <- stack("/Users/clemens/Desktop/Albania_Thesis/not_to_copy/old_landsat_rgb/landsat8_2021.tif")[[1:6]]
ndvi_2022 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/unsorted_old_versions/rasters/2022_ndvi_stats.tif")
slope <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/slope.tif")
raster_raw <- i2022[[1]]




dem <- crop(dem, extent(i2022))
slope <- crop(slope, extent(i2022))

dem_new <- resample(dem, raster_raw)
slope_new <- resample(slope, raster_raw)


stack <- stack(dem_new, slope_new, i2022, i2021, ndvi_2022) 



#writeRaster(stack, "/Users/clemens/Desktop/create_points/stack_2022_date_10_03","GTiff",  overwrite=T)
#stack <- stack("/Users/clemens/Desktop/create_points/stack_2022_date_10_03.tif")

spatial_df <- raster::extract(stack, sample_1000, sp=T)
df <- as.data.frame(spatial_df)
str(df)
df$type <- as.factor(df$type)
df[is.na(df)] = 0




ind <- sample(c(TRUE, FALSE), 2000, replace=TRUE, prob=c(0.7, 0.3))

set1 <- df[ind,]
set2 <- df[!ind,]

str(set1)

rf <- randomForest(type~., set1[,c(-19,-20)] , ntree=500, importance=TRUE)
rf2 <- randomForest(type~., set1[,c(-2,-3,-19,-20)] , ntree=500)


importance(rf, type=1)

varImpPlot(rf)



imp_1 <- importance(rf, type=1)
imp_2 <- importance(rf, type=2)

importance_2022_rf <- cbind(imp_1,imp_2)




predict1 <- predict(stack, rf)
pred.prob <- predict(stack, rf, type="prob")


spatial_df_val <- raster::extract(predict1, sample_1000, sp=T)
df_val <- as.data.frame(spatial_df_val)
df_val$type <- as.factor(df_val$type)
validation_set <- df_val[!ind,]


validation_set[which(validation_set$type != validation_set$layer),]


validation_set$false_clas <- 0
validation_set$false_clas[which(validation_set$type != validation_set$layer)] <- 1

100-100*(nrow(validation_set[which(validation_set$type != validation_set$layer),])/594)


writeRaster(predict1, "/Users/clemens/Desktop/predicts_2022_date_12_03","GTiff",  overwrite=T)



write.csv(validation_set, "/Users/clemens/Desktop/create_points/validation_set_new_2022_date_10_03.csv")

writeRaster(pred.prob, "/Users/clemens/Desktop/create_points/pred_prob_new_26_02","GTiff",  overwrite=T)

writeRaster(predict1, "/Users/clemens/Desktop/create_points/predicts_2022_date_10_03","GTiff",  overwrite=T)

writeRaster(raster_raw, "/Users/clemens/Desktop/beach/beach_full_alb_raw","GTiff",  overwrite=T)











writeRaster(predict1, "/Users/clemens/Desktop/forest_land_2022_predict_20_04","GTiff",  overwrite=T)


write.csv(importance_2022_rf, "/Users/clemens/Desktop/importance_stats_2022.csv")
write.csv(set1, "/Users/clemens/Desktop/set_train_2022.csv")
write.csv(set2, "/Users/clemens/Desktop/set_valid_2022.csv")
write.csv(validation_set, "/Users/clemens/Desktop/accuracy_2022.csv")





