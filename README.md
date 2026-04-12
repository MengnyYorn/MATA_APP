## MATA Shop – Flutter E‑Commerce App

MATA Shop is a modern e‑commerce mobile application built with Flutter.  
It showcases a clean shopping experience with a focus on UI, smooth navigation, and a modular architecture powered by GetX.

---

### Features

- **Product catalog**
  - Browse a list of products with images, prices, and descriptions.
  - Optimized image loading with caching and shimmer placeholders.

- **Home & discovery**
  - Curated home screen for featured and recommended items.
  - Category-based navigation (implementation may evolve).

- **Wishlist & persistence**
  - Add/remove products from a wishlist.
  - Local persistence using `get_storage` so favorites survive app restarts.

- **Profile & UX**
  - Basic profile screen and app info.
  - Consistent theming via a central `AppTheme`.

- **Navigation & state**
  - GetX-based navigation and state management.
  - Route configuration via `AppRoutes` / `AppPages`.

---

### Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State management & navigation**: `get`
- **Networking**: `dio`
- **Local storage**: `get_storage`
- **UI helpers**:
  - `cached_network_image`
  - `shimmer`
  - `flutter_svg`
  - `lottie`
- **Utilities**:
  - `intl`
  - `equatable`
  - `dartz`

See `pubspec.yaml` for the full list of dependencies and versions.

---

### Project Structure (High Level)

The structure may evolve, but at a high level:

- **`lib/main.dart`** – App entry point, initializes storage, orientation, and launches `MataApp`.
- **`lib/core/`**
  - `theme/` – `AppTheme` and general styling.
  - `constants/` – Shared constants (e.g., app-wide values).
  - `widgets/` – Reusable UI components such as product cards.
- **`lib/modules/`**
  - `home/` – Home screen, bindings, and controllers.
  - `product/` – Product list and detail related screens and logic.
  - `profile/` – Profile-related screens.
- **`lib/routes/`**
  - `app_routes.dart` – Route name definitions.
  - `app_pages.dart` – GetX `GetPage` configuration.
- **`assets/`**
  - `images/` – Product and UI images.
  - `icons/` – SVG icons (including the MATA and Store icons).
  - `animations/` – Lottie animations.
  - `fonts/` – Optional custom fonts (see commented section in `pubspec.yaml`).

---

### Prerequisites

- **Flutter SDK**: `>=3.0.0 <4.0.0`
- **Dart**: Comes with Flutter SDK
- A recent version of **Android Studio**, **Visual Studio Code**, or another IDE with Flutter support.

Confirm your setup:

```bash
flutter --version
flutter doctor
```

---

### Getting Started (Local Development)

- **1. Clone the repository**

```bash
git clone <your-repo-url>
cd mata_app
```

- **2. Install dependencies**

```bash
flutter pub get
```

- **3. (Optional) Configure fonts**

If you add custom fonts under `assets/fonts/`, uncomment and adjust the `fonts` section in `pubspec.yaml`, then run:

```bash
flutter pub get
```

- **4. Run the app**

```bash
flutter run
```

Use your preferred device:

- For Android: start an Android emulator or connect a physical device with USB debugging.
- For iOS: start an iOS simulator or connect a physical device (on macOS).

---

### Building Release APK / App Bundle

- **Android APK**

```bash
flutter build apk --release
```

- **Android App Bundle**

```bash
flutter build appbundle --release
```

These commands generate builds under `build/app/`.

Refer to the official Flutter documentation for signing and publishing:
- Android: `https://docs.flutter.dev/deployment/android`
- iOS: `https://docs.flutter.dev/deployment/ios`

---

### Environment & Configuration

This project is currently configured as a demo shopping app.  
If you want to connect to a real backend:

- **1. Decide your API backend** (REST, GraphQL, etc.).
- **2. Centralize API configuration** (e.g., base URLs, interceptors) in a core/network or data layer using `dio`.
- **3. Create repositories & data sources**
  - Keep network logic out of widgets and controllers.
  - Use models and mappers to transform API responses.

You can extend the existing repository pattern (for example, wishlist repository) for products, auth, and orders.

---

### Testing

Flutter’s built-in testing support is enabled via `flutter_test` and `flutter_lints`.

- **Run tests**:

```bash
flutter test
```

You can add:

- Unit tests for repositories and controllers.
- Widget tests for key screens (home, product list, product card).

---

### Coding Standards & Architecture

- **Architecture**
  - Modular structure (`modules` + `core`).
  - GetX for navigation, controllers, and bindings.
  - Separation of concerns between UI, state, and data.

- **Style & Linting**
  - Uses `flutter_lints` for recommended best practices.
  - Run `dart analyze` to check for issues:

```bash
dart analyze
```

---

### Contributing

- **1. Fork the repository** and create a feature branch.
- **2. Make your changes** following existing patterns and style.
- **3. Run `flutter test` and `dart analyze`** to ensure everything passes.
- **4. Open a Pull Request** with a clear description of:
  - What you changed.
  - How to test it.

---

### License

If this project is intended to be open source, add your license here (for example, MIT).  
Otherwise, specify that the code is proprietary and not for unauthorized redistribution.

