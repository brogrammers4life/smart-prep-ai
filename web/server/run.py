from flask import Flask, request, jsonify
import json
import os
from flask_cors import CORS
from functions import *
import requests
import json
from PIL import Image
from io import BytesIO
import pytesseract
import numpy as np
import pandas as pd
from pyBKT.models import Model
import pickle
import requests

app = Flask(__name__)

CORS(app)
pytesseract.pytesseract.tesseract_cmd = r"C:/Program Files/Tesseract-OCR/tesseract.exe"

# route for home, return hellow world


@app.route('/')
def home():
    return "Hello World"


@app.route("/model/api/generate_questions_from_pdf", methods=["POST"])
def extract_qa():
    data = request.get_json()

    ''''data ={
    "pdf_url": "https://firebasestorage.googleapis.com/v0/b/smartprep-e0c23.appspot.com/o/textbooks%2FGeography_ssc_10_textbook.pdf?alt=media&token=113effc7-326c-4ff4-b8e5-32f4530a8c91",
    "start": "10",
    "end": "20"
        }
    '''
    start = data.get("start")
    end = data.get("end")

    if start is None or end is None:
        return jsonify({"error": "Start and end parameters are required and must be integers"}), 400

    if "pdf_url" in data:
        pdf_url = data["pdf_url"]
        resulting_text = extract_text_from_pdf_url(pdf_url, start, end)
        print("resulting_text", resulting_text)

        if resulting_text:
            clean_text = resulting_text.replace("\n", " ")
            output_json = generate_question_answers(clean_text)
            print("output_json", output_json)

            if not output_json:
                return jsonify({"error": "Empty or invalid JSON response"}), 400

            try:
                return jsonify(json.loads(output_json))
            except json.JSONDecodeError as e:
                return jsonify({"error": f"JSON decoding error: {str(e)}"}), 400
        else:
            return jsonify({"error": "Failed to download PDF from URL"}), 400
    else:
        return jsonify({"error": "PDF URL not provided in the request"}), 400


@app.route("/model/api/generate_questions_from_handwritten", methods=["POST"])
def extract_text_handwritten():
    data = request.get_json()

    ''''data ={'image_url': 'https://firebasestorage.googleapis.com/v0/b/smartprep-e0c23.appspot.com/o/handwritten_note.jpg?alt=media&token=8ab0d107-b686-472e-8024-eaf623ce31c7'}'''
    image_url = data.get("image_url")

    if "image_url" in data:
        # get image from url
        resulting_text = handwritten_to_text(image_url)
        if resulting_text:
            clean_text = resulting_text.replace("\n", " ")
            output_json = generate_question_answers(clean_text)
            print("output_json", output_json)

            if not output_json:
                return jsonify({"error": "Empty or invalid JSON response"}), 400

            try:
                return jsonify(json.loads(output_json))
            except json.JSONDecodeError as e:
                return jsonify({"error": f"JSON decoding error: {str(e)}"}), 400
        else:
            return jsonify({"error": "Failed to download PDF from URL"}), 400
    else:
        return jsonify({"error": "PDF URL not provided in the request"}), 400


@app.route("/model/api/generate_question_answers", methods=["POST"])
def generate_qa():
    data = request.get_json()

    ''''data ={'text': 'The quick brown fox jumps over the lazy dog'}'''

    text = data.get("text")
    if text:
        output_json = generate_question_answers(text)
        return jsonify({"qa_data": json.loads(output_json)})
    else:
        return jsonify({"error": "Text not provided in the request"}), 400


@app.route("/model/api/semantic_score", methods=["POST"])
def get_semantic_score():
    data = request.get_json()

    og_ans = data.get("og_ans")
    user_ans = data.get("user_ans")

    if og_ans and user_ans:

        score = calculate_semantic_score(og_ans, user_ans)
        print("score", score)
        return jsonify({"semantic_score": score})
    else:
        return jsonify({"error": "Original and user answers not provided in the request"}), 400


@app.route("/model/api/literal_score", methods=["POST"])
def get_literal_score():
    data = request.get_json()

    og_ans = data.get("og_ans")
    user_ans = data.get("user_ans")

    if og_ans and user_ans:

        score = calculate_literal_score(og_ans, user_ans)
        print("score", score)
        return jsonify({"literal_score": score})


@app.route("/model/api/generate_question_answers_demo", methods=["POST"])
def generate_qa_static():

    output_json = get_static_qa()
    return jsonify(json.loads(output_json))


@app.route("/model/api/generate_questions_using_regex", methods=["POST"])
def extract_qa_regex():
    data = request.get_json()

    ''''data ={
    "pdf_url": "https://firebasestorage.googleapis.com/v0/b/smartprep-e0c23.appspot.com/o/textbooks%2FGeography_ssc_10_textbook.pdf?alt=media&token=113effc7-326c-4ff4-b8e5-32f4530a8c91",
    "start": "10",
    "end": "20"
        }
    '''
    start = data.get("start")
    end = data.get("end")

    if start is None or end is None:
        return jsonify({"error": "Start and end parameters are required and must be integers"}), 400

    if "pdf_url" in data:
        pdf_url = data["pdf_url"]
        resulting_text = extract_text_from_pdf_url(pdf_url, start, end)

        if resulting_text:
            clean_text = resulting_text.replace("\n", " ")
            print("clean_text", clean_text)
            output_json = extract_questions_answers_using_regex(clean_text)

            return jsonify({"qa_data": json.loads(output_json)})
        else:
            return jsonify({"error": "Failed to download PDF from URL"}), 400
    else:
        return jsonify({"error": "PDF URL not provided in request"}), 400


@app.route("/model/api/predict_demo", methods=["POST"])
def predict_demo():
    try:

        result = {"predictions": ['medium', 'hard', 'hard', 'medium', 'easy']}

        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)})


if __name__ == '__main__':
    app.run(debug=True)
