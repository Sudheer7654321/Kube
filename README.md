# 💼 Kube - Smart Personal Finance App 💰

Kube is a unified financial app built with Flutter that integrates UPI payments, stock tracking, crypto insights, card management, and more—all wrapped in a secure, elegant interface.

![Kube Banner](assets/banner.png)

---

## ✨ Features

- 🔐 **Biometric App Lock + PIN Access** (local_auth, shared_preferences, secure_storage)
- 🔥 **UPI Payments & History UI** (UI-based, real-time coming soon)
- 📈 **Stock Tracker** using [Finnhub API](https://finnhub.io)
  - Top gainers, losers, beginners, trending
  - Sparkline charts with `fl_chart`
- 💳 **Card Management UI** (Add, delete, view cards)
- 🪙 **Crypto Section**
  - WalletConnect v2 integration
  - Covalent API to fetch balances
- 🧩 Modular Screens with `flutter_zoom_drawer`
- 🧠 Clean state management with `Provider`
- 🔥 Firebase Auth integrated
- 🎨 Dark theme, responsive layout, and custom fonts/icons

---

## 📱 Screenshots

| Biometric Lock | Dashboard | Stock Page |
|----------------|-----------|------------|
| ![](assets/screens/lock.png) | ![](assets/screens/dashboard.png) | ![](assets/screens/stocks.png) |

---

## 🚀 Getting Started

### 1. Clone the Repo
```bash
git clone https://github.com/yourname/kube.git
cd kube
2. Install Dependencies
bash
Copy
Edit
flutter pub get
3. Set up Firebase
Add your google-services.json and GoogleService-Info.plist to the appropriate folders.

Update firebase_options.dart using flutterfire configure.

4. Run the App
bash
Copy
Edit
flutter run
To build APK:

bash
Copy
Edit
flutter build apk --release
🔧 Tech Stack
Flutter 3.x

Firebase (Auth, Core)

Finnhub API for stocks

WalletConnect v2, Covalent API for crypto

local_auth, flutter_secure_storage, shared_preferences

UI: flutter_zoom_drawer, hugeicons, fl_chart, google_fonts

🛡 Security
PIN stored securely with flutter_secure_storage

Biometric unlock (Face ID / Fingerprint)

Auth state monitored via Firebase

📁 Folder Structure
bash
Copy
Edit
lib/
├── pages/
│   ├── authentication/      # Firebase login
│   ├── cards/               # Card UI & state
│   ├── crypto/              # WalletConnect + Covalent
│   ├── home/                # Dashboard page
│   ├── investments/         # Investment placeholder
│   ├── stock/               # Stock API, providers, views
│   ├── upi/                 # UPI UI navigation
│   └── settings1/           # Settings UI
├── main.dart                # Entry point
├── firebase_options.dart    # Auto-generated config
🧪 Coming Soon
✅ Real UPI integration via upi_india or paytm_allinonesdk

✅ Firebase Firestore for watchlist/orders

📉 Real crypto trading (Testnet)

🌐 Multi-language support

🧾 Expense tracker

👨‍💻 Developer
Made with ❤️ by Sudheer Kondamuri

Feel free to fork and contribute.

📃 License
MIT

