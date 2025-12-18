# Firebase Google Sign-In Setup Instructions

## Quick Start Guide

Follow these steps to complete the Google Sign-In setup for your Zakoota app.

---

## Step 1: Enable Google Sign-In in Firebase

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your **Zakoota** project
3. Click **Authentication** in the left sidebar
4. Click **Sign-in method** tab
5. Find **Google** in the providers list
6. Click on **Google**
7. Toggle **Enable** to ON
8. Enter a **Project support email** (your email address)
9. Click **Save**

✅ **Done!** Google Sign-In is now enabled.

---

## Step 2: Add SHA Fingerprints (Required for Android)

### Generate Your Fingerprints

Open PowerShell in Windows and run:

```powershell
cd "c:\Users\user\Desktop\Zakoota APP\my_flutter_app\android"
.\gradlew signingReport
```

**Wait for the command to finish.** Look for output like this:

```
Variant: debug
Config: debug
Store: C:\Users\user\.android\debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX...
SHA1: AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD
SHA-256: 11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11
```

**Copy both** the SHA-1 and SHA-256 values.

---

### Add Fingerprints to Firebase

1. Go back to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the **gear icon** ⚙️ → **Project settings**
4. Scroll down to **Your apps** section
5. Find your Android app (should show package name: `com.example.my_flutter_app` or similar)
6. Click **Add fingerprint**
7. Paste your **SHA-1** value
8. Click **Add fingerprint** again
9. Paste your **SHA-256** value

✅ **Done!** Your app is now authorized.

---

## Step 3: Test the Implementation

### Run Your App

In your project directory, run:

```bash
flutter run
```

### Test Client Signup

1. Navigate to the **Client Signup** screen
2. Click **"Continue with Google"**
3. A Google account picker should appear
4. Select your Google account
5. Grant permissions
6. You should see: **"Google Sign-In successful! Redirecting to Login."**

### Verify in Firestore

1. Go to Firebase Console → **Firestore Database**
2. Look for `clients` collection
3. You should see a new document with your Google account data

### Test Lawyer Signup

1. Navigate to the **Lawyer Signup** screen
2. Click **"Continue with Google"**
3. Select a **different** Google account (or use the same one)
4. You should see success message
5. Check Firestore → `lawyers` collection for the new document

---

## Common Issues

### Issue: "PlatformException: sign_in_failed"

**Cause:** SHA fingerprints not added to Firebase

**Solution:**
- Make sure you completed Step 2
- Wait a few minutes for Firebase to update
- Restart your app

---

### Issue: "ApiException: 10"

**Cause:** Google Sign-In not enabled in Firebase Console

**Solution:**
- Complete Step 1
- Make sure the toggle is ON and you clicked Save

---

### Issue: Nothing happens when I click the button

**Cause:** App needs to be rebuilt

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

---

## Configuration Checklist

Use this checklist to ensure everything is set up correctly:

- [ ] Google Sign-In enabled in Firebase Console
- [ ] Project support email added
- [ ] Clicked "Save" in Firebase Console
- [ ] Generated SHA-1 fingerprint
- [ ] Generated SHA-256 fingerprint
- [ ] Added SHA-1 to Firebase Project Settings
- [ ] Added SHA-256 to Firebase Project Settings
- [ ] Ran `flutter run` to test
- [ ] Tested Client Signup with Google
- [ ] Tested Lawyer Signup with Google
- [ ] Verified data in Firestore

---

## For Production Release

When you're ready to release your app to the Play Store:

1. Generate your release keystore (if you haven't already)
2. Get the release SHA-1 and SHA-256:
   ```bash
   keytool -list -v -keystore your-release-key.keystore -alias your-key-alias
   ```
3. Add the **release SHA fingerprints** to Firebase (same as Step 2)
4. Download updated `google-services.json` and replace in your project

---

## Need Help?

If you encounter any issues not covered here, let me know and I'll help troubleshoot!

**Firebase Console:** https://console.firebase.google.com/
**Your Project:** Check your Firebase project name
