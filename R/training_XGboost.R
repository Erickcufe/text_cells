library(caret)
train <- textCells::data_afterWEKA_4Classes
train$PMID <- NULL
train$Class <- factor(train$Class)
test <- textCells::data_test_afterWEKA_4Classes
test$PMID <- NULL
test$Class <- factor(test$Class)

param=param <-  data.frame(nrounds=c(11), max_depth = c(3),eta =c(0.5),gamma=c(1),
                           colsample_bytree=c(0.9),min_child_weight=c(1),subsample=c(1))

#PARA HACER CROSS VALIDATION
train_control <- trainControl(method="cv", number=10, classProbs=T,savePredictions = T)
##PARA HACER BOOTSTRAP
#train_control <- trainControl(method="boot", number=100)
############################Paralelizaci??n#######################

require(doParallel)
#library(doParallel)
cl <- makeCluster(detectCores())
registerDoParallel(cl)

################################clasificaci??n######################################
t <- proc.time() # Inicia el cron??metro
# NUESTRO CODIGO

model_xgb <- train(Class ~ .,
                   data = train,
                   method = "xgbTree",
                   trControl = trainControl(method = "none"),tuneGrid=param
                   ,na.action=na.exclude)

proc.time()-t    # Detiene el cron??metro
stopCluster(cl)
#####################importancia de las variables####################
importance <- varImp(model_xgb, scale = TRUE)
plot(importance,30)
######################modelo final#####################
print(model_xgb)
######################prediccion y metricas de evaluacion########################
pred <- predict(model_xgb,  test)

confusionMatrix(pred,test$Class)
results <- confusionMatrix(pred,test$Class)
