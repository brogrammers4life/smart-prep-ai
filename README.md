# smartPrep


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
