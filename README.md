# MATA Shop — Flutter app (`MATA_APP`)

Customer-facing **mobile** app for the MATA Shop e-commerce platform. It talks to the **MATA-API** Spring Boot backend over REST (products, categories, auth, cart flow, orders, wishlist).

**Related repositories**

| Project | Role |
|--------|------|
| [MATA-API](../MATA-API) | REST API, JWT auth, PostgreSQL |
| [MATA-ADMIN-UI](../MATA-ADMIN-UI) | Admin dashboard (web) |
| [MATA_UI](../MATA_UI) | Planned public **web** storefront (browser); not implemented in this workspace yet |

---

## Features

- **Browse & search** — Product grid, category chips loaded from `GET /api/v1/categories`, search/filter by category.
- **Product detail** — Images, sizes/colors, add to cart.
- **Cart & checkout** — Local cart; place order when signed in (`POST /api/v1/orders`).
- **Authentication**
  - Email + password login and registration (with email OTP where configured).
  - **Sign in with Google** (ID token verified by the API).
- **Account** — Profile screen; JWT access token with **refresh** on `401`/`403` for orders APIs.
- **Orders** — “My orders” (`GET /api/v1/orders/my`), order detail; session refresh via `POST /api/v1/auth/refresh` when the access token expires.
- **Wishlist** — Persisted locally (`get_storage`).
- **UI** — Theming, shimmer loading, cached images, Lottie where used.

---

## Tech stack

| Area | Packages |
|------|----------|
| Framework | Flutter |
| State / navigation | `get` (GetX) |
| HTTP | `dio` |
| Storage | `get_storage` |
| Google Sign-In | `google_sign_in` |
| UI | `cached_network_image`, `shimmer`, `flutter_svg`, `lottie` |
| Utilities | `intl`, `equatable`, `dartz` |

See `pubspec.yaml` for versions.

---

## Prerequisites

- **Flutter SDK** (Dart `>=3.0.0 <4.0.0`)
- **MATA-API** running and reachable from the device or emulator (see [Network](#network-and-api-base-url))
- Android Studio / Xcode / VS Code with Flutter extensions

```bash
flutter --version
flutter doctor
```

---

## Configuration

### API base URL

Set the backend base in **`lib/core/constants/app_constants.dart`**:

```dart
static const String baseUrl = 'http://<host>:8087/api/v1';
```

- **Physical device:** use your PC’s LAN IP (e.g. `192.168.x.x`), not `localhost`.
- **Android emulator:** the project maps `localhost` → `10.0.2.2` in Dio base URL resolution so `http://localhost:8087/api/v1` can work for the emulator only when you use `localhost` in that constant.

### Google Sign-In

The **Web client ID** (server audience for the ID token) must match the API’s `GOOGLE_CLIENT_ID`. Override at build time if needed:

```bash
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=your-id.apps.googleusercontent.com
```

Configure the OAuth client in Google Cloud (Android package name + SHA-1 for debug/release).

---

## Getting started

```bash
cd MATA_APP
flutter pub get
flutter run
```

Choose a device or emulator when prompted.

### Checks

```bash
dart analyze
flutter test
```

---

## Project structure (overview)

| Path | Purpose |
|------|---------|
| `lib/main.dart` | Entry: `GetStorage`, `GetMaterialApp`, global `AuthRepository` |
| `lib/core/` | Theme, constants, utilities, shared widgets |
| `lib/data/` | Models, repositories (`auth_repository`, `product_repository`, `order_repository`, wishlist, cart) |
| `lib/modules/` | Feature screens: splash, auth, home, product list/detail, cart, checkout, orders, profile |
| `lib/routes/` | `AppRoutes`, `AppPages`, bindings |

---

## Building releases

**Android APK**

```bash
flutter build apk --release
```

**Android App Bundle**

```bash
flutter build appbundle --release
```

Outputs under `build/app/`. Use your signing config for Play Store uploads.

**iOS** (on macOS)

```bash
flutter build ios --release
```

---

## Network and API base URL

- The API is expected at **`/api/v1/...`** (see MATA-API README).
- If products or orders fail to load, confirm the phone/emulator can reach `baseUrl` (firewall, same Wi‑Fi, correct IP).
- Orders endpoints require a valid **Bearer** token; expired sessions trigger a **refresh** once, then a clear message if refresh fails.

---

## Coding standards

- `flutter_lints` is enabled; run `dart analyze` before committing.
- Keep API access in **repositories**, not in widgets.

---

## License

Proprietary — MATA project unless you add an open-source license.
