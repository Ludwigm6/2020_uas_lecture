library(raster)

# load rgb raster data

rgb = stack("data/rgb/2020_09_02_orthomosaic.tif")
rgb

# have a look
plot(rgb)
plotRGB(rgb)

# reduce spatial resolution
rgb = aggregate(rgb, fact = 2, fun = mean)
rgb

# calculate spectral indices

rgbInd = Rsenal2::rgbIndices(rgb)

rgbInd$SR1 = rgb[[1]] / rgb[[2]]
rgbInd$SR2 = rgb[[1]] / rgb[[3]]
rgbInd$SR3 = rgb[[2]] / rgb[[3]]

plot(rgbInd)

# save the results
writeRaster(rgbInd, "data/run/2020_09_02_rgb_indices.grd")
