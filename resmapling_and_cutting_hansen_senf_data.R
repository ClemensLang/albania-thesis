library(rgdal)
library(raster)




albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")
alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)
albania <- crop(albania_raw, alb_ext)



hansen_gain <- stack("Desktop/Albania_Thesis/data/hansen_data/forest_gain/forest_gain_00-21_albania.tif")
hansen_loss <- stack("Desktop/Albania_Thesis/data/hansen_data/forest_loss/forest_loss_00-21_albania.tif")
senf_disturbance <- stack("Desktop/Albania_Thesis/data/senf_data/senf_disturbance_year_albania.tif")
senf_forest_2020 <- stack("Desktop/Albania_Thesis/data/senf_data/senf_forest_cover_2020.tif")

hansen_gain <- crop(hansen_gain, albania)
hansen_gain <- resample(hansen_gain,albania)

hansen_loss <- crop(hansen_loss, albania)
hansen_loss <- resample(hansen_loss,albania)

senf_disturbance <- crop(senf_disturbance, albania)
senf_disturbance <- resample(senf_disturbance,albania)
senf_disturbance <- senf_disturbance*albania

senf_forest_2020 <- crop(senf_forest_2020, albania)
senf_forest_2020 <- resample(senf_forest_2020,albania)
senf_forest_2020 <- senf_forest_2020*albania

senf_stack_albania <- stack(senf_disturbance, senf_forest_2020)

writeRaster(senf_stack_albania, "Desktop/Albania_Thesis/data/senf_data/senf_stack_albania","GTiff",  overwrite=T)





hansen_2000 <- stack("Desktop/Albania_Thesis/data/hansen_data/forest_cover_2000/hansen_fc_only_albania.tif")
hansen_2010 <- stack("Desktop/Albania_Thesis/data/hansen_data/forest_cover_2010/hansen_fc_only_albania_2010.tif")

hansen_2000_5 <- hansen_2000
hansen_2000_5[hansen_2000_5 >= 5] <- 1
hansen_2000_5[hansen_2000_5 != 1] <- NA
hansen_2000_5 <- crop(hansen_2000_5, albania)
hansen_2000_5 <- resample(hansen_2000_5,albania)
hansen_2000_5 <- hansen_2000_5*albania
plot(hansen_2000_5)

hansen_2000_50 <- hansen_2000
hansen_2000_50[hansen_2000_50 >= 50] <- 1
hansen_2000_50[hansen_2000_50 != 1] <- NA
hansen_2000_50 <- crop(hansen_2000_50, albania)
hansen_2000_50 <- resample(hansen_2000_50,albania)
hansen_2000_50 <- hansen_2000_50*albania

hansen_2010_5 <- hansen_2010
hansen_2010_5[hansen_2010_5 >= 5] <- 1
hansen_2010_5[hansen_2010_5 != 1] <- NA
hansen_2010_5 <- crop(hansen_2010_5, albania)
hansen_2010_5 <- resample(hansen_2010_5,albania)
hansen_2010_5 <- hansen_2010_5*albania

hansen_2010_50 <- hansen_2010
hansen_2010_50[hansen_2010_50 >= 50] <- 1
hansen_2010_50[hansen_2010_50 != 1] <- NA
hansen_2010_50 <- crop(hansen_2010_50, albania)
hansen_2010_50 <- resample(hansen_2010_50,albania)
hansen_2010_50 <- hansen_2010_50*albania



hansen_stack <- stack("Desktop/Albania_Thesis/data/hansen_data/hansen_stack_albania.tif")
hansen_stack[[5]] <- hansen_stack[[5]] * albania
hansen_stack[[6]] <- hansen_stack[[6]] * albania

hansen_stack <- stack(hansen_2000_5, hansen_2000_50, hansen_2010_5, hansen_2010_50, hansen_loss, hansen_gain)
writeRaster(hansen_stack, "/Users/clemens/Desktop/Albania_Thesis/data/hansen_data/hansen_stack_albania","GTiff",  overwrite=T)
























