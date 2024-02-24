# # -*- coding: utf-8 -*-
# """Copy of pyBKT LAK Workshop.ipynb

# Automatically generated by Colaboratory.

# Original file is located at
#     https://colab.research.google.com/drive/1d0DA6bXBIuo6wTUNz4qgm7K10IUF0t3u

# # pyBKT Model Workshop - LAK

# This is a tutorial that explores the basic features of pyBKT, ranging from model creation, fitting, prediction, evaluation and crossvalidation. We will be using the skills contained within the Cognitive Tutor and 2009-2010 Assistments datasets to demonstrate these features.
# """

# # Install pyBKT from pip!


# # Import all required packages including pyBKT.models.Model!
# import numpy as np
# import pandas as pd
# from pyBKT.models import Model
# import pickle

# """### Basic Model Creation and Evaluation

# Initialize the model with an optional seed and number of fit initializations. Note that the Model constructor supports many more parameters such as the model variant (which can be modified at fit time), whether to parallelize computation, and more.
# """

# # Note that the seed chosen is so we can consistently
# # replicate the results and avoid as much randomness
# # as possible.
# model = Model(seed=42, num_fits=1, parallel=True)

# """Fetch Assistments and CognitiveTutor data to the local disk. We will be using these datasets, but you can use any that you see fit when you use pyBKT. The data formats accepted by pyBKT are comma separated and tab separated files (note that pyBKT will automatically infer which is passed in). Note that the correctness is given by -1 (no response), 0 (incorrect), or 1 (correct)."""

# model.fetch_dataset(
#     "https://raw.githubusercontent.com/CAHLR/pyBKT-examples/master/data/as.csv", "."
# )
# model.fetch_dataset(
#     "https://raw.githubusercontent.com/CAHLR/pyBKT-examples/master/data/ct.csv", "."
# )

# """We open the given datasets and explore them before using them to fit BKT models using pyBKT. Note that the column names describing the student ID, the problem name, the response's correctness and skill name all differ between the two datasets."""

# ct_df = pd.read_csv("ct.csv", encoding="latin")
# print(ct_df.columns)
# ct_df.head(5)

# as_df = pd.read_csv("as.csv", encoding="latin", low_memory=False)
# print(as_df.columns)
# as_df.head(5)

# """We can fit a simple BKT model with the `fit` method for the Model class. In this case, we will fit a BKT model to every skill in the Cognitive Tutor dataset separately. Note that when skill(s) are not specified, it trains a separate model on all skills by default.

# We can either specify a data path (location of a file) or the Pandas DataFrame containing the data.
# """

# model.fit(data_path="ct.csv")

# """We can train on multiple skills specified by a list of skill names or a
# REGEX match for each skill using the `skills` parameter. We demonstrate the usage of that below. In this case, we fit on all strings containing fraction.
# """

# model.fit(
#     data_path="ct.csv",
#     skills=[
#         "Plot terminating proper fraction",
#         "Calculate total in proportion with fractions",
#     ],
# )
# print("Fitted Skills:\n%s" % "\n".join(model.coef_.keys()))

# """Evaluate on the trained skills for any test data located in a Pandas DataFrame or in a file. In this case, we will just use training data, so this will display the training error. Note that the default metric displayed is RMSE. pyBKT supports AUC, RMSE, and accuracy
# as metrics by default.

# However, you can define your own custom metric as well!
# """

# # Evaluate with the default RMSE then specify AUC.
# model.fit(data_path="ct.csv")
# training_rmse = model.evaluate(data=ct_df)
# training_auc = model.evaluate(data_path="ct.csv", metric="auc")


# training_mae = model.evaluate(data_path="ct.csv", metric=mae)

# """### Model Prediction

# pyBKT can return predictions on a test set given a Pandas DataFrame or a file conaining test data. If pyBKT is asked for predictions on skills for which it has not trained a model, it will output a best effort guess of 0.5 for both the correct and state predictions.

# We will be using the training dataset again for testing purposes.
# """

# # Note again that the REGEX expression below trains BKT models on all
# # skills containing the word fraction!
# model.fit(data_path="ct.csv", skills=".*fraction.*")
# preds = model.predict(data_path="ct.csv")
# preds[
#     [
#         "Anon Student Id",
#         "KC(Default)",
#         "Correct First Attempt",
#         "correct_predictions",
#         "state_predictions",
#     ]
# ].head(5)


# pickle.dump(model, open("model.pkl", "wb"))


# Import the necessary packages
import numpy as np
import pandas as pd
from pyBKT.models import Model
import pickle

# Initialize the model with an optional seed and number of fit initializations
model = Model(seed=42, num_fits=1, parallel=True)

# Fetch Assistments and CognitiveTutor data to the local disk
model.fetch_dataset(
    "https://raw.githubusercontent.com/CAHLR/pyBKT-examples/master/data/as.csv", "."
)
model.fetch_dataset(
    "https://raw.githubusercontent.com/CAHLR/pyBKT-examples/master/data/ct.csv", "."
)

# Read the datasets
ct_df = pd.read_csv("ct.csv", encoding="latin")
as_df = pd.read_csv("as.csv", encoding="latin", low_memory=False)

# Fit a BKT model to the Cognitive Tutor dataset
model.fit(data_path="ct.csv")

# Fit a BKT model to specific skills in the Cognitive Tutor dataset
model.fit(
    data_path="ct.csv",
    skills=[
        "Plot terminating proper fraction",
        "Calculate total in proportion with fractions",
    ],
)

# Evaluate the model with different metrics
model.fit(data_path="ct.csv")
training_rmse = model.evaluate(data=ct_df)
training_auc = model.evaluate(data_path="ct.csv", metric="auc")
training_mae = model.evaluate(data_path="ct.csv", metric="mae")

# Fit BKT models on all skills containing the word "fraction"
model.fit(data_path="ct.csv", skills=".*fraction.*")

# Generate predictions using the model
preds = model.predict(data_path="ct.csv")

# Save the trained model to a pickle file
with open("model.pkl", "wb") as model_file:
    pickle.dump(model, model_file)
