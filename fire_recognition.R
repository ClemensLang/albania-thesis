library(rgdal)
library(raster)
library(randomForest)
library(e1071)



albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")
alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)
albania <- crop(albania_raw, alb_ext)

plot(albania)


fire_loss <- stack("/Users/clemens/Desktop/Albania_Thesis/data/VIRRS_fire_loss/fire_loss_clip_albania.tif")
fire_year <- stack(("/Users/clemens/Desktop/Albania_Thesis/data/VIRRS_fire_loss/fire_loss_annual_clip_albania.tif"))

freq(fire_year)
plot(fire_loss)


fire_loss <- crop(fire_loss, albania)
fire_loss[fire_loss==0] <- NA
fire_loss <- resample(fire_loss,albania)

fire_year <- crop(fire_year, albania)
fire_year[fire_year==0] <- NA
fire_year <- resample(fire_year,albania)
fire_year1 <- fire_year*albania



forest_loss <- stack("/Users/clemens/Desktop/Albania_Thesis/data/01_final_results_rasters/sep_ind_alb_loss_newest_first(04_04).tif")
forest_gain <- stack("/Users/clemens/Desktop/Albania_Thesis/data/01_final_results_rasters/sep_ind_alb_gain_(12_03).tif")
valid_gain <- stack("/Users/clemens/Desktop/Albania_Thesis/data/01_final_results_rasters/valid_gain.tif")


loss_mask <- forest_loss[[1]]
loss_mask[!is.na(loss_mask)] <- 1

plot(loss_mask)

plot(fire_year)

fire_loss <- fire_loss*loss_mask
fire_year2 <- fire_year*loss_mask
freq(fire_loss)


plot(fire_loss)


set.seed(4444)

sample <- sampleRandom(fire_loss, size=10000, sp=T)
names(sample) <- "layer"


plot(sample$layer)
sample$layer

plot(sample)


sample2 <- sample[sample$layer == 1,]
length(sample2)
sample2 <- sample2[sample(1:length(sample2), 500, replace=F),]

sample3 <- sample[sample$layer == 4,]
length(sample3)
sample3 <- sample3[sample(1:length(sample3), 500, replace=F),]


sample_1000 <- rbind(sample2,sample3)
names(sample_1000) <- "type"
length(sample_1000)




stack <- stack(forest_loss, forest_gain, valid_gain[[2]])



spatial_df <- extract(stack_02, sample_1000, sp=T)
df <- as.data.frame(spatial_df)
df[1001:1500,] <- 0
str(df)
df$type <- as.factor(df$type)
#levels(df$type) <- c("1","4","0")
df[is.na(df)] = 0

df[1001:1500,] <- 0

plot(spatial_df)
str(df)

#ind <- sample(c(TRUE, FALSE), 1500, replace=TRUE, prob=c(0.7, 0.3))
ind <- sample(c(TRUE, FALSE), 1000, replace=TRUE, prob=c(0.7, 0.3))

set1 <- df[ind,]
set2 <- df[!ind,]

str(set1)

rf <- randomForest(type~., set1[,c(-16,-17)] , ntree=500, importance=TRUE)
rf2 <- randomForest(type~., set1[,c(-2,-3,-19,-20)] , ntree=500)


importance(rf, type=1)

imp_1 <- importance(rf, type=1)
imp_2 <- importance(rf, type=2)

importance_rf <- cbind(imp_1,imp_2)


varImpPlot(rf)

stack_0 <- stack


for (i in c(1:30)){
  stack_0[[i]][is.na(stack_0[[i]])] <- 0
  print(i)
}




stack_0[[]]

writeRaster(stack_0, "/Users/clemens/Desktop/stack_0","GTiff",  overwrite=T)
stack_0 <- stack("/Users/clemens/Desktop/stack_0.tif")


predict1 <- predict(stack, rf)
predict2 <- predict(stack_0, rf)
pred.prob <- predict(stack_0, rf, type="prob")

predict3 <- predict(stack_02, rf)
pred.prob2 <- predict(stack_02, rf, type="prob")


plot(stack[[2]])


spatial_df_val <- extract(predict3, sample_1000, sp=T)
df_val <- as.data.frame(spatial_df_val)
df_val$type <- as.factor(df_val$type)
validation_set <- df_val[!ind,]


validation_set[which(validation_set$type != validation_set$layer),]

nrow(validation_set)

validation_set$false_clas <- 0
validation_set$false_clas[which(validation_set$type != validation_set$layer)] <- 1

100-100*(nrow(validation_set[which(validation_set$type != validation_set$layer),])/331)


writeRaster(predict1, "/Users/clemens/Desktop/predicts_fire_04_04","GTiff",  overwrite=T)

writeRaster(predict2, "/Users/clemens/Desktop/predicts2_fire_04_04","GTiff",  overwrite=T)

writeRaster(pred.prob, "/Users/clemens/Desktop/predicts.prob_fire_06_04","GTiff",  overwrite=T)

writeRaster(predict3, "/Users/clemens/Desktop/fire_22_04","GTiff",  overwrite=T)

writeRaster(pred.prob2, "/Users/clemens/Desktop/predicts.prob2_fire_06_04","GTiff",  overwrite=T)





names(stack_0) <- names(stack)


stack_01 <- stack_0
for (i in c(1:30)){
  stack_01[[i]][is.na(loss_mask)] <- NA
  print(i)
}


plot(stack_02[[1]])
writeRaster(stack_01, "/Users/clemens/Desktop/stack_01","GTiff",  overwrite=T)


valid[valid == 0] <- NA

names(stack_02)
stack_01 <- stack("/users/clemens/Desktop/Albania_Thesis/data/stats/rasters/stack_01.tif")
stack_02 <- stack_01[[1:14]]




writeRaster(predict1, "/Users/clemens/Desktop/forest_land_predict_20_04_manual","GTiff",  overwrite=T)


write.csv(importance_rf, "/Users/clemens/Desktop/importance_fire.csv")
write.csv(set1, "/Users/clemens/Desktop/set_train_fire.csv")
write.csv(set2, "/Users/clemens/Desktop/set_valid_fire.csv")
write.csv(validation_set, "/Users/clemens/Desktop/accuracy_firel.csv")


















writeRaster(gain_between, "/Users/clemens/Desktop/Albania_Thesis/data/01_final_results_rasters/gain_between","GTiff",  overwrite=T)











fire_year1df <- as.data.frame(freq(fire_year1))
fire_year1df[,2] <- fire_year1df[,2]*0.06771299
fire_year1df

fire_year2df <- as.data.frame(freq(fire_year2))
fire_year2df[,2] <- fire_year2df[,2]*0.06771299



















