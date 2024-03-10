from flask import Flask, request, jsonify
import pickle
# from pyBKT.models import Model

# Load the pickled model
with open("model.pkl", "rb") as model_file:
    model = pickle.load(model_file)

app = Flask(__name__)


def map_to_category(value):
    if value <= 0.70:
        return "easy"
    elif 0.70 < value <= 0.85:
        return "medium"
    else:
        return "hard"


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()

    # Extract parameters from the JSON input
    semantic_score = data["semantic_score"]
    literal_score = data["literal_score"]
    time_taken = data["time_taken"]

    # Perform any additional processing if needed

    # Make predictions using the loaded model
    predictions = model.predict([[semantic_score, literal_score, time_taken]])

    # Map predictions to categories
    mapped_predictions = [map_to_category(value) for value in predictions]

    return jsonify({"result": mapped_predictions})


if __name__ == "__main__":
    app.run(debug=True)
