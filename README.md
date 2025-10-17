                                                                   ####Drought Prediction Using Machine Learning (2022–2024 Weather Data)####
This project uses weather data from 2022 to 2024 to predict drought conditions using a Random Forest classifier. It combines tidyverse for data wrangling, SMOTE for handling class imbalance, and caret/randomForest for training and evaluating the machine learning model.

🖥️ Workflow Overview
1. Data Preparation (R Script)

Load monthly weather data in .csv format for the years 2022–2024.

Clean and combine all CSV files into a single data frame.

Convert key features to numeric (e.g., temperature, precipitation).

Select relevant weather attributes (Tm, Tx, Tn, P, HDD, CDD, etc.) and remove rows with missing data.

2. Drought Labeling

Drought is defined as precipitation values in the lowest 10th percentile.

A binary drought label (yes/no) is created using the ifelse() function.

The data is then split into 80% training and 20% testing sets.

3. SMOTE Oversampling

The dataset had significant class imbalance — far fewer "drought" cases than "no drought".

SMOTE (Synthetic Minority Oversampling Technique) was used to synthetically generate new drought examples.

This ensured the training set was balanced, preventing bias in the model.

4. Model Training and Evaluation

A Random Forest classifier was trained using only selected features (excluding geographic ones like Long, Lat).

The classification threshold was adjusted to 0.3 (instead of the default 0.5) to prioritize detecting droughts.

The model was evaluated using a confusion matrix, showing performance across drought/no-drought classes.

📁 Dataset

Monthly .csv files from 2022 to 2024 (source: https://climate.meteo.gc.ca/prods_servs/cdn_climate_summary_e.html?utm_source).

Each file contains weather data including:

Daily mean temperature (Tm)

Max/min temperatures (Tx, Tn)

Precipitation (P)

Cooling/heating degree days (CDD, HDD)

Latitude, longitude, and station names.

🔧 Tools & Packages

R Packages:

tidyverse – Data manipulation and plotting

caret – ML preprocessing and data partitioning

randomForest – Random Forest modeling

smotefamily – Class balancing via SMOTE

📊 Key Results

Balanced training dataset created using SMOTE with calculated duplication size.

Classification threshold tuning allowed better detection of minority drought class.

Final model output included:

Class probabilities for test data

Confusion matrix to evaluate accuracy, precision, recall, etc.

📂 Files

drought_prediction.R: Full R script for data preparation, SMOTE balancing, model training, and evaluation.

🧠 Notes

The use of SMOTE was crucial due to imbalanced class labels (few drought cases).

Adjusting the classification threshold allowed better sensitivity to drought conditions, even at the cost of some precision.

This pipeline demonstrates a typical ML flow: data preprocessing → label engineering → class balancing → model training → threshold tuning → evaluation.

This approach can be adapted to other regions or time periods by substituting in relevant weather data.

🔁 How This Model Can Be Used

This drought prediction model can be reused in the following ways:

🔁 How This Model Can Be Used

This drought prediction model can be reused in the following ways:

- **Prediction on New Data**:  
  Any new dataset containing the same weather features (`Tm`, `Tx`, `Tn`, `HDD`, `CDD`) can be passed through the trained model to predict drought likelihood.

- **Climate Monitoring Systems**:  
  The model can be integrated into weather monitoring platforms to issue early drought warnings for agricultural planning or water resource management.

- **Retraining with New Data**:  
  The same pipeline (including SMOTE balancing and threshold tuning) can be applied to updated data (e.g. future years or different regions) to continuously improve accuracy.

- **Adaptability to Other Regions**:  
  By replacing the dataset with weather data from other regions, the model can be localized to different climates — as long as the core features remain the same.

- **Feature Analysis**:  
  The feature importance from the Random Forest model helps determine which weather variables are most influential in drought prediction.
