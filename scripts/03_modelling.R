
library(caret)
library(randomForest)
library(CAST)


rgbIndEx = readRDS("data/run/training_data.RDS")
head(rgbIndEx)

rgbIndEx$ID = NULL
rgbIndEx = na.omit(rgbIndEx)

# split in train and test
set.seed(5)
train_id = caret::createDataPartition(rgbIndEx$state, times = 1, p = 0.7, list = FALSE)

train = rgbIndEx[train_id,]
test = rgbIndEx[-train_id,]


trCtl = trainControl(method = "cv")


rfModel = caret::train(x = train[,1:14], y = train$state, method = "rf", tuneLength = 3, trControl = trCtl)
rfModel

# prediction

library(raster)

rgbInd = stack("data/run/2020_09_02_rgb_indices.grd")
names(rgbInd)

prediction = raster::predict(object = rgbInd, rfModel)
prediction
plot(prediction)

writeRaster(prediction, "data/run/2020_09_02_tree_health.grd")



# validation

test$prediction = stats::predict(object = rfModel, test)


cm = table(test$state, test$prediction)
caret::confusionMatrix(cm)







