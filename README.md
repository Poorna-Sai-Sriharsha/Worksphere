# WorkSphere

A professional task management web application built with **Flutter** and **Firebase**. WorkSphere helps you organize work, maintain focus, and get things done — all in a responsive, real-time interface.

---

## Features

- **Firebase Email/Password Authentication** — Secure sign-up and sign-in
- **Google Sign-In** — One-click authentication via Google OAuth
- **Cloud Firestore** — Real-time task sync across sessions
- **User-Isolated Data** — Each user's tasks are completely private (`users/{uid}/tasks/{taskId}`)
- **Real-Time Updates** — Firestore stream listeners for instant UI refresh
- **Task CRUD** — Create, read, update, and delete tasks
- **Task Fields** — Title, description, category, status (Todo / In Progress / Completed), priority (Low / Medium / High)
- **Dashboard Analytics** — Live stats: total tasks, in-progress, completed, high-priority, and progress tracking
- **Responsive Flutter Web UI** — Full sidebar on desktop, bottom navigation on mobile
- **Dark Theme** — Polished professional dark UI

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Web) |
| Language | Dart |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| State Management | Provider (`ChangeNotifier` + `ProxyProvider`) |
| Hosting | Netlify (via GitHub Actions CI/CD) |

---

## Architecture

The application follows a clean layered architecture:

```
UI (screens / widgets)
  └→ Provider (AuthProvider, TaskProvider)
       └→ Repository (TaskRepository)
            └→ Service (AuthService, FirestoreService)
                 └→ Firebase (Auth + Firestore)
```

- **UI Layer** — Screens and widgets consume providers via `context.watch<T>()`
- **Provider Layer** — `AuthProvider` manages auth state; `TaskProvider` manages task stream and CRUD operations. `ChangeNotifierProxyProvider` wires auth → task stream so the correct user's tasks are always loaded.
- **Repository Layer** — `TaskRepository` abstracts Firestore operations, making it easy to swap implementations
- **Service Layer** — `AuthService` and `FirestoreService` talk directly to Firebase SDKs

---

## Firestore Data Structure

```
users/
  {uid}/
    tasks/
      {taskId}/
        title: string
        description: string
        status: "todo" | "inProgress" | "completed"
        priority: "low" | "medium" | "high"
        category: string
        createdAt: timestamp
        updatedAt: timestamp
```

**Account-level isolation**: Every task is stored under `users/{uid}/tasks/`. Firestore Security Rules enforce that an authenticated user can only read and write documents within their own `{uid}` path. No user can access another user's data.

---

## Firebase Security Rules

See [`firestore.rules`](./firestore.rules). Rules enforce:
- Unauthenticated users → **deny all**
- Authenticated users → **only their own** `users/{uid}/tasks` path
- No cross-user read or write access possible

> **Note on Firebase Web API Key**: The API key in `firebase_options.dart` is a client-side configuration value — it is intentionally public and safe to commit for web applications. Firebase security is enforced by Authentication and Firestore Rules, not by the API key.

---

## Local Setup

### Prerequisites

- Flutter SDK (`^3.13.3`) — [Install Flutter](https://docs.flutter.dev/get-started/install)
- A configured Firebase project (see [Firebase Setup](#firebase-setup) below)

### Install dependencies

```bash
flutter pub get
```

### Run locally

```bash
flutter run -d chrome
```

---

## Firebase Setup

This project requires your own Firebase project. The included `firebase_options.dart` connects to the author's Firebase project — **fork users must configure their own**.

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Email/Password** and **Google** sign-in methods in Authentication
3. Create a **Cloud Firestore** database in production mode
4. Add a **Web app** to your Firebase project
5. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
6. Configure your project:
   ```bash
   flutterfire configure
   ```
   This replaces `lib/firebase_options.dart` with your own project's credentials.
7. Deploy Firestore Security Rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

---

## Production Build

```bash
flutter clean
flutter pub get
flutter build web --release
```

Output is generated in `build/web/`.

---

## Netlify Deployment

This project is deployed to Netlify via **GitHub Actions CI/CD**.

### How it works

1. Push to `main` branch triggers the GitHub Actions workflow (`.github/workflows/deploy.yml`)
2. GitHub Actions installs Flutter stable, runs `flutter build web --release`
3. The built `build/web/` directory is deployed to Netlify via the Netlify CLI

### Required GitHub Secrets

Add these in your repository **Settings → Secrets → Actions**:

| Secret | Description |
|---|---|
| `NETLIFY_API_TOKEN` | Your Netlify personal access token |
| `NETLIFY_SITE_ID` | Your Netlify site ID |

### Netlify Build Settings

The `netlify.toml` file configures:
- **Build command**: `bash netlify_build.sh` (installs Flutter and builds)
- **Publish directory**: `build/web`
- **SPA redirect**: All routes → `index.html` (required for Flutter Web)
- **Security headers**: `Cross-Origin-Opener-Policy`, `X-Frame-Options`, `X-Content-Type-Options`

### Important

In the Netlify dashboard, go to **Site settings → Build & deploy → Build settings** and ensure the **Publish directory** is set to `build/web` (with a forward slash, not backslash).

> **Note**: This project has not yet been publicly deployed. The deployment configuration is ready and has been validated locally.

---

## Project Structure

```
lib/
├── app/            App widget and theme configuration
├── auth_gate.dart  Auth state router (logged in → AppShell, else → LoginScreen)
├── core/           Shared utilities (NavigationService)
├── firebase_options.dart  Firebase Web configuration
├── main.dart       Entry point, Provider setup
├── models/         Task model (fromFirestore / toFirestore)
├── providers/      AuthProvider, TaskProvider (state management)
├── repositories/   TaskRepository (abstraction layer)
├── screens/        Auth, Dashboard, Tasks, Settings screens
├── services/       AuthService, FirestoreService (Firebase layer)
└── widgets/        AppShell, AppSidebar, AppTopBar, TaskTable, TaskDialog, StatCard
```

---

## Author

**Poorna Sai Sriharsha** — [GitHub](https://github.com/Poorna-Sai-Sriharsha)
