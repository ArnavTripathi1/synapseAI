# Synapse 🧠

**Synapse** is a cross-platform mobile application designed to bridge the gap between students and mental health professionals. This repository currently contains the **Counsellor Frontend MVP**, featuring a comprehensive dashboard, schedule management, and communication tools.

## 🚀 Key Features

### 1. **Role-Based Authentication**

* **Dynamic Login Screen**: Toggle seamlessly between "Student" and "Counsellor" roles.
* **Secure Inputs**: Validation logic for email and password fields.

### 2. **Counsellor Dashboard**

* **Real-Time Status**: "Online/Offline" toggle to manage visibility.
* **Quick Stats**: At-a-glance view of pending requests, today's sessions, and total sessions.
* **Deep Navigation**:
* "Upcoming Sessions" redirects intelligently to the Schedule tab.
* "New Requests" opens a dedicated management screen for pending approvals.



### 3. **Smart Scheduling System**

* **Dynamic Calendar**: auto-generates the next 14 days.
* **Slot Management**:
* Visual indicators for "Available", "Booked", and "Break" slots.
* **Toggle Logic**: Enable/Disable availability with a single switch.
* **Add Slot**: Modal bottom sheet to create new time slots or breaks.



### 4. **Session Management**

* **Session Details Screen**: Deep dive into a specific appointment with student history and issue tags.
* **Pre-Call Tools**: Private notes section for counsellors to prepare before the call.
* **Video Call UI**: "Join Now" integration points ready for SDKs (Agora/ZegoCloud).

### 5. **Communication Suite**

* **Chat Interface**: WhatsApp-style chat UI with:
* "Typing..." indicators.
* Message timestamps and read receipts.
* Auto-scroll and keyboard handling.


* **Profile Management**: Edit profile capabilities with live-updating avatar initials and form validation.

---

## 🛠 Tech Stack

* **Framework**: [Flutter](https://flutter.dev/) (Dart)
* **State Management**: `setState` (Local) / `StatefulWidget`
* **Architecture**: Feature-First (Modular)
* **Packages Used**:
* `intl`: Date and time formatting.



---

## 📂 Project Structure

The project follows a **Feature-First** directory structure to ensure scalability:

```text
lib/
├── features/
│   ├── auth/              # Login & Signup Screens
│   ├── chat/              # Chat Lists & Detail Screens
│   └── counsellor/        # Counsellor-specific Modules
│       ├── dashboard/     # Home Tab & Stats
│       ├── profile/       # Edit Profile & Settings
│       ├── schedule/      # Calendar & Slot Logic
│       └── session/       # Session Details & Call UI
├── common/                # Reusable Widgets (SessionCard, RequestCard)
└── main.dart              # Entry point

```

---

## 🏁 Getting Started

1. **Prerequisites**: Ensure you have Flutter installed (`flutter doctor`).
2. **Clone the repository**:
```bash
git clone https://github.com/your-username/synapse.git
cd synapse

```


3. **Install Dependencies**:
```bash
flutter pub get

```


4. **Run the App**:
```bash
flutter run

```



---

## 🚧 Roadmap & Upcoming Integrations

* [ ] **Backend Integration**: Connect Auth and Database (Firebase/Node.js).
* [ ] **Video Calling**: Integrate Agora/ZegoCloud SDK for the "Join Call" buttons.
* [ ] **Student Module**: Build the corresponding interface for students to book slots.
* [ ] **Push Notifications**: Notify counsellors of new requests and upcoming sessions.

---

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
