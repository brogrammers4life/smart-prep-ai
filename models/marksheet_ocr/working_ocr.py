import pytesseract
from PIL import Image
import requests
from io import BytesIO
import openai
import json


def extract_text_from_firebase_image(firebase_image_url):
    try:
        # Download the image from the Firebase URL
        response = requests.get(firebase_image_url)
        img = Image.open(BytesIO(response.content))

        # Perform OCR using pytesseract
        pytesseract.pytesseract.tesseract_cmd = r'C:/Program Files/Tesseract-OCR/tesseract.exe'
        extracted_text = pytesseract.image_to_string(img)

        return extracted_text
    except Exception as e:
        return str(e)


api_key = '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'

def extract_subjects_and_marks_with_openai(extracted_text):
    openai.api_key = api_key

    # Prepare the prompt for GPT-3
    prompt = f"Extract subjects and marks from the following text:\n{extracted_text}\nSubjects and Marks:"

    # Generate response from GPT-3
    response = openai.Completion.create(
        engine="text-davinci-002",
        prompt=prompt,
        max_tokens=50  # Adjust as needed to capture the required information
    )
    print("response")
    print(response.choices[0].text.strip())





if __name__ == "__main__":
    # Provide the Firebase URL of the image you want to extract text from
    firebase_image_url = "https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/marksheets%2Fmarksheet%20jpg.jpg?alt=media&token=82289eea-e1a3-4b85-8a6e-2e32930dea48&_gl=1*12285c*_ga*NTk3NDg4Nzg2LjE2ODk5NjUxNzA.*_ga_CW55HF8NVT*MTY5NjYxOTIzMS42Ny4xLjE2OTY2MjA5NTUuNDEuMC4w"

    # Extract text from the image hosted on Firebase
    extracted_text = extract_text_from_firebase_image(firebase_image_url)

    # Print the extracted text
    print("Extracted Text:")
    print(extracted_text)
        
        
    subjects_and_marks = extract_subjects_and_marks_with_openai(extracted_text)

        
  

  
    

    



    
    

