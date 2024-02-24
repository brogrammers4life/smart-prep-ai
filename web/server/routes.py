from flask import Flask, request, jsonify
import json
import os
from flask_cors import CORS
from functions import *
import json
import pickle
import pandas as pd

# Load the pickled model
with open("model.pkl", "rb") as model_file:
    model = pickle.load(model_file)

app = Flask(__name__)


@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()
        input_data = pd.DataFrame([data])

        # Assuming 'semantic_score', 'literal_score', 'time_taken' are the features
        print("input_data", input_data[[
              "semantic_score", "literal_score", "time_taken"]])

        prediction = model.predict(
            input_data[["semantic_score", "literal_score", "time_taken"]]
        )

        # Further processing as per your requirement
        filtered_df = prediction[prediction["state_predictions"] >= 0.65]
        top_5_predictions = filtered_df.head(5)
        list1 = top_5_predictions["state_predictions"].tolist()

        def map_to_category(value):
            if value <= 0.70:
                return "easy"
            elif 0.70 < value <= 0.85:
                return "medium"
            else:
                return "hard"

        mapped_list = [map_to_category(value) for value in list1]

        result = {"predictions": list1, "categories": mapped_list}

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)})


@app.route("/predict_demo", methods=["POST"])
def predict_demo():
    try:

        result = {"predictions": ['medium', 'hard', 'hard', 'medium', 'easy']}

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)})


if __name__ == "__main__":
    app.run(debug=True, port=5002)
