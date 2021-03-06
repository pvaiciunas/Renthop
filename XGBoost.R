library(jsonlite)
library(xgboost)
library(purrr)
library(dplyr)


# Train data
train_data <- fromJSON(file.choose())
vars <- setdiff(names(train_data), c("photos", "features"))
train_data <- map_at(train_data, vars, unlist) %>% tibble::as_tibble(.)

# Test data
test_data <- fromJSON(file.choose())
vars <- setdiff(names(test_data), c("photos", "features"))
test_data <- map_at(test_data, vars, unlist) %>% tibble::as_tibble(.)

# These will be the features we remove. Come back to these later and see how you could
# transform them into something you could use
word_features = c("building_id", "created", "description", "display_address", "street_address", "features", "listing_id", "manager_id", "photos")

# Add numpics and numfeatures features
train_data$numpics <- data.frame(sapply(train_data$photos, length))[,1]
train_data$numfeatures <- data.frame(sapply(train_data$features, length))[,1]

test_data$numpics <- data.frame(sapply(test_data$photos, length))[,1]
test_data$numfeatures <- data.frame(sapply(test_data$features, length))[,1]


# Remove wordy features out of the dataset
processed_train = train_data
processed_train[word_features] = NULL

processed_test = test_data
processed_test[word_features] = NULL

# Create processed X and processed Y from the training data only
train_X = processed_train
train_X$interest_level = NULL
train_y = processed_train$interest_level
train_y[train_y == "low"] = 0
train_y[train_y == "medium"] = 1
train_y[train_y == "high"] = 2

# Create processed X data for test data
test_X = processed_test

set.seed(100)
pmt = proc.time()
model = xgboost(data = as.matrix(train_X), 
                label = train_y,
                eta = 0.05,
                max_depth = 5, 
                nround=500, 
                subsample = 1,
                colsample_bytree = 0.5,
                seed = 100,
                eval_metric = "merror",
                objective = "multi:softprob",
                num_class = 3,
                missing = NaN,
                silent = 1)
show(proc.time() - pmt)

pred = predict(model,  as.matrix(test_X), missing=NaN)
pred_matrix = matrix(pred, nrow = nrow(test_data), byrow = TRUE)
pred_submission = cbind(test_data$listing_id, pred_matrix)
colnames(pred_submission) = c("listing_id", "low", "medium", "high")
pred_df = as.data.frame(pred_submission)
write.csv(pred_df, "first_submission.csv", row.names = FALSE)
