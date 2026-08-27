# YallaGo Flutter MVP

This is a **complete frontend Flutter baseline** for the approved YallaGo Customer and Vendor MVP flows. It uses static/sample data only. It deliberately excludes the Driver App, Admin Dashboard, backend, real OTP, online payment, live maps, and notifications because they are outside the design-stage scope approved for this source package.

## Included experience

| Area | Included screens and interactions |
|---|---|
| Customer App | Splash, role selection, login/OTP simulation, restaurant discovery, restaurant menu, item customisation, cart, cash-on-delivery checkout, order status, and order history. |
| Vendor App | Login/OTP simulation, daily menu management, add/edit sheet, availability toggles, incoming orders, and accept/reject/preparing/ready order status actions. |
| Shared | Arabic-first right-to-left layout, English switcher, Nile Pulse colours, local image assets, reusable UI primitives, and sample order/menu data. |

## Run locally in VS Code on Windows

1. Install the current stable [Flutter SDK](https://docs.flutter.dev/get-started/install/windows/mobile) and Android Studio. In Android Studio, install at least one Android SDK platform and create an emulator.
2. Install the **Flutter** and **Dart** extensions in VS Code.
3. Open the `yallago-flutter` folder in VS Code, then open **Terminal → New Terminal**.
4. Run the following commands exactly once to create the Android, iOS, Web, Windows, macOS, and Linux platform wrapper folders around the supplied source code:

   ```powershell
   flutter create .
   flutter pub get
   flutter doctor
   ```

5. Start an Android emulator from Android Studio, or connect an Android phone with USB debugging enabled. Confirm that Flutter sees it:

   ```powershell
   flutter devices
   ```

6. Run the app:

   ```powershell
   flutter run
   ```

You can also press `F5` in VS Code, select the Android device in the status bar, and choose **Run and Debug**. While `flutter run` is active, press `r` in the terminal for hot reload.

## Validation

After installing Flutter locally, validate the source with:

```powershell
flutter analyze
flutter test
```

The environment that produced this archive does not include Flutter or Dart, so this source code could not be compiled in that environment. The project intentionally has no external runtime packages; `flutter pub get` retrieves only the Flutter SDK dependencies declared in `pubspec.yaml`.

## API integration seams

Keep all UI and UX state in the supplied screens until backend endpoints are ready. Replace the local OTP simulation in `AuthScreen`, customer lists and menu sample values, cart submission, customer tracking state, and vendor menu/order state with repositories that call the modular ASP.NET Core endpoints described in `MVP_PLAN_ALIGNMENT.md`.

| UI responsibility | Future endpoint |
|---|---|
| Login / OTP | `POST /auth/send-otp`, `POST /auth/verify-otp` |
| Customer restaurant and menu browsing | `GET /vendors`, `GET /vendors/{id}/menu` |
| Vendor menu management | `POST /vendors/{id}/menu`, `PUT /menu/{id}` |
| Customer checkout and history | `POST /orders`, `GET /orders/customer` |
| Vendor incoming orders and state actions | `GET /orders/vendor`, `PUT /orders/{id}/status` |

## Recommended next implementation step

When the UI sign-off is complete, split `lib/main.dart` into `core/`, `features/customer/`, `features/vendor/`, and `shared/`. Add a typed API client, secure token storage, real localisation files, and tests before integrating the live ASP.NET Core backend.
