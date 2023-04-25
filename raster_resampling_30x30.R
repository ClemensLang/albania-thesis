

r1 <- stack("/Users/clemens/Desktop/LT05_L2SP_185032_19900616_20200915_02_T2_QA_PIXEL.TIF")
r2 <- stack("/Users/clemens/Desktop/LT05_L2SP_186030_19900623_20200915_02_T1_QA_PIXEL.TIF")
r3 <- stack("/Users/clemens/Desktop/LT05_L2SP_186031_19900623_20200916_02_T1_QA_RADSAT.TIF")
r4 <- stack("/Users/clemens/Desktop/LT05_L2SP_186032_19900623_20200916_02_T1_QA_PIXEL.TIF")


r5 <- mosaic(r1,r2,r3,r4, fun=sum)


plot(r5)




writeRaster(r5, "/Users/clemens/Desktop/r5","GTiff",  overwrite=T)


r6 <- stack("/Users/clemens/Desktop/r5_4326.tif")


alb_raw_ext <- extent(sep_ind)

r7 <- crop(r6, alb_raw_ext)


plot(r7)

r7[] <- 1


r8 <- resample(albania, r7)

plot(r8)

plot(albania)

r8[!is.na(r8)] <- 1

plot(r8)

writeRaster(r8, "/Users/clemens/Desktop/r8","GTiff",  overwrite=T)


freq(r8)
31694298*30*30


