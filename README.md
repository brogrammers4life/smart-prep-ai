# SmartPrep.ai

**Project Overview 🌐**

Our project, SmartPrep.ai, is a free and inclusive education platform designed to provide personalized learning for students worldwide, addressing the challenges of quality education and the impact of the COVID-19 pandemic. Using natural language processing and knowledge tracing algorithms, the platform serves as a virtual mentor, guiding students through their academic journey and saving valuable time for both students and teachers.

**Project Setup 🚀**

*Challenge:* We aim to tackle UN Sustainable Development Goal 4: Quality Education, focusing on ensuring equitable access to education for all despite socio-economic backgrounds.

*Solution:* SmartPrep.ai leverages adaptive learning, assessing knowledge through AI and ML components, including Dialogflow for a personalized chatbot, Gemini for question generation, TensorFlow for model development, and Bayesian Knowledge Tracing for adaptive learning paths.

**Implementation 🛠️**

*Architecture:* The solution encompasses Flutter for cross-platform app development, Firebase for scalable backend storage, Flask for API development, and AI/ML components such as Dialogflow, Gemini, TensorFlow, and Bayesian Knowledge Tracing.

*Why:* Flutter offers a seamless UI experience, Firebase ensures scalable cloud-based storage, Flask supports lightweight API development, and AI/ML tools empower personalized learning paths and assessments.

**Feedback / Testing / Iteration 🔄**

To enhance user experience, we collaborated with The Barabari Project, receiving valuable feedback:
1. *Challenge:* Students couldn't upload handwritten notes.
   *Solution:* Implemented OCR technology to convert scanned notes to text.

2. *Challenge:* Limited to voice input, hindering written answers.
   *Solution:* Utilized OCR technology for written answers.

3. *Challenge:* Answers had to match textbook content with semantic similarity.
   *Solution:* Added literal and semantic scoring for accurate evaluation.

**One Challenge Faced ⚙️**

The significant challenge was handling large textbook files. We stored them in Firebase storage to avoid repeated uploads. Additionally, heavy PDF extraction on mobiles was addressed by offloading computation to the server using Flask, improving efficiency.

**Success and Completion 🌟**

Our impact on democratizing education is evidenced by increased student engagement and improved academic performance. Analytics tools were employed to refine the platform, ensuring measurable positive outcomes for students, regardless of economic backgrounds.

**Scalability / Next Steps 📈**

*Future Steps:* 
1. Introduce accessibility features for specially-abled students.
2. Add multi-language support.
3. Collaborate with educational institutes for mass promotion.

*Technical Architecture:* The current architecture, leveraging Firebase and Gemini, ensures scalability. However, refining the app for a glitch-free experience and enhancing server robustness on Google Cloud Platform will be crucial for handling increased requests.

*Conclusion:* Our journey involves continuous improvement, accessibility expansion, and strategic partnerships to make SmartPrep.ai a transformative force in global education.

*Embrace Knowledge, Empower Minds! 📚✨*







### Installation : 

### Clone the Repository:

```bash
git clone https://github.com/brogrammers4life/smart-prep-ai
cd smart-prep-ai
```

### Add Dependencies:

```bash
flutter pub get
```

### Setup Firebase for the Project:

1. **Install Firebase CLI:**
   - If you don't have the Firebase CLI installed, you can install it using npm (Node.js package manager). Ensure you have Node.js installed on your machine.

     ```bash
     npm install -g firebase-tools
     ```

2. **Login to Firebase:**
   - Run the following command to log in to your Firebase account:

     ```bash
     firebase login
     ```

3. **Initialize Firebase in the Project:**
   - Navigate to your Flutter project directory and run the following command:

     ```bash
     firebase init
     ```

   - Select the Firebase features you want to use (e.g., Firestore, Hosting) by using the arrow keys to navigate and spacebar to select. Follow the prompts to complete the setup.

### Setup Dialogflow from the Project:



2. **Add Dialogflow Auth File to Assets:**
   - Place the downloaded `dialog_flow_auth.json` file in the `assets` folder of your Flutter project.



Now, your Flutter project should be set up with Firebase and Dialogflow.
