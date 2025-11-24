## ========================================================
## Project: Drought Detection Using Machine Learning (Random Forest + SMOTE)
## Description:
##   This script processes historical weather data from multiple CSV files,
##   defines drought events based on the 10th percentile of precipitation,
##   applies SMOTE to balance class distribution, trains a Random Forest
##   classifier, adjusts classification thresholds to tune sensitivity,
##   and evaluates model performance on unseen test data.
## ========================================================

##_ Set up of environment------------

install.packages('tidyverse')
install.packages('caret')
install.packages('randomForest')
install.packages('smotefamily')

library(tidyverse)
library(caret)
library(randomForest)
library(smotefamily)

##_ Load and modification of data files------------

path_folder <- '../data/datasets'
file_list <- list.files(path = path_folder, pattern = '*.csv', full.names = TRUE)

combined_data <- file_list %>%
  map_dfr(~ read_csv(.x, col_types = cols(.default = "c")))
# Combination of all .csv files into one data frame, reading the columns as characters

combined_data <- combined_data %>%
  mutate(
    Tm = as.numeric(Tm),
    Tx = as.numeric(Tx),
    Tn = as.numeric(Tn),
    P = as.numeric(P),
    HDD = as.numeric(HDD),
    CDD = as.numeric(CDD)
  )
# Convert the columns of interest into numeric

combined_data <- combined_data %>%
  select(Tm, Tx, Tn, P, HDD, CDD, Long, Lat, Stn_Name) %>%
  na.omit()
# Filter out irrelevant columns and ensure there are no NA values in the new data set

##_ Machine learning (ML)------------

##__ Data labeling and splitting------------

precip_threshold <- quantile(combined_data$P, 0.10, na.rm = TRUE)
print(paste("Drought threshold (10%):", precip_threshold))
# Define drought based on 10th percentile of precipitation

data_threshold <- combined_data %>%
  mutate(
    drought = ifelse(P <= precip_threshold, 'yes', 'no'),
    drought = factor(drought)
  )
# # Create drought factor variable ('yes' if precipitation ≤ threshold, else 'no')

set.seed(146)
index_model <- createDataPartition(data_threshold$drought, p = 0.8, list = FALSE)

set_train <- data_threshold[index_model, ]
set_test  <- data_threshold[-index_model, ]
# Split data set into training and testing sets (80% vs 20%, respectively)

##__ Prepare training data for SMOTE ------------

train_data_numeric <- set_train %>%
  select(where(is.numeric), drought)
# Create a new data set that contains all the columns of set_train in numeric form and the column drought

train_data_numeric$drought <- as.factor(train_data_numeric$drought)
# Convert the drought column into a categorical variable (yes/no)

dup_size_needed <- ceiling(sum(train_data_numeric$drought == "no") / 
                             sum(train_data_numeric$drought == "yes")) - 1
print(paste("SMOTE dup_size:", dup_size_needed))
# Calculate how many synthetic drought samples are needed. Done because there is a higher number of 'drought' observations than 'non-drought' observations

# Apply SMOTE for full balancing
smote_output <- SMOTE(
  train_data_numeric[, -which(names(train_data_numeric) == "drought")],
  train_data_numeric$drought,
  K = 5,
  dup_size = dup_size_needed
)
# Generate synthetic minority samples to balance drought vs non-drought classes using SMOTE

set_train_balanced <- smote_output$data
set_train_balanced$drought <- as.factor(set_train_balanced$class)
set_train_balanced$class <- NULL
# Rebuild balanced training dataset with correct 'drought' factor

print("Balanced class distribution:")
print(table(set_train_balanced$drought))
# Confirm balanced number of samples in each drought class

##__ Train Random Forest Model -----------

rf_model <- randomForest(
  drought ~ Tm + Tx + Tn + HDD + CDD,
  data = set_train_balanced,
  importance = TRUE,
  ntree = 500
)
# Train Random Forest model (excluding 'P', 'Long', 'Lat')

rf_probs <- predict(rf_model, newdata = set_test, type = "prob")
# Predict class probabilities on test set

##__ Adjust classification threshold and evaluate ------------

threshold <- 0.3  # You can experiment with this value
pred_threshold <- ifelse(rf_probs[, "yes"] >= threshold, "yes", "no")
pred_threshold <- factor(pred_threshold, levels = levels(set_test$drought))
# Adjust the classification threshold from 0.5 to 0.3 To increase the amount of drought cases detected

output <- confusionMatrix(pred_threshold, set_test$drought)
print(output)
# Generate confusion matrix to assess model performance on the test set


