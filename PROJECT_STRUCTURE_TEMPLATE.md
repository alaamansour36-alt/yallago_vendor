# Generic Flutter Project Structure

This document describes a reusable Flutter project structure that can be adapted for other mobile applications. It is based on a production-style cross-platform app with optional native integrations, shared assets, feature modules, and tests.

## Goals

- Keep app code organized by responsibility.
- Separate shared infrastructure from feature-specific code.
- Support Flutter-first development with optional native platform code.
- Make it easy to scale from a small app to a larger production codebase.

## Recommended Top-Level Structure

```text
project-root/
  android/
  ios/
  lib/
    app/
    core/
    features/
    main.dart
  assets/
    fonts/
    icons/
    lottie/
    translations/
  test/
  web/
  windows/
  macos/
  linux/
  packages/
  docs/
  pubspec.yaml
  analysis_options.yaml
  README.md
```

## Folder Responsibilities

### `lib/`

Main Flutter application source code.

- `main.dart`
  App entry point. Initializes dependencies, services, and the root widget.
- `app/`
  App-level setup such as routing, themes, dependency injection, app configuration, and root widgets.
- `core/`
  Shared building blocks used across features.
  Typical contents:
  - constants
  - utilities
  - shared widgets
  - networking
  - storage
  - error handling
  - base classes
- `features/`
  Feature-based modules. Each feature owns its presentation, domain, and data layers where needed.

Example:

```text
lib/
  features/
    authentication/
      data/
      domain/
      presentation/
    dashboard/
      data/
      domain/
      presentation/
    settings/
      presentation/
```

### `assets/`

Static resources bundled with the app.

Typical subfolders:

- `fonts/` for custom typography
- `icons/` for SVG or raster icons
- `lottie/` for animations
- `translations/` for localization JSON or ARB files
- `images/` or `illustrations/` if needed

Keep asset naming consistent and register all used assets in `pubspec.yaml`.

### `test/`

Automated tests.

Suggested structure:

```text
test/
  unit/
  widget/
  integration/
```

If the project is small, a flatter test structure is also acceptable.

### `android/` and `ios/`

Platform-specific code and configuration.

Use these folders for:

- native SDK setup
- permissions
- platform channels
- build configuration
- signing and platform resources

Only place code here when the behavior cannot live purely in Flutter.

### `web/`, `windows/`, `macos/`, `linux/`

Platform runners and platform-specific configuration for additional Flutter targets.

Keep them enabled only if the project supports those platforms.

### `packages/`

Local packages or in-repo plugins.

Use this when:

- extracting reusable modules from the main app
- maintaining custom plugins
- sharing code across multiple apps in the same repository

If the app does not need local packages, this folder can be omitted.

### `docs/`

Project documentation.

Good candidates:

- setup guides
- architecture notes
- integration guides
- release process
- environment configuration

### Root Configuration Files

- `pubspec.yaml`
  Dependencies, assets, fonts, and package metadata.
- `analysis_options.yaml`
  Linting and static analysis rules.
- `README.md`
  Project overview, setup, and usage.
- environment or service config files
  Add only what the project actually needs.

## Suggested Feature Module Layout

For medium or large apps, prefer feature-first organization.

```text
lib/features/
  feature_name/
    data/
      models/
      repositories/
      datasources/
    domain/
      entities/
      repositories/
      usecases/
    presentation/
      screens/
      widgets/
      controllers/
```

Notes:

- `data/` handles API calls, local storage, DTOs, and repository implementations.
- `domain/` contains business rules and app-specific abstractions.
- `presentation/` contains UI, state management, and user interaction logic.

For smaller apps, you can simplify this and keep only `presentation/` plus a lightweight service layer.

## Suggested `core/` Layout

```text
lib/core/
  constants/
  errors/
  extensions/
  network/
  services/
  storage/
  theme/
  utils/
  widgets/
```

This folder should contain only shared code. If something is used by one feature only, keep it inside that feature.

## Architecture Guidelines

- Prefer feature ownership over type-based sprawl.
- Keep shared code in `core/` only when it is truly shared.
- Keep app bootstrap concerns in `app/`.
- Isolate native integrations behind services or platform channel abstractions.
- Avoid placing unrelated business logic directly in screens.
- Keep documentation close to integrations and setup-heavy areas.

## Optional Additions

Depending on project size, you may also add:

- `integration_test/` for end-to-end Flutter tests
- `.github/` for CI workflows
- `scripts/` for automation
- `flavors/` or environment config files for dev/staging/prod setups
- `melos.yaml` if managing multiple Dart packages in one repository

## Example Minimal Version

```text
project-root/
  lib/
    app/
    core/
    features/
    main.dart
  assets/
  test/
  android/
  ios/
  pubspec.yaml
  README.md
```

## Example Scaled Version

```text
project-root/
  android/
  ios/
  web/
  windows/
  macos/
  linux/
  lib/
    app/
    core/
    features/
    main.dart
  assets/
    fonts/
    icons/
    lottie/
    translations/
  test/
  integration_test/
  packages/
  docs/
  scripts/
  pubspec.yaml
  analysis_options.yaml
  README.md
```

## How To Reuse This In Another Project

1. Keep the top-level structure that matches your supported platforms.
2. Start with `lib/app`, `lib/core`, and `lib/features`.
3. Add only the asset folders you actually use.
4. Add native code only when a Flutter package is not enough.
5. Split features into `data`, `domain`, and `presentation` only when the complexity justifies it.
6. Document custom integrations in `docs/` early, before they become tribal knowledge.

## Summary

This structure works well for Flutter apps that need:

- clear separation of concerns
- room for growth
- optional native integrations
- reusable shared infrastructure
- feature-based scaling

It can be reduced for small apps or expanded for enterprise-scale projects without changing the overall organization model.