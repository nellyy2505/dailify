# 🗓️ Dailify

**Your all-in-one daily assistant — powered by GPT.**  
Dailify streamlines your day by combining a **chatbot, scheduler, email summarizer, and spam filter** into one seamless productivity app.

---

## 🚀 Features

- 💬 **Smart Chatbot** — Get instant responses and assistance for daily tasks  
- 🗓️ **Integrated Scheduler** — Manage your events and reminders effortlessly  
- ✉️ **Email Summarizer** — Automatically condense long emails into key points  
- 🚫 **Spam Filter** — Keep your inbox clean and focused  
- 🤖 **GPT-Powered Intelligence** — Uses OpenAI GPT API (key not included in repo)

---

## 🛠️ Tech Stack

- **Language:** [Dart](https://dart.dev/)  
- **Framework:** [Flutter](https://flutter.dev/)  
- **Backend API:** OpenAI GPT API  
- **Platform:** Android, iOS, Web (Flutter multiplatform)

---

## ⚙️ Setup & Installation

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/dailify.git
cd dailify
````

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Add your OpenAI API key

Create a file named `.env` (or edit `lib/config.dart`):

```bash
OPENAI_API_KEY=your_api_key_here
```

> ⚠️ **Note:** For security reasons, the API key is **not included** in this repository.

### 4. Run the app

To run on an emulator, web, or connected device:

```bash
flutter run
```

---

## 📱 Build for Production

### Android (APK or AppBundle)

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

---

## 👩‍💻 Contributing

Pull requests are welcome!
If you’d like to contribute:

1. Fork this repo
2. Create your feature branch

   ```bash
   git checkout -b feature/new-feature
   ```
3. Commit your changes

   ```bash
   git commit -m 'Add new feature'
   ```
4. Push to your branch

   ```bash
   git push origin feature/new-feature
   ```
5. Create a Pull Request

---
