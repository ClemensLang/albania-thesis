library(rgdal)
library(raster)

#1988 - 2002
ndvi1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[1]]
tcw1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/TCW_gain_dur_max.tif")[[1]]
nbr1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[1]]
ndvi1[ndvi1 < 1990] <- NA
tcw1[tcw1 < 1990] <- NA
nbr1[nbr1 < 1990] <- NA

ndvi1[ndvi1 < 1990] <- 0
ndvi1[ndvi1 >= 1990] <- 1
tcw1[tcw1 < 1990] <- 0
tcw1[tcw1 >= 1990] <- 1
nbr1[nbr1 < 1990] <- 0
nbr1[nbr1 >= 1990] <- 1

test_raster <- ndvi1+tcw1+nbr1
test_raster[test_raster == 0] <- NA
freq(test_raster)

#stack, average (men) and round all time periods
stack1 <- stack(ndvi1,tcw1,nbr1)
r1 <- calc(stack1, fun = mean, na.rm = T)
r1 <- round(r1)

r1[r1 < 1990] <- NA

plot(r1)

test_raster2 <- r1
test_raster2[!is.na(test_raster2)] <- 1
freq(test_raster2)


r_1990_2022 <- stack("outputs/r_1990_2022.tif")


## adding nbr, tcw, and ndvi, values into a raster

ind_1990_2022 <- stack(r1,r1,r1,r1,r1,r1,r1)
ind_1990_2022 <- stack(ind_1990_2022,ind_1990_2022,r1)

#1988 - 2002
#ndvi1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[1]]
#tcw1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/TCW_gain_dur_max.tif")[[1]]
#nbr1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[1]]

#### ndvi seperate loading ####
##ndvi part1
ndvi1.1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[1]]
ndvi1.2 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[2]]
ndvi1.3 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[3]]
ndvi1.4 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[4]]
#ndvi1.1[ndvi1.1 > 1999] <- NA
ndvi1.1[ndvi1.1 < 1990] <- NA
ndvi1.2[is.na(ndvi1.1)] <- NA
ndvi1.3[is.na(ndvi1.1)] <- NA
ndvi1.4[is.na(ndvi1.1)] <- NA

#### tcw seperate loading ####
##tcw part1
tcw1.1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/TCW_gain_dur_max.tif")[[1]]
tcw1.2 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/TCW_gain_dur_max.tif")[[2]]
tcw1.3 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/TCW_gain_dur_max.tif")[[3]]
tcw1.4 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/TCW_gain_dur_max.tif")[[4]]
#tcw1.1[tcw1.1 > 1999] <- NA
tcw1.1[tcw1.1 < 1990] <- NA
tcw1.2[is.na(tcw1.1)] <- NA
tcw1.3[is.na(tcw1.1)] <- NA
tcw1.4[is.na(tcw1.1)] <- NA


#### nbr seperate loading ####
##nbr part1
nbr1.1 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[1]]
nbr1.2 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[2]]
nbr1.3 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[3]]
nbr1.4 <- stack("Desktop/Albania_Thesis/data/gee_exports/new_exports_gain_and_multiple_loss/gain/NDVI_gain_dur_max (1).tif")[[4]]
#nbr1.1[nbr1.1 > 1999] <- NA
nbr1.1[nbr1.1 < 1990] <- NA
nbr1.2[is.na(nbr1.1)] <- NA
nbr1.3[is.na(nbr1.1)] <- NA
nbr1.4[is.na(nbr1.1)] <- NA



#### combining individual rasters ####

ind_1990_2022[[4]] <- ndvi1.1
ind_1990_2022[[5]] <- ndvi1.2
ind_1990_2022[[6]] <- ndvi1.3
ind_1990_2022[[7]] <- ndvi1.4
ind_1990_2022[[8]] <- tcw1.1
ind_1990_2022[[9]] <- tcw1.2
ind_1990_2022[[10]] <- tcw1.3
ind_1990_2022[[11]] <- tcw1.4
ind_1990_2022[[12]] <- nbr1.1
ind_1990_2022[[13]] <- nbr1.2
ind_1990_2022[[14]] <- nbr1.3
ind_1990_2022[[15]] <- nbr1.4



#### other ####

tmp_v_c <- ind_1990_2022[[3]]
tmp_w_c <- ind_1990_2022[[7]]
tmp_b_c <- ind_1990_2022[[11]]

tmp_v_c[tmp_v_c > 0] <- 3
tmp_v_c[is.na(tmp_v_c)] <- 1
tmp_w_c[tmp_w_c > 0] <- 5
tmp_w_c[is.na(tmp_w_c)] <- 1
tmp_b_c[tmp_b_c > 0] <- 7
tmp_b_c[is.na(tmp_b_c)] <- 1

tmp_index_count <- tmp_v_c*tmp_w_c*tmp_b_c

tmp_index_count[tmp_index_count == 1] <- NA
tmp_index_count[tmp_index_count == 3] <- 1
tmp_index_count[tmp_index_count == 5] <- 2
tmp_index_count[tmp_index_count == 7] <- 3
tmp_index_count[tmp_index_count == 15] <- 4
tmp_index_count[tmp_index_count == 21] <- 5
tmp_index_count[tmp_index_count == 35] <- 6
tmp_index_count[tmp_index_count == 105] <- 7

freq(tmp_index_count)

plot(tmp_index_count)

ind_1990_2022[[3]] <- tmp_index_count
ind_1990_2022[[2]] <- test_raster

writeRaster(ind_1990_2022, "Desktop/ind_1990_2022","GTiff",  overwrite=T)



ind_1990_2022 <- stack("Desktop/ind_1990_2022.tif")


albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")

alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)

forest_base <- stack("Desktop/forest_base_stack_around_albania_new.tif")[[3]]






albania <- crop(albania_raw, alb_ext)
albania[albania == 0] <- NA
plot(albania)


forest_albania <- crop(forest_base, albania)
forest_albania <- albania*forest_albania
forest_albania[forest_albania == 0] <- NA
plot(forest_albania)


sep_ind_alb <- crop(ind_1990_2022, albania)
sep_ind_alb <- forest_albania*sep_ind_alb


writeRaster(sep_ind_alb, "Desktop/sep_ind_alb_gain_(12_03)","GTiff",  overwrite=T)








