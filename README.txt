
ODECA - Project bundle (Flutter app + backend + CI workflow)

Contents:
- odeca_app/: Flutter application
- odeca_backend/: Node.js backend for sending order emails
- .github/workflows/build-apk.yml : GitHub Actions to build APK

Quick steps to get APK via GitHub Actions:
1. Create a GitHub repository and push all files from this folder.
2. On GitHub, open Actions > Build Android APK and run the workflow (or push to main).
3. After successful run, download the artifact 'odeca-apk' => app-release.apk

If you want me to run additional steps (deploy backend to Render, configure public backend URL & update app), tell me and I will provide the exact commands and files.
