# nice map

library(RStoolbox)
rgb = stack("data/rgb/2020_09_02_orthomosaic.tif")
classification = raster("data/run/2020_09_02_tree_health.grd")

# set healthy tree pixel to NA so that it won't display on the map
classification[classification == 1] = NA


# create map with RStoolbox
# RGB overlayed with classification

ggRGB(rgb, r = 1, g = 2, b = 3, maxpixels = 1000000)+
  scale_x_continuous(name = NULL, expand = c(0,0))+
  scale_y_continuous(name = NULL, expand = c(0,0))+
  ggR(classification, ggLayer = TRUE, alpha = 0.65, hue = 0.1, sat = 1)+
  theme(axis.text.y = element_text(angle = 90, hjust = 0.5), panel.background = element_blank(),
        panel.grid = element_line(color = "grey70"), panel.grid.minor = element_blank())




