import requests
from PyPDF2 import PdfReader
import os

def extract_text_from_pdf(url, start_page=None, end_page=None):
    # Download PDF file
    response = requests.get(url)
    with open("./utils/curriculum.pdf", "wb") as pdf_file:
        pdf_file.write(response.content)

    # Open the PDF file and extract text
    text = ""
    with open("./utils/curriculum.pdf", "rb") as pdf_file:
        pdf_reader = PdfReader(pdf_file)

        # If start_page or end_page is None, set to the first and last page, respectively
        start_page = start_page or 0
        num_pages = len(pdf_reader.pages)

        # Ensure start_page and end_page are within valid range
        start_page = max(0, min(start_page, num_pages - 1))
        end_page = end_page or num_pages - 1
        end_page = max(start_page, min(end_page, num_pages - 1))

        # Extract text from specified range of pages
        for page_number in range(start_page, end_page + 1):
            page = pdf_reader.pages[page_number]
            text += page.extract_text()

    # Delete the temporary PDF file
    os.remove("./utils/curriculum.pdf")
    return text


# # Example usage with your provided URL
# pdf_url = "https://firebasestorage.googleapis.com/v0/b/iitb-brogrammers.appspot.com/o/cirriculumPdf%2Fsyllabus.pdf?alt=media&token=9c34aba0-6057-491f-9f27-97c5d581e91c"
# start_page_number = 1
# end_page_number = 5

# extracted_text = extract_text_from_pdf(pdf_url, start_page=start_page_number, end_page=end_page_number)
# print(extracted_text)
