# 📝 Task Manager App — Flutter Internship (Cycle 2)

A Flutter application built during the Flutter Developers Internship (Cycle 2), covering API Integration, Firebase Authentication, and State Management with Provider.

---

## 📱 Features

### Week 4 — API Integration & Networking
- Fetches real user data from [JSONPlaceholder](https://jsonplaceholder.typicode.com/users) REST API
- Displays users in a scrollable `ListView` with name and email
- Tap any user to view a full **User Profile Screen** (name, email, phone, website, avatar)
- Loading spinner shown while data is being fetched
- Error message + **Retry** button if the request fails

### Week 5 — Firebase Authentication & Firestore
- Real **Email/Password Authentication** using Firebase Auth
- **Signup screen** — creates account and saves name & email to Firestore
- **Login screen** — authenticates with Firebase
- **Profile screen** — retrieves and displays user data from Firestore
- **Logout** — clears Firebase session
- Splash screen auto-detects login state on app launch

### Week 6 — State Management with Provider
- Refactored Task Manager to use **Provider** instead of `setState`
- `TaskProvider` handles all task logic (add, delete, toggle)
- Real-time **stats bar** showing Total / Done / Pending tasks
- **Slide + Fade animations** when tasks are added
- **Animated checkbox** and strikethrough on task completion
- Tasks persisted locally using `SharedPreferences`

### Weeks 1–3 — Base App
- Add, delete, and toggle tasks as complete/incomplete
- Animated Splash Screen with fade and scale transitions
- Login Screen with form validation

---

## 🗂️ Project Structure

```
lib/
├── main.dart                         # App entry + Provider setup + Firebase init
├── splash_screen.dart                # Animated splash with Firebase auth check
├── home_screen.dart                  # Task Manager using Provider + animations
├── providers/
│   └── task_provider.dart            # ChangeNotifier for task state management
├── models/
│   └── user_model.dart               # User data model with fromJson()
├── services/
│   └── api_service.dart              # HTTP requests to JSONPlaceholder API
└── screens/
    ├── login_screen.dart             # Firebase Email/Password login
    ├── signup_screen.dart            # Firebase signup + Firestore save
    ├── profile_screen.dart           # Reads user data from Firestore
    ├── users_list_screen.dart        # ListView of API users
    └── user_profile_screen.dart      # Detail screen for a single API user
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.11.1`
- Dart SDK
- A Firebase account
- An internet connection

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/task_manager_app.git
   cd task_manager_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable **Email/Password** Authentication
   - Create a **Firestore** database in test mode
   - Download `google-services.json` and place it in `android/app/`

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `http` | ^1.2.1 | REST API network requests |
| `shared_preferences` | ^2.2.2 | Local task persistence |
| `firebase_core` | ^3.6.0 | Firebase initialization |
| `firebase_auth` | ^5.3.1 | Email/Password authentication |
| `cloud_firestore` | ^5.4.4 | Cloud database for user data |
| `provider` | ^6.1.2 | State management |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

---

## 🌐 API Used

**JSONPlaceholder** — `https://jsonplaceholder.typicode.com/users`

Free fake REST API used for testing and prototyping. Returns 10 mock users with name, email, phone, and website fields.

---

## 📸 Screens

| Screen | Description |
|---|---|
| Splash Screen | Animated logo, checks Firebase login state |
| Login Screen | Firebase Email/Password login with error handling |
| Signup Screen | Create account, saves to Firestore |
| Home Screen | Task list with Provider + animations + stats bar |
| Profile Screen | Displays user data fetched from Firestore |
| Users List | API users in a ListView |
| User Profile | Full details + avatar for each API user |

---

## 🏗️ Architecture

```
UI (Screens)
    ↓  listens to
Provider (TaskProvider)
    ↓  persists to
SharedPreferences (local storage)

UI (Screens)
    ↓  calls
ApiService
    ↓  fetches from
JSONPlaceholder API

UI (Screens)
    ↓  uses
Firebase Auth + Firestore
    ↓  stores in
Firebase Cloud
```

---

## 👨‍💻 Author

Built as part of the **Flutter Developers Internship — Cycle 2**
Weeks 4–6 | Deadline: 25 May 2026
