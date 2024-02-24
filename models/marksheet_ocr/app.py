import os
from flask import Flask, request, jsonify
from pdf2image import convert_from_path
import pytesseract
import fitz
import requests
import PyPDF2
app = Flask(__name__)


def extract_text_from_pdf(pdf_url):
    response = requests.get(pdf_url)
    with open("temp.pdf", "wb") as f:
        f.write(response.content)

    extracted_text = ""
    with open("temp.pdf", "rb") as pdf_file:
        pdf_reader = PyPDF2.PdfReader(pdf_file)
        for page_number in range(len(pdf_reader.pages)):
            page = pdf_reader.pages[page_number]
            extracted_text += page.extract_text()

    os.remove("temp.pdf")

    return extracted_text



def classify_subjects(text):
    # Split text into lines
    lines = text.split("\n")

    # Initialize data structures
    student_name = ""
    strong_subjects = {}
    weak_subjects = {}

    # Iterate through lines to extract information
    for line in lines:
        if "Student Name:" in line:
            student_name = line.split("Student Name:")[1].strip()
        elif line.strip():  # Skip empty lines
            subject, marks = line.split(":")
            subject = subject.strip()
            marks = int(marks.strip())

            # Classify subjects as strong or weak based on marks
            if marks >= 75:
                strong_subjects[subject] = marks
            else:
                weak_subjects[subject] = marks

    # Create JSON response
    result = {
        "Student Name": student_name,
        "Strong Subjects": strong_subjects,
        "Weak Subjects": weak_subjects,
    }

    return result


@app.route("/api/analyze-pdf", methods=["GET"])
def running():
    return {"status": "success"}
@app.route('/hello', methods=['GET'])
def hello():
    return 'Hello, World!'


@app.route("/api/analyze-pdf", methods=["POST"])
def analyze_pdf():
    # Receive PDF URL from POST request
    data = request.get_json()
    pdf_url = data.get("pdf_url")

    # Extract text from PDF
    extracted_text = extract_text_from_pdf(pdf_url)

    # Classify subjects and create JSON response
    result = classify_subjects(extracted_text)

    return jsonify(result)


if __name__ == "__main__":
    app.run(debug=True)
