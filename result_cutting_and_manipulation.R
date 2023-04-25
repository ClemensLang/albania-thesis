library(rgdal)
library(raster)
library(randomForest)


albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")
sep_ind <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/seperate_indices.tif")
detetcion <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/combined_multi_years.tif")

alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)

forest_1990 <- stack("/Users/clemens/Desktop/create_points/predicts2.tif")



albania <- crop(albania_raw, alb_ext)
albania[albania == 0] <- NA
plot(albania)


forest_albania <- crop(forest_1990, albania)
forest_albania <- albania*forest_albania
forest_albania[forest_albania == 0] <- NA
plot(forest_albania)


sep_ind_alb <- crop(sep_ind, albania)
sep_ind_alb <- forest_albania*sep_ind_alb
plot(sep_ind_alb)


detect_alb <- crop(detetcion, albania)
detect_alb <- forest_albania*detect_alb
plot(detect_alb[[2]])


freq(albania)
freq(albania_raw)





writeRaster(forest_albania, "Desktop/result_manipulation/outputs/forest_albania","GTiff",  overwrite=T)
writeRaster(sep_ind_alb, "Desktop/result_manipulation/outputs/sep_ind_alb","GTiff",  overwrite=T)
writeRaster(detect_alb, "Desktop/result_manipulation/outputs/detect_alb","GTiff",  overwrite=T)




r8 <- stack("/Users/clemens/Desktop/r8.tif")
sep_ind_alb <- stack("/Users/clemens/Desktop/result_manipulation/outputs/sep_ind_alb.tif")
detect_alb <- stack("/Users/clemens/Desktop/result_manipulation/outputs/detect_alb.tif")


forest_albania_30x <- resample(forest_albania,r8, method="ngb")
sep_ind_alb_30x <- resample(sep_ind_alb,r8, method="ngb")
detect_alb_30x <- resample(detect_alb,r8, method="ngb")


writeRaster(forest_albania_30x, "Desktop/result_manipulation/outputs/forest_albania_30m","GTiff",  overwrite=T)
writeRaster(sep_ind_alb_30x, "Desktop/result_manipulation/outputs/sep_ind_alb_30m","GTiff",  overwrite=T)
writeRaster(detect_alb_30x, "Desktop/result_manipulation/outputs/detect_alb_30m","GTiff",  overwrite=T)






