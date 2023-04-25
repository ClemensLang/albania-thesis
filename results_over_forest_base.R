library(rgdal)
library(raster)



beach_1990 <- stack("Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/beach/beach_forests_1990_prediction.tif")[[1]]
beach_2022 <- stack("Desktop/beach_forests_2022_prediction.tif")[[1]]

no_beach_1990 <- stack("Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/forest_combined_03_03.tif")[[1]]
no_beach_2022 <- stack("Desktop/predicts_2022_date_12_03.tif")[[1]]

plot(no_beach_2022)

freq(no_beach_1990)
freq(no_beach_2022)


beach_1990 <- extend(beach_1990, no_beach_1990, NA)
beach_2022 <- extend(beach_2022, no_beach_2022, NA)

beach_1990[is.na(beach_1990)] <- 0
beach_2022[is.na(beach_2022)] <- 0

no_beach_1990[is.na(no_beach_1990)] <- 0
no_beach_1990[no_beach_1990 == 1] <- 0
no_beach_1990[no_beach_1990 == 2] <- 0
no_beach_1990[no_beach_1990 == 3] <- 1

no_beach_2022[is.na(no_beach_2022)] <- 0
no_beach_2022[no_beach_2022 == 1] <- 0
no_beach_2022[no_beach_2022 == 2] <- 0
no_beach_2022[no_beach_2022 == 3] <- 1


forest_1990 <- no_beach_1990 + beach_1990
forest_2022 <- no_beach_2022 + beach_2022
forest_90_22 <- forest_1990 + forest_2022

forest_1990[forest_1990 > 0] <- 1
forest_1990[forest_1990 == 0] <- NA

forest_2022[forest_2022 > 0] <- 1
forest_2022[forest_2022 == 0] <- NA

forest_90_22[forest_90_22 > 0] <- 1
forest_90_22[forest_90_22 == 0] <- NA

around_alb <- stack(forest_1990, forest_2022, forest_90_22)
around_alb <- stack("Desktop/forest_base_stack_around_albania.tif")

around_alb <- stack(around_alb[[1]], forest_2022, forest_90_22)
forest_1990 <- around_alb[[1]]
writeRaster(around_alb, "/Users/clemens/Desktop/forest_base_stack_around_albania_new","GTiff",  overwrite=T)

plot(forest_90_22)



albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")
alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)

sep_ind <- stack("/Users/clemens/Desktop/create_points/rasters_for_points/seperate_indices.tif")
detetcion <- stack("/Users/clemens/Desktop/Albania_Thesis/data/processing_data_stuff/forest_base_layer/create_points/rasters_for_points/combined_multi_years.tif")
r_reverse <- stack("Desktop/Rtotal2.tif")

detetcion

tmp_stack <- detetcion[[4]]
tmp_stack <- stack(detetcion[[3]],tmp_stack )
tmp_stack <- stack(detetcion[[1]],tmp_stack )
tmp_stack <- stack(detetcion[[2]], tmp_stack)
tmp_stack <- stack(r_reverse)

detetcion <- tmp_stack



albania <- crop(albania_raw, alb_ext)
albania[albania == 0] <- NA
plot(albania)


forest_1990 <- stack("Desktop/forest_base_stack_around_albania.tif")[[1]]
forest_2022 <- stack("Desktop/forest_base_stack_around_albania.tif")[[2]]

plot(forest_1990)

forest_albania <- crop(forest_1990, albania)
forest_albania <- albania*forest_albania
forest_albania[forest_albania == 0] <- NA
plot(forest_albania)
plot(detetcion[[1]])


forest_albania_22 <- crop(forest_2022, albania)
forest_albania_22 <- albania*forest_albania_22
forest_albania_22[forest_albania_22 == 0] <- NA
plot(forest_albania_22)
plot(detetcion[[1]])


sep_ind_alb <- crop(sep_ind, albania)
sep_ind_alb <- forest_albania*sep_ind_alb

detect_alb <- crop(detetcion, albania)
detect_alb <- forest_albania*detect_alb

forest_albania_90_22 <- stack(forest_albania, forest_albania_22)

writeRaster(forest_albania_90_22, "Desktop/forest_albania_90_22_new","GTiff",  overwrite=T)
writeRaster(sep_ind_alb, "Desktop/sep_ind_alb_(11_03)","GTiff",  overwrite=T)
writeRaster(detect_alb, "Desktop/detect_alb_(11_03)","GTiff",  overwrite=T)







albania <- crop(albania_raw, alb_ext)







plot()













