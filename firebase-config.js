
// TODO: Replace the following with your app's Firebase project configuration
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "your-auth-domain",
  projectId: "your-project-id",
  storageBucket: "your-storage-bucket",
  messagingSenderId: "your-messaging-sender-id",
  appId: "your-app-id"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();

// Enable offline persistence
db.enablePersistence().catch((err) => {
  if (err.code == 'failed-precondition') {
    // probably multiple tabs open at once
    console.log('persistance failed');
  } else if (err.code == 'unimplemented') {
    // The current browser does not support all of the
    // features required to enable persistence
    console.log('persistance not available');
  }
});

// Use emulator if on localhost
if (window.location.hostname === "localhost") {
  console.log("Connecting to local Firebase emulator");
  db.useEmulator("localhost", 8085);
}
