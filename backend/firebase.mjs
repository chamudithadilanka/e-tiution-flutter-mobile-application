// firebase.mjs
import admin from "firebase-admin";
import serviceAccount from "./firebase-service-account.json"; // Make sure this file is in the root directory

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

export default admin;
