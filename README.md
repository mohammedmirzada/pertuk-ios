# Pertuk (iOS)

Pertuk iOS is the **native iOS client** for the Pertuk platform.
It is written entirely in **Swift** and structured to support both iPhone and iPad targets.

---

## 📱 Overview

* Native iOS application
* Written in **Swift**
* Supports iPhone and iPad
* Connects to the Pertuk backend API

---

## 🚀 Features

* Native iOS UI
* API-based communication
* Modular and extendable codebase
* Ready for App Store deployment

---

## 🛠 Tech Stack

* **Language:** Swift
* **Platform:** iOS
* **IDE:** Xcode
* **Architecture:** Standard iOS project structure
* **Backend:** Pertuk API

---

## 📂 Project Structure

```
pertuk-ios/
├── Pertuk/          # Main iPhone app source code
├── iPad/            # iPad-specific source / target
├── .gitignore
└── README.md
```

---

## ⚙️ Requirements

* macOS
* Xcode (latest recommended)
* Apple Developer account (required for real device testing and App Store builds)

---

## 🧑‍💻 Installation & Setup

1. Clone the repository

   ```
   git clone https://github.com/mohammedmirzada/pertuk-ios.git
   ```

2. Open the project in Xcode

   * Open `.xcworkspace` if available
   * Otherwise open `.xcodeproj`

3. Select the appropriate scheme (iPhone or iPad)

4. Run on:

   * iOS Simulator, or
   * Physical iPhone / iPad (signing required)

---

## 🔧 Configuration

* Set the API **Base URL** inside the project
* Avoid hardcoding secrets
* Use `Info.plist` or build configurations for environment values

---

## 🧪 Debugging

* Use Xcode Debug Console
* Add breakpoints for logic inspection
* Monitor network requests during development

---

## 📦 Build & Release

* Configure:

  * Bundle Identifier
  * Signing & Capabilities
  * Provisioning profiles

* For release builds:

  ```
  Product → Archive
  ```

  Then upload to **TestFlight / App Store**

---

## 🔐 Security Notes

* Do not commit API keys or tokens
* Always use HTTPS
* Keep production secrets out of source code

---

## 🤝 Contributing

1. Fork the repository
2. Create a new branch
3. Commit your changes
4. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License**.
See the `LICENSE` file for details.

---

## 👤 Author

**Mohammed Dmirzada**
GitHub: [https://github.com/mohammedmirzada](https://github.com/mohammedmirzada)
