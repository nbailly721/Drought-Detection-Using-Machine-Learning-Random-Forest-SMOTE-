                                                                   ####Drought Prediction Using Machine Learning (2022–2024 Weather Data)####

**Description**

This project uses weather data from 2022 to 2024 to predict drought conditions using a Random Forest classifier. The workflow integrates tidyverse for data wrangling, SMOTE for handling class imbalance, and caret/randomForest for model training and evaluation. The pipeline includes data preprocessing, feature selection, class balancing, model training, threshold tuning, and performance evaluation, providing actionable drought predictions.

**Workflow Overview**

    1. Data Preparation (R Script)

Load monthly weather CSV files for 2022–2024.

Clean and combine all files into a single data frame.

Convert key weather features (e.g., temperature, precipitation) to numeric.

Select relevant variables (Tm, Tx, Tn, P, HDD, CDD, etc.) and remove missing data rows.

     2. Drought Labeling

Define drought as precipitation in the lowest 10th percentile.

Generate a binary drought label (yes/no) using ifelse().

Split dataset: 80% training / 20% testing.

      3. SMOTE Oversampling

Address class imbalance (few drought cases) using SMOTE.

Generate synthetic drought samples to balance training data.

Prevent model bias toward the majority "no drought" class.

      4. Model Training and Evaluation

Train a Random Forest classifier on selected features (exclude geographic features like Long/Lat).

Adjust classification threshold to 0.3 to prioritize drought detection.

Evaluate model using a confusion matrix and calculate performance metrics.

**Datasets Used**

Monthly CSV files (2022–2024) from:
Environment Canada Climate Data

Each file contains:

Daily mean temperature (Tm)

Max/min temperatures (Tx, Tn)

Precipitation (P)

Cooling/heating degree days (CDD, HDD)

Latitude, longitude, and station names

**Packages Used**

R Packages

tidyverse – Data wrangling and plotting

caret – ML preprocessing and partitioning

randomForest – Random Forest modeling

smotefamily – Class balancing via SMOTE

**Key Results**

`confusion_matrix.csv` – Confusion matrix for drought predictions

`performance_matrix.csv` – Evaluation metrics (accuracy, sensitivity, etc.)

**Files in This Repository**

drought_prediction.R – Full R script covering data preparation, SMOTE balancing, model training, threshold adjustment, and evaluation

**Important Notes**

SMOTE was crucial due to class imbalance (few drought cases).

Adjusting the classification threshold improved sensitivity to droughts at some cost to precision.

Demonstrates a complete ML pipeline: data preprocessing → label engineering → class balancing → model training → threshold tuning → evaluation.

Pipeline is adaptable to other regions, time periods, or updated weather datasets.

**Real-World Relevance**

Prediction on new data: Apply model to predict drought likelihood for new weather datasets.

Climate monitoring systems: Integrate into weather platforms for early drought warnings, supporting agriculture and water management.

Retraining: Reapply the pipeline to future years or other regions to maintain accuracy.

Adaptability: Can be localized for different climates by replacing input datasets.

Feature analysis: Random Forest feature importance identifies key weather variables driving drought risk.
