
library(caret)
library(randomForest)
library(tree)
library(CAST)
library(raster)


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

# Demonstration of what a random forest model is -------------
treeModel <- tree(formula = as.factor(state)~., data = train)
plot(treeModel)
text(treeModel)

# Train a random forest model

rfModel = caret::train(x = train[,1:14], y = train$state, method = "rf", tuneLength = 3)
rfModel

varImp(rfModel)
plot(varImp(rfModel))

saveRDS(rfModel, "data/run/rfModel_forest_health.RDS")

# prediction

# load the previously created indice stack
rgbInd = stack("data/run/2020_09_02_rgb_indices.grd")
names(rgbInd)

# classify the whole scene into healthy and sick trees
prediction = raster::predict(object = rgbInd, rfModel)
prediction
plot(prediction)
writeRaster(prediction, "data/run/2020_09_02_tree_health.grd")



# validation of the model

# classify the left out test data
test$prediction = stats::predict(object = rfModel, test)

# confusion matrix
cm = table(test$state, test$prediction)
caret::confusionMatrix(cm)

