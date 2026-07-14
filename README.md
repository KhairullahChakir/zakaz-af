# Zakaz-AF E-Commerce Platform

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)

## 📖 Overview
**Zakaz-AF** is a comprehensive, full-stack e-commerce mobile application and backend platform. Designed for robust, multi-regional delivery, it features seamless Stripe payment integration, multiple localized languages (English, Dari, and Pashto), and flexible delivery logistics. 

## ✨ Features
* **Secure Checkout**: Full Stripe payment integration for seamless card processing.
* **Localization**: Built-in translation layers supporting English, Dari, and Pashto.
* **Delivery Logistics**: Flexible delivery methods:
  * Zakaz-AF Cargo (Free, 1-3 Business days)
  * Regional Shipping (5-7 Business days)
  * Express Shipping (Next working day)
* **Robust State Management**: Powered by Riverpod for highly scalable Flutter state management.

## 🚀 Technologies Used
* **Frontend**: Flutter & Dart (`/mobile_app`)
* **State Management**: Riverpod
* **Payment Gateway**: Stripe API
* **Backend**: Node.js / Laravel (`/backend`) 

## 📁 Project Structure
```text
zakaz-af/
├── backend/                  # API server, PaymentControllers, Database migrations
├── mobile_app/               # Flutter mobile application source code
├── DEV_STATUS.md             # Development tracking and milestones
├── ZAKAZ_AF_PROJECT_REPORT.* # Project documentation and reports
├── find_dupes.py             # Utility script for finding duplicate translation keys
├── .gitignore                # Git ignores
├── LICENSE                   # MIT License
└── README.md                 # Project documentation
```

## 📸 Screenshots
*(Coming soon - Screenshots of the checkout screen and storefront)*

## 🛠️ Installation & Setup

### 1. Backend Setup
```bash
cd backend
# Install backend dependencies (e.g., npm install or composer install)
# Copy .env configuration and add your Stripe Secret Keys
# Run migrations to setup `payment_method` and `delivery_method` columns
# Start the server
```

### 2. Mobile App Setup
```bash
cd mobile_app
flutter pub get
```
*Note: Ensure your `StripeService` is configured with the correct publishable key in your `.env` or config file.*

```bash
flutter run
```

## 🔮 Future Improvements
* **Push Notifications**: Integrate Firebase Cloud Messaging (FCM) for order status updates.
* **Admin Dashboard**: Build a comprehensive web dashboard for inventory and order management.
* **Maps Integration**: Add Google Maps for precise delivery pinning.

## 🤝 Contributing
Contributions are welcome. Please open an issue first to discuss what you would like to change.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
