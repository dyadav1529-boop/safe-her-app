# SafeHer 🛡️

A clean, modern, beginner-friendly Android safety application designed to help women stay secure, share emergency statuses, and manage trusted contacts.

Built with **Flutter & Dart** using Material 3 principles.

---

## 📱 Features

1. **Prominent SOS Emergency Button**: A pulsing, high-visibility emergency button with a cancellation countdown grace period.
2. **Honest Development Simulation**: In development mode, the app demonstrates the emergency sequence (actions, recipient lists, message formats) without sending fake alerts or real calls/SMS.
3. **Trusted Emergency Contacts**: Add, view, remove, and designate primary contacts from your inner circle.
4. **Live Location Status & Permission Handling**: Clear display of location status (Standby, Active Preview, Error / Permission Denied) with interactive simulation toggles.
5. **Safety Tips & Resources**: Practical advice categorized by situation (Walking alone at night, Cabs & Rideshares, Digital Privacy, Safe Havens) and emergency helpline references (112, 1091, 181, 911).
6. **Settings & Preferences**: Customizable distress SMS templates, countdown timer duration, siren test preview, and permission audits.

---

## 📂 Project Architecture

The codebase is organized into clean, modular folders with explanatory beginner comments:

```
lib/
├── main.dart                       # Entry point, Material 3 theme & color palette
├── models/
│   ├── contact.dart                # Contact data model
│   └── safety_tip.dart             # Safety tip data model
├── screens/
│   ├── main_navigation_screen.dart # Material 3 bottom navigation bar & state
│   ├── home_screen.dart            # Main dashboard with SOS button & helpline bar
│   ├── contacts_screen.dart        # View, add, and manage trusted contacts
│   ├── safety_tips_screen.dart     # Categorized tips & expandable advice
│   └── settings_screen.dart        # Preferences, permissions & dev disclaimer
├── widgets/
│   ├── sos_button.dart             # Prominent animated red SOS button
│   ├── location_status_card.dart   # Location state, permission & error handling
│   ├── contact_card.dart           # Contact display card with delete dialog
│   └── add_contact_dialog.dart     # Form input dialog with validation
└── utils/
    └── mock_data.dart              # Starter contacts and safety tips
```

---

## 🚀 Running SafeHer on Windows

### 1. View Available Devices
In your PowerShell terminal, check which target devices are detected:
```powershell
flutter devices
```

### 2. Run in Google Chrome (Fastest UI preview)
```powershell
flutter run -d chrome
```

### 3. Run on an Android Phone (via USB)
1. Enable **Developer Options** and **USB Debugging** on your Android phone.
2. Connect your phone to your Windows PC with a USB cable.
3. Verify your device appears in `flutter devices`.
4. Run:
```powershell
flutter run -d android
```

### 4. Run on an Android Emulator
If you have an Android Virtual Device (AVD) set up in Android Studio:
```powershell
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

### 5. Running Tests & Code Analysis
```powershell
# Analyze Dart code for errors or style issues:
flutter analyze

# Run unit and widget tests:
flutter test
```
