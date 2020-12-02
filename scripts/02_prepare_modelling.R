library(raster)
library(sf)
library(mapview)

# load previous spectral indices
rgbInd = stack("data/run/2020_09_02_rgb_indices.grd")
names(rgbInd)


# load training polygons
tree_health = st_read("data/areas/tree_health.gpkg")
table(tree_health$state)

plot(rgbInd, 12)
plot(tree_health, add = TRUE)


?extract
rgbIndEx = extract(rgbInd, tree_health, df = TRUE)

lut = data.frame(ID = seq(20), state = tree_health$state)

rgbIndEx = merge(rgbIndEx, lut, by = "ID")

saveRDS(rgbIndEx, "data/run/training_data.RDS")

