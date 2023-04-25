library(rgdal)
library(raster)
library(sp)
library(randomForest)
library(e1071)

corine_18 <- stack("Desktop/Albania_Thesis/data/copernicus_data/corine_forest_2018_rasterized.tif")
corine_00 <- stack("Desktop/Albania_Thesis/data/copernicus_data/corine_forest_2000_rasterized.tif")


hansen <- stack("Desktop/Albania_Thesis/data/hansen_data/forest_cover_2000/hansen_fc_only_albania.tif")

extent(hansen)
extent(corine_00)

hansen_new <- hansen
hansen_new[hansen_new >= 0.5] <- 1
hansen_new[hansen_new != 1] <- NA


plot(hansen_new)

comb <- corine_00*corine_18*hansen_new

plot(comb)

corine_00_new <- corine_00
corine_00_new[is.na(corine_00_new)] <- 0

corine_18_new <- corine_18
corine_18_new[is.na(corine_18_new)] <- 0

hansen_new2 <- hansen
hansen_new2[is.na(hansen_new2)] <- 0
hansen_new2[hansen_new2 > 0] <- 1

comb2 <- corine_00_new+corine_18_new+hansen_new2

plot(comb2)
freq(comb2)

comb2[comb2 > 0] <- 1
comb2 <- (comb2-1)*-1

plot(comb2)


comb[is.na(comb)] <- 0

comb3 <- comb*3+comb2*5

plot(comb3)
freq(comb3)

writeRaster(comb3, "/Users/clemens/Desktop/comb3","GTiff",  overwrite=T)

comb3 <- stack("Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/unsorted_old_versions/comb3.tif")

set.seed(4444)

sample <- sampleRandom(comb3, size=10000, sp=T)

plot(sample)


sample2 <- sample[sample$comb3 == 3,]
length(sample2)
sample2 <- sample2[sample(1:length(sample2), 1000, replace=F),]

sample3 <- sample[sample$comb3 == 5,]
length(sample3)
sample3 <- sample3[sample(1:length(sample3), 1000, replace=F),]

sample_1000 <- rbind(sample2,sample3)
names(sample_1000) <- "type"
length(sample_1000)





dem <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/DEM_albania_cut_4326.tif")
i1989 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/moasic_1989_06_09.tif")[[1:6]]
i1990 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/moasic_1990_06_09.tif")[[1:6]]
ndvi_1990 <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/NDVI_stats_1990.tif")
slope <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/slope.tif")
raster_raw <- i1989[[1]]




dem <- crop(dem, extent(i1989))
slope <- crop(slope, extent(i1989))

dem_new <- resample(dem, raster_raw)
slope_new <- resample(slope, raster_raw)


stack <- stack(dem_new, slope_new, i1989, i1990, ndvi_1990) 


spatial_df <- extract(stack, sample_1000, sp=T)
df <- as.data.frame(spatial_df)
str(df)
df$type <- as.factor(df$type)
df[is.na(df)] = 0




ind <- sample(c(TRUE, FALSE), 2000, replace=TRUE, prob=c(0.7, 0.3))

set1 <- df[ind,]
set2 <- df[!ind,]



rf <- randomForest(type~., set1[,c(-19,-20)] , ntree=500, importance=TRUE)
rf2 <- randomForest(type~., set1[,c(-2,-3,-19,-20)] , ntree=500)


imp_1 <- importance(rf, type=1)
imp_2 <- importance(rf, type=2)

importance_1990_rf <- cbind(imp_1,imp_2)


varImpPlot(rf)



predict1 <- predict(stack, rf)
pred.prob <- predict(stack, rf, type="prob")

predict1 <- stack("Desktop/forest_land_predict_20_04.tif")
spatial_df_val <- raster::extract(predict1, sample_1000, sp=T)
df_val <- as.data.frame(spatial_df_val)
df_val$type <- as.factor(df_val$type)
validation_set <- df_val[!ind,]


validation_set[which(validation_set$type != validation_set$forest_land_predict_20_04),]


validation_set$false_clas <- 0
validation_set$false_clas[which(validation_set$type != validation_set$forest_land_predict_20_04)] <- 1

100-100*(nrow(validation_set[which(validation_set$type != validation_set$forest_land_predict_20_04),])/598)


write.csv(validation_set, "/Users/clemens/Desktop/create_points/validation_set_new_26_02.csv")

writeRaster(pred.prob, "/Users/clemens/Desktop/create_points/pred_prob_new_26_02","GTiff",  overwrite=T)

writeRaster(predict1, "/Users/clemens/Desktop/predicts2_new_26_02","GTiff",  overwrite=T)

writeRaster(predict1, "/Users/clemens/Desktop/forest_land_predict_20_04","GTiff",  overwrite=T)

write.csv(importance_1990_rf, "/Users/clemens/Desktop/importance_stats_1990.csv")
write.csv(set1, "/Users/clemens/Desktop/set_train_1990.csv")
write.csv(set2, "/Users/clemens/Desktop/set_valid_1990.csv")
write.csv(validation_set, "/Users/clemens/Desktop/accuracy_1990.csv")







