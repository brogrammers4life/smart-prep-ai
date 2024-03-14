from flask import Flask, request, jsonify
import requests
import PyPDF2
import io
import re
import json
import google.generativeai as genai
import os
from pathlib import Path
from sentence_transformers import SentenceTransformer
from scipy import spatial
import Levenshtein
import json
from pathlib import Path
from os import environ

# Load environment variables from .env
FLASK_GENAI_API_KEY = environ.get('FLASK_GENAI_API_KEY')
genai.configure(api_key=FLASK_GENAI_API_KEY)


def handwritten_to_text(image_url):
    # Set up the model
    generation_config = {
        "temperature": 0.4,
        "top_p": 1,
        "top_k": 32,
        "max_output_tokens": 4096,
    }

    safety_settings = [
        {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
    ]

    model = genai.GenerativeModel(model_name="gemini-pro-vision",
                                  generation_config=generation_config,
                                  safety_settings=safety_settings)
    response = requests.get(image_url)
    response.raise_for_status()

    image_parts = [
        {
            "mime_type": "image/jpeg",
            "data": response.content,
        },
    ]

    prompt_parts = [
        image_parts[0],
        "extract text from the given image"
    ]

    response = model.generate_content(prompt_parts)
    print("response.text", response.text)

    return response.text


def extract_text_from_pdf_url(pdf_url, start, end):
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
        start = int(start)
        end = int(end)
        for page_number in range(start, end):
            page = pdf_reader.pages[page_number]
            page_text = page.extract_text()
            qa_text += page_text + "\n"

        os.remove(pdf_file.name)
        return qa_text
    else:
        # Handle the case when the request fails
        print(f"Failed to download PDF from URL: {pdf_url}")
        return None


def generate_question_answers(text):
    # Set up the model
    print("generating questions and answers")
    # print("open ai key", FLASK_GENAI_API_KEY)
    generation_config = {
        "temperature": 0.4,
        "top_p": 1,
        "top_k": 32,
        "max_output_tokens": 4096,
    }

    safety_settings = [
        {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
    ]

    model = genai.GenerativeModel(model_name="gemini-pro",
                                  generation_config=generation_config,
                                  safety_settings=safety_settings)

    prompt_parts = [
        text,
        "generate 20 questions and answers from the given text in the following json format. it will be an array of objects with question and answer keys. for example: [{'question': 'What is the capital of France?', 'answer': 'Paris', 'difficulty:'easy'}]. dont give any other strings at start or end of the array. just the array of objects. there should be 8 easy questions, 8 medium questions, and 4 hard questions. the difficulty of the question should be based on the complexity of the answer.make the questions such that the answer of 4 questions is one line, 4 questions is 5-10 lines, and 4 questions is more than 10 lines. if the answer is a single sentence, it should be easy. if the answer is of 5 lines, it should be medium. if the answer is a more than 5 lines, it should be hard.  the questions should be unique and not repeated. the questions should be in the form of a question and not a statement. dont generate questions which have one word answers ",

    ]

    response = model.generate_content(prompt_parts)
    print("response", response)

    return response.text


def calculate_semantic_score(og_ans, user_ans):

    sentences = [og_ans, user_ans]
    model = SentenceTransformer('all-mpnet-base-v2')
    embeddings = model.encode(sentences)

    emb1 = embeddings[0]
    emb2 = embeddings[1]

    score = 1 - spatial.distance.cosine(emb1, emb2)
    if score < 0:
        score = 0.01

    return score


def extract_questions_answers_using_regex(text):
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


def calculate_literal_score(og_ans, user_ans):
    distance = Levenshtein.distance(og_ans, user_ans)
    longest = max(len(og_ans), len(user_ans))
    score = 1 - distance/longest
    return score


def get_static_qa():
    with open(Path("./utils/pdf_question_answers.json")) as file:
        data = json.load(file)
    return json.dumps(data)

def help_learn(answer):
    # Set up the model
    generation_config = {
        "temperature": 0.4,
        "top_p": 1,
        "top_k": 32,
        "max_output_tokens": 4096,
    }

    safety_settings = [
        {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
        {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
        },
    ]

    model = genai.GenerativeModel(model_name="gemini-pro",
                                  generation_config=generation_config,
                                  safety_settings=safety_settings)

    prompt_parts = [
        answer,
        "$answer   -> convert this answer to short questions and answer to help me learn in flashcard way and response should be in json format -> [{'text' : 'question', 'type' : 'Question'}, {'text' : 'answer', 'type' : 'Answer'},{'text' : 'question', 'type' : 'Question'}, {'text' : 'answer', 'type' : 'Answer'}] here one object is breakdown question and next Is the answer to that and make sure to only give me the json response- > only json response should be given and no other strings at start or end of the response. ",

    ]

    response = model.generate_content(prompt_parts)

    return response.text
