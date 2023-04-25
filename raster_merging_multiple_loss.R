library(rgdal)
library(raster)

#1988 - 2002
ndvi1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1988-2002_2.tif")[[1]]
tcw1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1988-2002_2.tif")[[1]]
nbr1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1988-2002.tif")[[1]]
ndvi1[ndvi1 == 0] <- NA
tcw1[tcw1 == 0] <- NA
nbr1[nbr1 == 0] <- NA


#1998 - 2012
ndvi2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1998-2012_2.tif")[[1]]
tcw2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1998-2012_2.tif")[[1]]
nbr2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1998-2012.tif")[[1]]
ndvi2[ndvi2 == 0] <- NA
tcw2[tcw2 == 0] <- NA
nbr2[nbr2 == 0] <- NA


#2008 - 2022
ndvi3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_2008_2022_2.tif")[[1]]
tcw3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_2008-2022_2.tif")[[1]]
nbr3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_2008_2022.tif")[[1]]
ndvi3[ndvi3 == 0] <- NA
tcw3[tcw3 == 0] <- NA
nbr3[nbr3 == 0] <- NA

#stack, average (men) and round all time periods
stack1 <- stack(ndvi1,tcw1,nbr1)
stack2 <- stack(ndvi2,tcw2,nbr2)
stack3 <- stack(ndvi3,tcw3,nbr3)
r1 <- calc(stack1, fun = mean, na.rm = T)
r1 <- round(r1)
r2 <- calc(stack2, fun = mean, na.rm = T)
r2 <- round(r2)
r3 <- calc(stack3, fun = mean, na.rm = T)
r3 <- round(r3)



#repeat for overlapping periods
r9802_1 <- r1
r9802_1[r9802_1 < 1998] <- NA
r9802_2 <- r2
r9802_2[r9802_2 > 2002] <- NA
stack4 <- stack(r9802_1, r9802_2)
r12 <- calc(stack4, fun = mean, na.rm = T)
r12 <- round(r12)

r0812_1 <- r2
r0812_1[r0812_1 < 2008] <- NA
r0812_2 <- r3
r0812_2[r0812_2 > 2012] <- NA
stack5 <- stack(r0812_1, r0812_2)
r23 <- calc(stack5, fun = mean, na.rm = T)
r23 <- round(r23)


#exporting temporary results
writeRaster(r1, "Desktop/raster_multiple_merge/outputs/r1","GTiff",  overwrite=T)
writeRaster(r2, "Desktop/raster_multiple_merge/outputs/r2","GTiff",  overwrite=T)
writeRaster(r3, "Desktop/raster_multiple_merge/outputs/r3","GTiff",  overwrite=T)
writeRaster(r12, "Desktop/raster_multiple_merge/outputs/r12","GTiff",  overwrite=T)
writeRaster(r23, "Desktop/raster_multiple_merge/outputs/r23","GTiff",  overwrite=T)


r1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/outputs/r1.tif")
r2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/outputs/r2.tif")
r3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/outputs/r3.tif")
r12 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/outputs/r12.tif")
r23 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/outputs/r23.tif")


#stitching different periods together
r01 <- r1
r01[r01 > 1997] <- NA
r01[r01 < 1990] <- NA   #remove pixels before 1990
r02 <- r12
r03 <- r2
r03[r03 > 2007] <- NA
r03[r03 < 2003] <- NA
r04 <- r23
r05 <- r3
r05[r05 < 2013] <- NA

#sum up multiple losses on pixels
v01 <- r01
v01[v01 > 0] <- 1
v01[is.na(v01)] <- 0
v02 <- r02
v02[v02 > 0] <- 1
v02[is.na(v02)] <- 0
v03 <- r03
v03[v03 > 0] <- 1
v03[is.na(v03)] <- 0
v04 <- r04
v04[v04 > 0] <- 1
v04[is.na(v04)] <- 0
v05 <- r05
v05[v05 > 0] <- 1
v05[is.na(v05)] <- 0

r_multi <- (v01+v02+v03+v04+v05)


writeRaster(r_multi, "Desktop/raster_multiple_merge/outputs/r_multi","GTiff",  overwrite=T)


freq(r_multi)



Rtotal1 <- r01
Rtotal1 <- cover(Rtotal1,r02)
Rtotal1 <- cover(Rtotal1,r03)
Rtotal1 <- cover(Rtotal1,r04)
Rtotal1 <- cover(Rtotal1,r05)

# other way round, newest changes are displayed in raster
Rtotal2 <- r05
Rtotal2 <- cover(Rtotal2,r04)
Rtotal2 <- cover(Rtotal2,r03)
Rtotal2 <- cover(Rtotal2,r02)
Rtotal2 <- cover(Rtotal2,r01)

plot(Rtotal1)
plot(Rtotal2)


writeRaster(Rtotal2, "Desktop/Rtotal2","GTiff",  overwrite=T)

r_1988_2022 <- Rtotal1

r_1988_2022 <- stack(r_1988_2022,r_1988_2022,r_1988_2022,r_1988_2022)
r_1988_2022[[2]] <- r_multi
r_1988_2022[[3]] <- NA
r_1988_2022[[4]] <- NA

r_1988_2022[[3]] <- cover(r_1988_2022[[3]],r02)
r_1988_2022[[3]][r_1988_2022[[2]] < 2] <- NA
r_1988_2022[[3]][r_1988_2022[[3]] == r_1988_2022[[1]]] <- NA
r_1988_2022[[3]] <- cover(r_1988_2022[[3]],r03)
r_1988_2022[[3]][r_1988_2022[[2]] < 2] <- NA
r_1988_2022[[3]][r_1988_2022[[3]] == r_1988_2022[[1]]] <- NA
r_1988_2022[[3]] <- cover(r_1988_2022[[3]],r04)
r_1988_2022[[3]][r_1988_2022[[2]] < 2] <- NA
r_1988_2022[[3]][r_1988_2022[[3]] == r_1988_2022[[1]]] <- NA
r_1988_2022[[3]] <- cover(r_1988_2022[[3]],r05)
r_1988_2022[[3]][r_1988_2022[[2]] < 2] <- NA
r_1988_2022[[3]][r_1988_2022[[3]] == r_1988_2022[[1]]] <- NA


sum(freq(r_multi)[c(3,4),2])
sum(freq(r_1988_2022[[3]])[-25,2])

r_1988_2022[[4]] <- cover(r_1988_2022[[4]],r03)
r_1988_2022[[4]][r_1988_2022[[2]] != 3] <- NA
r_1988_2022[[4]][r_1988_2022[[4]] == r_1988_2022[[1]]] <- NA
r_1988_2022[[4]][r_1988_2022[[4]] == r_1988_2022[[3]]] <- NA
r_1988_2022[[4]] <- cover(r_1988_2022[[4]],r04)
r_1988_2022[[4]][r_1988_2022[[2]] != 3] <- NA
r_1988_2022[[4]][r_1988_2022[[4]] == r_1988_2022[[1]]] <- NA
r_1988_2022[[4]][r_1988_2022[[4]] == r_1988_2022[[3]]] <- NA
r_1988_2022[[4]] <- cover(r_1988_2022[[4]],r05)
r_1988_2022[[4]][r_1988_2022[[2]] != 3] <- NA
r_1988_2022[[4]][r_1988_2022[[4]] == r_1988_2022[[1]]] <- NA
r_1988_2022[[4]][r_1988_2022[[4]] == r_1988_2022[[3]]] <- NA


freq(r_multi)[4,2]
sum(freq(r_1988_2022[[4]])[-15,2])

r_1988_2022[[2]][r_1988_2022[[2]] == 0] <- NA

r_1990_2022 <- r_1988_2022

writeRaster(r_1990_2022, "Desktop/raster_multiple_merge/outputs/r_1990_2022","GTiff",  overwrite=T)








r_1990_2022 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/outputs/r_1990_2022.tif")


## adding nbr, tcw, and ndvi, values into a raster

ind_1990_2022 <- r_1990_2022
ind_1990_2022[[1]] <- NA
ind_1990_2022[[2]] <- NA
ind_1990_2022[[3]] <- NA
ind_1990_2022[[4]] <- NA

ind_1990_2022 <- stack(ind_1990_2022,ind_1990_2022,ind_1990_2022,ind_1990_2022)

ind_1990_2022[[1]] <- r_1990_2022[[1]]



#### ndvi seperate loading ####
##ndvi part1
ndvi1.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1988-2002_2.tif")[[1]]
ndvi1.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1988-2002_2.tif")[[2]]
ndvi1.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1988-2002_2.tif")[[3]]
ndvi1.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1988-2002_2.tif")[[4]]
#ndvi1.1[ndvi1.1 > 1999] <- NA
ndvi1.1[ndvi1.1 < 1990] <- NA
ndvi1.2[is.na(ndvi1.1)] <- NA
ndvi1.3[is.na(ndvi1.1)] <- NA
ndvi1.4[is.na(ndvi1.1)] <- NA

#ndvi part2
ndvi2.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1998-2012_2.tif")[[1]]
ndvi2.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1998-2012_2.tif")[[2]]
ndvi2.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1998-2012_2.tif")[[3]]
ndvi2.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_1998-2012_2.tif")[[4]]
#ndvi2.1[ndvi2.1 > 2009] <- NA
ndvi2.1[ndvi2.1 < 1999] <- NA
ndvi2.2[is.na(ndvi2.1)] <- NA
ndvi2.3[is.na(ndvi2.1)] <- NA
ndvi2.4[is.na(ndvi2.1)] <- NA

#ndvi part3
ndvi3.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_2008_2022_2.tif")[[1]]
ndvi3.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_2008_2022_2.tif")[[2]]
ndvi3.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_2008_2022_2.tif")[[3]]
ndvi3.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NDVI_2008_2022_2.tif")[[4]]
ndvi3.1[ndvi3.1 < 2009] <- NA
ndvi3.2[is.na(ndvi3.1)] <- NA
ndvi3.3[is.na(ndvi3.1)] <- NA
ndvi3.4[is.na(ndvi3.1)] <- NA


#### tcw seperate loading ####
##tcw part1
tcw1.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1988-2002_2.tif")[[1]]
tcw1.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1988-2002_2.tif")[[2]]
tcw1.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1988-2002_2.tif")[[3]]
tcw1.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1988-2002_2.tif")[[4]]
#tcw1.1[tcw1.1 > 1999] <- NA
tcw1.1[tcw1.1 < 1990] <- NA
tcw1.2[is.na(tcw1.1)] <- NA
tcw1.3[is.na(tcw1.1)] <- NA
tcw1.4[is.na(tcw1.1)] <- NA

#tcw part2
tcw2.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1998-2012_2.tif")[[1]]
tcw2.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1998-2012_2.tif")[[2]]
tcw2.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1998-2012_2.tif")[[3]]
tcw2.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_1998-2012_2.tif")[[4]]
#tcw2.1[tcw2.1 > 2009] <- NA
tcw2.1[tcw2.1 < 1999] <- NA
tcw2.2[is.na(tcw2.1)] <- NA
tcw2.3[is.na(tcw2.1)] <- NA
tcw2.4[is.na(tcw2.1)] <- NA

#tcw part3
tcw3.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_2008-2022_2.tif")[[1]]
tcw3.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_2008-2022_2.tif")[[2]]
tcw3.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_2008-2022_2.tif")[[3]]
tcw3.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/TCW_2008-2022_2.tif")[[4]]
tcw3.1[tcw3.1 < 2009] <- NA
tcw3.2[is.na(tcw3.1)] <- NA
tcw3.3[is.na(tcw3.1)] <- NA
tcw3.4[is.na(tcw3.1)] <- NA



#### nbr seperate loading ####
##nbr part1
nbr1.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1988-2002.tif")[[1]]
nbr1.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1988-2002.tif")[[2]]
nbr1.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1988-2002.tif")[[3]]
nbr1.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1988-2002.tif")[[4]]
#nbr1.1[nbr1.1 > 1999] <- NA
nbr1.1[nbr1.1 < 1990] <- NA
nbr1.2[is.na(nbr1.1)] <- NA
nbr1.3[is.na(nbr1.1)] <- NA
nbr1.4[is.na(nbr1.1)] <- NA

#nbr part2
nbr2.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1998-2012.tif")[[1]]
nbr2.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1998-2012.tif")[[2]]
nbr2.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1998-2012.tif")[[3]]
nbr2.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_1998-2012.tif")[[4]]
#nbr2.1[nbr2.1 > 2009] <- NA
nbr2.1[nbr2.1 < 1999] <- NA
nbr2.2[is.na(nbr2.1)] <- NA
nbr2.3[is.na(nbr2.1)] <- NA
nbr2.4[is.na(nbr2.1)] <- NA

#nbr part3
nbr3.1 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_2008_2022.tif")[[1]]
nbr3.2 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_2008_2022.tif")[[2]]
nbr3.3 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_2008_2022.tif")[[3]]
nbr3.4 <- stack("Desktop/Albania_Thesis/data/own_rasters/raster_multiple_merge/NBR_2008_2022.tif")[[4]]
nbr3.1[nbr3.1 < 2009] <- NA
nbr3.2[is.na(nbr3.1)] <- NA
nbr3.3[is.na(nbr3.1)] <- NA
nbr3.4[is.na(nbr3.1)] <- NA













#### combining individual rasters ####

ind_1990_2022[[3]] <- cover(ind_1990_2022[[3]],ndvi1.1)
ind_1990_2022[[3]] <- cover(ind_1990_2022[[3]],ndvi2.1)
ind_1990_2022[[3]] <- cover(ind_1990_2022[[3]],ndvi3.1)

ind_1990_2022[[4]] <- cover(ind_1990_2022[[4]],ndvi1.2)
ind_1990_2022[[4]] <- cover(ind_1990_2022[[4]],ndvi2.2)
ind_1990_2022[[4]] <- cover(ind_1990_2022[[4]],ndvi3.2)

ind_1990_2022[[5]] <- cover(ind_1990_2022[[5]],ndvi1.3)
ind_1990_2022[[5]] <- cover(ind_1990_2022[[5]],ndvi2.3)
ind_1990_2022[[5]] <- cover(ind_1990_2022[[5]],ndvi3.3)

ind_1990_2022[[6]] <- cover(ind_1990_2022[[6]],ndvi1.4)
ind_1990_2022[[6]] <- cover(ind_1990_2022[[6]],ndvi2.4)
ind_1990_2022[[6]] <- cover(ind_1990_2022[[6]],ndvi3.4)


ind_1990_2022[[7]] <- cover(ind_1990_2022[[7]],tcw1.1)
ind_1990_2022[[7]] <- cover(ind_1990_2022[[7]],tcw2.1)
ind_1990_2022[[7]] <- cover(ind_1990_2022[[7]],tcw3.1)

ind_1990_2022[[8]] <- cover(ind_1990_2022[[8]],tcw1.2)
ind_1990_2022[[8]] <- cover(ind_1990_2022[[8]],tcw2.2)
ind_1990_2022[[8]] <- cover(ind_1990_2022[[8]],tcw3.2)

ind_1990_2022[[9]] <- cover(ind_1990_2022[[9]],tcw1.3)
ind_1990_2022[[9]] <- cover(ind_1990_2022[[9]],tcw2.3)
ind_1990_2022[[9]] <- cover(ind_1990_2022[[9]],tcw3.3)

ind_1990_2022[[10]] <- cover(ind_1990_2022[[10]],tcw1.4)
ind_1990_2022[[10]] <- cover(ind_1990_2022[[10]],tcw2.4)
ind_1990_2022[[10]] <- cover(ind_1990_2022[[10]],tcw3.4)


ind_1990_2022[[11]] <- cover(ind_1990_2022[[11]],nbr1.1)
ind_1990_2022[[11]] <- cover(ind_1990_2022[[11]],nbr2.1)
ind_1990_2022[[11]] <- cover(ind_1990_2022[[11]],nbr3.1)

ind_1990_2022[[12]] <- cover(ind_1990_2022[[12]],nbr1.2)
ind_1990_2022[[12]] <- cover(ind_1990_2022[[12]],nbr2.2)
ind_1990_2022[[12]] <- cover(ind_1990_2022[[12]],nbr3.2)

ind_1990_2022[[13]] <- cover(ind_1990_2022[[13]],nbr1.3)
ind_1990_2022[[13]] <- cover(ind_1990_2022[[13]],nbr2.3)
ind_1990_2022[[13]] <- cover(ind_1990_2022[[13]],nbr3.3)

ind_1990_2022[[14]] <- cover(ind_1990_2022[[14]],nbr1.4)
ind_1990_2022[[14]] <- cover(ind_1990_2022[[14]],nbr2.4)
ind_1990_2022[[14]] <- cover(ind_1990_2022[[14]],nbr3.4)



#### combining individual rasters (newest first)####

ind_1990_2022[[3]] <- cover(ind_1990_2022[[3]],ndvi3.1)
ind_1990_2022[[3]] <- cover(ind_1990_2022[[3]],ndvi2.1)
ind_1990_2022[[3]] <- cover(ind_1990_2022[[3]],ndvi1.1)

ind_1990_2022[[4]] <- cover(ind_1990_2022[[4]],ndvi3.2)
ind_1990_2022[[4]] <- cover(ind_1990_2022[[4]],ndvi2.2)
ind_1990_2022[[4]] <- cover(ind_1990_2022[[4]],ndvi1.2)

ind_1990_2022[[5]] <- cover(ind_1990_2022[[5]],ndvi3.3)
ind_1990_2022[[5]] <- cover(ind_1990_2022[[5]],ndvi2.3)
ind_1990_2022[[5]] <- cover(ind_1990_2022[[5]],ndvi1.3)

ind_1990_2022[[6]] <- cover(ind_1990_2022[[6]],ndvi3.4)
ind_1990_2022[[6]] <- cover(ind_1990_2022[[6]],ndvi2.4)
ind_1990_2022[[6]] <- cover(ind_1990_2022[[6]],ndvi1.4)


ind_1990_2022[[7]] <- NA
ind_1990_2022[[8]] <- NA
ind_1990_2022[[9]] <- NA
ind_1990_2022[[10]] <- NA


ind_1990_2022[[7]] <- cover(ind_1990_2022[[7]],tcw3.1)
ind_1990_2022[[7]] <- cover(ind_1990_2022[[7]],tcw2.1)
ind_1990_2022[[7]] <- cover(ind_1990_2022[[7]],tcw1.1)

ind_1990_2022[[8]] <- cover(ind_1990_2022[[8]],tcw3.2)
ind_1990_2022[[8]] <- cover(ind_1990_2022[[8]],tcw2.2)
ind_1990_2022[[8]] <- cover(ind_1990_2022[[8]],tcw1.2)

ind_1990_2022[[9]] <- cover(ind_1990_2022[[9]],tcw3.3)
ind_1990_2022[[9]] <- cover(ind_1990_2022[[9]],tcw2.3)
ind_1990_2022[[9]] <- cover(ind_1990_2022[[9]],tcw1.3)

ind_1990_2022[[10]] <- cover(ind_1990_2022[[10]],tcw3.4)
ind_1990_2022[[10]] <- cover(ind_1990_2022[[10]],tcw2.4)
ind_1990_2022[[10]] <- cover(ind_1990_2022[[10]],tcw1.4)


ind_1990_2022[[11]] <- cover(ind_1990_2022[[11]],nbr3.1)
ind_1990_2022[[11]] <- cover(ind_1990_2022[[11]],nbr2.1)
ind_1990_2022[[11]] <- cover(ind_1990_2022[[11]],nbr1.1)

ind_1990_2022[[12]] <- cover(ind_1990_2022[[12]],nbr3.2)
ind_1990_2022[[12]] <- cover(ind_1990_2022[[12]],nbr2.2)
ind_1990_2022[[12]] <- cover(ind_1990_2022[[12]],nbr1.2)

ind_1990_2022[[13]] <- cover(ind_1990_2022[[13]],nbr3.3)
ind_1990_2022[[13]] <- cover(ind_1990_2022[[13]],nbr2.3)
ind_1990_2022[[13]] <- cover(ind_1990_2022[[13]],nbr1.3)

ind_1990_2022[[14]] <- cover(ind_1990_2022[[14]],nbr3.4)
ind_1990_2022[[14]] <- cover(ind_1990_2022[[14]],nbr2.4)
ind_1990_2022[[14]] <- cover(ind_1990_2022[[14]],nbr1.4)


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


ind_1990_2022[[2]] <- tmp_index_count






writeRaster(ind_1990_2022, "Desktop/ind_1990_2022_new_first","GTiff",  overwrite=T)





combined_multi_years <- stack("outputs/r_1990_2022.tif")
seperate_indices <- stack("outputs/ind_1990_2022.tif")[[c(-15,-16)]]


names(combined_multi_years) <- c("loss_year_1","count_loss_events","loss_year_2","loss_year_3")

names(seperate_indices) <- c("loss_year", "count_indices",
                             "NDVI_year", "NDVI_mag", "NDVI_dur", "NDVI_preval",
                             "TCW_year", "TCW_mag", "TCW_dur", "TCW_preval",
                             "NBR_year", "NBR_mag", "NBR_dur", "NBR_preval")  


writeRaster(combined_multi_years, "outputs/final/combined_multi_years","GTiff",  overwrite=T)
writeRaster(seperate_indices, "outputs/final/seperate_indices","GTiff",  overwrite=T)








seperate_indices <- stack("Desktop/ind_1990_2022_new_first.tif")[[c(-15,-16)]]
loss_newest_first <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/detect_alb_(12_03).tif")[[1]]

writeRaster(seperate_indices, "Desktop/seperate_indices_new_first_04_04","GTiff",  overwrite=T)







albania_raw <- stack("/Users/clemens/Desktop/Albania_Thesis/data/own_rasters/albania_country_blank_raster.tif")

alb_ext <- readOGR("/Users/clemens/Desktop/Albania_Thesis/data/shp/OSM/administrative/albania_country_border.shp")
alb_ext <- extent(alb_ext)

forest_base <- stack("Desktop/Albania_Thesis/data/01_final_results_rasters/forest_albania_90_22_new.tif")[[1]]




albania <- crop(albania_raw, alb_ext)
albania[albania == 0] <- NA
plot(albania)


forest_albania <- crop(forest_base, albania)
forest_albania <- albania*forest_albania
forest_albania[forest_albania == 0] <- NA
plot(forest_albania)

plot(forest_base)


sep_ind_alb <- crop(seperate_indices, albania)
sep_ind_alb <- forest_albania*sep_ind_alb


sep_ind_alb[[1]] <- loss_newest_first


writeRaster(sep_ind_alb, "Desktop/sep_ind_alb_loss_newest_first(04_04)","GTiff",  overwrite=T)







