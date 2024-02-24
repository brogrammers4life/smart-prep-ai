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

def extract_text_from_pdf_url(pdf_url, start=12, end=17):
    # Download the PDF from the URL
    response = requests.get(pdf_url)

    # Check if the request was successful
    if response.status_code == 200:
        # Create a PDF file-like object from the response content
        pdf_file = io.BytesIO(response.content)

        # Create a PDF reader object
        pdf_reader = PyPDF2.PdfReader(pdf_file)

        qa_text = ""

        # Iterate through each page in the PDF
        for page_number in range(start, end):
            page = pdf_reader.pages[page_number]
            page_text = page.extract_text()
            qa_text += page_text + "\n"

        return qa_text
    else:
        # Handle the case when the request fails
        print(f"Failed to download PDF from URL: {pdf_url}")
        return None


def extract_questions_answers(text):
    qa_list = []
    pattern = r"(\d+)\.\s+(.*?)\s+Ans:(.*?)(?=\d+\.|\Z)"
    matches = re.findall(pattern, text, re.DOTALL)

    current_question = None
    current_answer = None
    for match in matches:
        question_number = match[0]
        question = match[1].strip()
        answer = match[2].strip()

        # Check if a new question is encountered
        if question_number != current_question:
            # Append the previous question and answer to the list
            if current_question is not None and current_answer is not None:
                qa = {"question": current_question, "answer": current_answer}
                qa_list.append(qa)

            # Update the current question and answer
            current_question = question
            current_answer = answer
        else:
            # Concatenate the answer to the current answer
            current_answer += " " + answer

    # Append the last question and answer to the list
    if current_question is not None and current_answer is not None:
        qa = {"question": current_question, "answer": current_answer}
        qa_list.append(qa)

    return json.dumps(qa_list)


# Replace with your OpenAI API key
api_key = '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'
openai.api_key = api_key

