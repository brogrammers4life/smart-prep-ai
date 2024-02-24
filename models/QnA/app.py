from flask import Flask, request, jsonify
import requests
import PyPDF2
import io
import re
import json
from PIL import Image
from io import BytesIO
import pytesseract
import openai
import numpy as np
import pandas as pd
from pyBKT.models import Model
import pickle


from functions import *

app = Flask(__name__)


@app.route("/model/api/generate_questions", methods=["POST"])
def extract_qa():
    data = request.get_json()

    start = request.args.get("start", type=int)
    end = request.args.get("end", type=int)
    print(start)
    print(end)
    if "pdf_url" in data:
        pdf_url = data["pdf_url"]
        resulting_text = extract_text_from_pdf_url(pdf_url, start, end)

        if resulting_text:
            clean_text = resulting_text.replace("\n", "")
            output_json = extract_questions_answers(clean_text)

            return jsonify({"qa_data": json.loads(output_json)})
        else:
            return jsonify({"error": "Failed to download PDF from URL"}), 400
    else:
        return jsonify({"error": "PDF URL not provided in request"}), 400


# @app.route("/model/api/generate_questions", methods=["POST"])
# def extract_qa():
#     data = request.get_json()

#     if "pdf_url" in data:
#         pdf_url = data["pdf_url"]
#         resulting_text = extract_text_from_pdf_url(pdf_url)

#         if resulting_text:
#             clean_text = resulting_text.replace("\n", "")
#             output_json = extract_questions_answers(clean_text)

#             return jsonify({"qa_data": json.loads(output_json)})
#         else:
#             return jsonify({"error": "Failed to download PDF from URL"}), 400
#     else:
#         return jsonify({"error": "PDF URL not provided in request"}), 400

# Path to your Tesseract executable
pytesseract.pytesseract.tesseract_cmd = r"C:/Program Files/Tesseract-OCR/tesseract.exe"


from flask import Flask, request, jsonify
import requests
from PIL import Image
from io import BytesIO
import pytesseract
import openai


@app.route("/model/api/extract_text", methods=["POST"])
def extract_text_from_image():
    try:
        # Get the Firebase image URL from the request JSON
        data = request.get_json()
        firebase_image_url = data.get("image_url")

        # Download the image from the Firebase URL
        response = requests.get(firebase_image_url)
        img = Image.open(BytesIO(response.content))

        # Perform OCR using pytesseract
        extracted_text = pytesseract.image_to_string(img)

        return jsonify({"extracted_text": extracted_text})
    except Exception as e:
        return jsonify({"error": str(e)})


@app.route("/model/api/extract_subject_and_marks", methods=["POST"])
def extract_subjects_and_marks():
    try:
        # Get the Firebase image URL from the request JSON
        data = request.get_json()
        firebase_image_url = data.get("image_url")

        # Download the image from the Firebase URL
        response = requests.get(firebase_image_url)
        img = Image.open(BytesIO(response.content))

        # Perform OCR using pytesseract
        extracted_text = pytesseract.image_to_string(img)

        # Prepare the prompt for GPT-3
        prompt = f"Extract subjects and marks from the following text:\n{extracted_text}\nSubjects and Marks:"

        # Generate response from GPT-3
        response = openai.Completion.create(
            engine="text-davinci-002",
            prompt=prompt,
            max_tokens=50,  # Adjust as needed to capture the required information
        )

        extracted_data = response.choices[0].text.strip()
        return jsonify({"extracted_data": extracted_data})
    except Exception as e:
        return jsonify({"error": str(e)})


# Load the pickled model
with open("bkt_model.pkl", "rb") as model_file:
    model = pickle.load(model_file)


@app.route("/predict", methods=["POST"])
def predict():
    data = request.json
    kc_default = data["KC(Default)"]
    correct_first_attempt = data["Correct First Attempt"]
    print(kc_default, correct_first_attempt)
    # Prepare the data for prediction
    data = pd.DataFrame(
        {"KC(Default)": kc_default, "Correct First Attempt": correct_first_attempt}
    )
    print(data)

    # Make predictions
    predictions = model.predict(data)
    print("predictions " , predictions)

    return jsonify(
        {
            "Correct Predictions": predictions["correct_predictions"].values[0],
            "State Predictions": predictions["state_predictions"].values[0],
        }
    )


if __name__ == "__main__":
    app.run(debug=True)
