# 🗂️ WorkSphere — Task Management Application

**A full-stack Flutter Web task management application** built with Firebase Authentication and Cloud Firestore. WorkSphere provides a clean, professional workspace for individuals to create, organize, and track tasks in real-time — featuring Google Sign-In, live Firestore sync, a responsive dark UI, and a complete CI/CD pipeline deploying to Netlify via GitHub Actions.

🌐 **Status:** Production-Ready · Netlify Deployment · Real-Time Cloud Sync

---

## ⚡ Tech Stack & Architecture

| Layer | Technology | Description |
|---|---|---|
| **Framework** | Flutter (Web) | Cross-platform UI toolkit targeting the browser |
| **Language** | Dart | Strongly typed, compiled to JavaScript for web |
| **State Management** | Provider (`ChangeNotifier` + `ProxyProvider`) | Lightweight reactive state — no code generation |
| **Authentication** | Firebase Authentication | Email/Password + Google OAuth Sign-In |
| **Database** | Cloud Firestore | Real-time NoSQL document database |
| **Hosting** | Netlify | Deployed via GitHub Actions CI/CD pipeline |
| **CI/CD** | GitHub Actions | Automated Flutter build + Netlify deploy on push |

---

## ✨ Key Features & Design Highlights

- **Real-Time Task Sync:** Firestore stream listeners push updates instantly to the UI — no polling, no manual refresh.
- **Dual Authentication:** Email/Password sign-up/sign-in and Google OAuth, both backed by Firebase Auth with proper error handling.
- **Complete User Isolation:** Every task is stored under `users/{uid}/tasks/{taskId}`. Firestore Security Rules enforce that no user can ever read or write another user's data.
- **Full Task CRUD:** Create, read, update, and delete tasks with title, description, category, status (Todo / In Progress / Completed), and priority (Low / Medium / High).
- **Live Dashboard Analytics:** Real-time stat cards for total tasks, in-progress, completed, and high-priority counts — computed from the live Firestore stream.
- **Responsive Dark UI:** Full sidebar layout on desktop (800px+) with bottom navigation on mobile. Auth screens constrained to 450px max-width. Stats grid adapts from 4 → 2 → 1 columns.
- **Clean Layered Architecture:** UI → Provider → Repository → Service → Firebase. The Repository pattern makes the data layer fully swappable.
- **Zero Issues:** `flutter analyze` reports **no issues** — all deprecations, unused imports, and async context warnings resolved.

---

## 🛠️ Setup & Run Locally

### Prerequisites
- Flutter SDK `^3.13.0` — [Install Flutter](https://docs.flutter.dev/get-started/install)
- A configured Firebase project (see [Firebase Setup](#-firebase-setup) below)
- Chrome browser

### 1. Clone & Install

```bash
git clone https://github.com/Poorna-Sai-Sriharsha/Worksphere.git
cd Worksphere
flutter pub get
```

### 2. Run Development Server

```bash
flutter run -d chrome
```

Open [http://localhost:5000](http://localhost:5000) to view the app.

### 3. Production Build

```bash
flutter clean
flutter pub get
flutter build web --release
```

The build outputs to `build/web/` with zero analyzer issues and zero lint warnings.

---

## 🔥 Firebase Setup

The included `lib/firebase_options.dart` connects to the author's Firebase project. **Fork users must configure their own project.**

### 1. Create a Firebase Project

Go to [console.firebase.google.com](https://console.firebase.google.com) and create a new project.

### 2. Enable Authentication

In **Authentication → Sign-in method**, enable:
- ✅ Email/Password
- ✅ Google

### 3. Create Firestore Database

In **Firestore Database**, create a database in **production mode**.

### 4. Configure FlutterFire

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This overwrites `lib/firebase_options.dart` with your project's credentials.

### 5. Deploy Security Rules

```bash
firebase deploy --only firestore:rules
```

---

## 📂 Project Architecture

```
worksphere/
├── lib/
│   ├── app/
│   │   ├── app.dart                  # Root MaterialApp widget
│   │   └── app_theme.dart            # Global dark theme — colors, typography
│   ├── auth_gate.dart                # Auth state router — LoginScreen or AppShell
│   ├── firebase_options.dart         # Firebase Web configuration (client-side)
│   ├── main.dart                     # Entry point — Firebase init, Provider setup
│   ├── models/
│   │   └── task.dart                 # Task model — fromFirestore / toFirestore
│   ├── providers/
│   │   ├── auth_provider.dart        # Auth state, sign-in/up/out, error handling
│   │   └── task_provider.dart        # Task CRUD, Firestore stream subscription
│   ├── repositories/
│   │   └── task_repository.dart      # Abstraction layer over FirestoreService
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart     # Email/Password + Google Sign-In
│   │   │   └── register_screen.dart  # Email/Password registration
│   │   ├── dashboard/
│   │   │   └── dashboard_screen.dart # Live stat cards + recent tasks overview
│   │   ├── settings/
│   │   │   └── settings_screen.dart  # Settings placeholder (v2 roadmap)
│   │   └── tasks/
│   │       └── tasks_screen.dart     # Full task table with add/edit/delete
│   └── widgets/
│       ├── app_shell.dart            # Responsive layout — sidebar or bottom nav
│       ├── app_sidebar.dart          # Desktop navigation sidebar
│       ├── app_top_bar.dart          # Top bar — page title + search + user menu
│       ├── stat_card.dart            # Reusable metric card for dashboard
│       ├── task_dialog.dart          # Add/Edit task modal form
│       └── task_table.dart           # Scrollable DataTable with status/priority badges
├── web/
│   ├── index.html                    # Web entry point — title, meta, manifest link
│   ├── manifest.json                 # PWA manifest — WorkSphere branding
│   └── icons/                        # App icons 192px + 512px (regular + maskable)
├── .github/
│   └── workflows/
│       └── deploy.yml                # GitHub Actions — Flutter build + Netlify deploy
├── .gitattributes                    # LF line endings enforced for shell scripts
├── .gitignore
├── firestore.rules                   # Firestore security rules — user isolation
├── firestore.indexes.json            # Composite indexes for status/priority queries
├── netlify.toml                      # Netlify config — build command, headers, SPA redirect
├── netlify_build.sh                  # Flutter install + build script for Netlify
├── pubspec.yaml
└── README.md
```

---

## 🎨 Design System

### Color Palette

| Token | Value | Usage |
|---|---|---|
| `background` | `#0B0F14` | App background |
| `sidebar` | `#131820` | Sidebar + table headers |
| `card` | `#1A2130` | Cards, dialogs, inputs |
| `primaryAccent` | `#4F7CFF` | Buttons, links, active states |
| `textPrimary` | `#E8EDF5` | Headings, primary text |
| `textSecondary` | `#6B7A99` | Labels, placeholders, muted text |
| `success` | `#34D399` | Completed task badge |
| `warning` | `#FBBF24` | Medium priority badge |
| `danger` | `#F87171` | High priority badge, errors |

### Typography

| Role | Font | Weight |
|---|---|---|
| UI / Body | System default (Flutter) | 400–700 |
| Labels | AppTheme constants | 500–600 |

---

## 🔐 Security Architecture

### Firestore Rules
All access requires `request.auth.uid == userId` — unauthenticated and cross-user access are denied by default.

```javascript
match /users/{userId}/tasks/{taskId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
match /users/{userId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

### Firebase Web API Key
The API key in `firebase_options.dart` is a **client-side configuration value** — it is intentionally public and safe to commit for web applications. Firebase security is enforced by Authentication and Firestore Rules, not by hiding the key.

---

## 🚀 Deployment — GitHub Actions + Netlify

Deployment is fully automated via **GitHub Actions CI/CD**.

### How It Works
1. Push to `main` triggers `.github/workflows/deploy.yml`
2. GitHub Actions installs Flutter stable (cached), runs `flutter build web --release`
3. Built `build/web/` is deployed to Netlify via the Netlify CLI

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `NETLIFY_API_TOKEN` | Netlify personal access token |
| `NETLIFY_SITE_ID` | Target Netlify site ID |

Add these in: **Repository → Settings → Secrets and variables → Actions**

### Netlify Configuration (`netlify.toml`)

| Setting | Value |
|---|---|
| Build command | `bash netlify_build.sh` |
| Publish directory | `build/web` |
| SPA redirect | `/* → /index.html (200)` |

---

## 📋 Feature Checklist

| Feature | Status |
|---|---|
| Email/Password Authentication | ✅ Complete |
| Google Sign-In | ✅ Complete |
| Real-time Firestore task sync | ✅ Complete |
| Create / Edit / Delete tasks | ✅ Complete |
| Task status + priority fields | ✅ Complete |
| Dashboard with live analytics | ✅ Complete |
| Responsive layout (desktop + mobile) | ✅ Complete |
| Firestore user isolation | ✅ Complete |
| Firestore security rules | ✅ Complete |
| GitHub Actions CI/CD pipeline | ✅ Complete |
| Netlify deployment configuration | ✅ Complete |
| `flutter analyze` — zero issues | ✅ Complete |

---

## 📈 Potential Future Enhancements

- **Filter & Search:** Wire the existing filter chips (All / High Priority / Completed) and top bar search field to actual query logic.
- **Settings Screen:** User profile editing, display name, password change, and theme preferences.
- **Due Dates:** Add `dueDate` field to tasks with calendar picker and overdue highlighting.
- **Task Categories:** Filterable category tags with color coding.
- **Offline Support:** Enable Firestore offline persistence for PWA-like offline task management.
- **Push Notifications:** Firebase Cloud Messaging for task deadline reminders.

---

## 👤 Author

**Poorna Sai Sriharsha**
[GitHub](https://github.com/Poorna-Sai-Sriharsha) · WorkSphere Flutter Web Application
