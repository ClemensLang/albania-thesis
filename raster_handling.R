library(rgdal)
library(raster)

# load rasters
raster_stack <- stack("Desktop/Albania_Thesis/data/gee_exports/TCW_1988-2022.tif")
raster_with_roads <- stack ("Desktop/Albania_Thesis/data/own_rasters/raster_base_with_roads.tif")

# extract base raster layer 30m x 30m 
raster_base <- raster_stack[[1]]
raster_base[raster_base >= -1] <- 0
plot(raster_base)
writeRaster(raster_base, "Desktop/Albania_Thesis/data/own_rasters/raster_base.tif",  overwrite=T)




# only keep roads (value = 1) as a new raster
raster_only_roads <- raster_with_roads
raster_only_roads[raster_only_roads >= -1] <- 0
raster_only_roads[raster_with_roads == 1] <- 1 
plot(raster_only_roads)

writeRaster(raster_only_roads, "Desktop/Albania_Thesis/data/own_rasters/roads_200m_raster.tif",  overwrite=T)





roads <- raster_only_roads

r22 <- stack("Desktop/Albania_Thesis/data/gee_exports/TCW_1988-2022.tif")[[1]]
plot(r22)
combi <- roads * r22
plot(combi)

writeRaster(combi, "Desktop/Albania_Thesis/data/own_rasters/TCW_22_accessible_200m.tif",  overwrite=T)



