# Feature-First Restructure Plan

This document defines the first step only: the target folder structure and the exact file moves needed to make the project follow a feature-first layout.

Scope of this step:

- No UI changes.
- No logic changes.
- No state-management changes.
- No API contract changes.
- No renaming of business behavior.

The goal is only to reorganize files so screens and related code live under the feature that owns them.

## Current Problem

The project is partially feature-based already, but the current structure still has one broad parent feature:

```text
lib/features/vendor/
```

That folder currently contains multiple different flows grouped together under one parent bucket:

- auth flow
- dashboard flow
- catalog/menu flow
- orders flow

This makes the structure closer to "all vendor screens in one place" than true feature-first ownership.

## Target Principle

Organize by business feature first, not by app role first.

Instead of keeping everything under a parent `vendor` feature, split the code into self-contained features such as:

- `auth`
- `catalog`
- `orders`
- `dashboard` or `home`

If a file is shared by more than one feature, move it to `core/` only if it is truly app-wide, or to `features/shared/` if it is shared only inside feature space.

## Recommended Target Structure

```text
lib/
  main.dart
  app/
    app.dart
  core/
    constants/
    navigation/
    network/
    theme/
    utils/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    catalog/
      data/
      domain/
      presentation/
    dashboard/
      presentation/
    orders/
      data/
      domain/
      presentation/
    shared/
      app_scope.dart
```

## Current File Inventory To Reorganize

Current vendor-owned files:

```text
lib/features/vendor/data/models/vendor_models.dart
lib/features/vendor/data/repositories/vendor_auth_repository.dart
lib/features/vendor/data/repositories/vendor_catalog_repository.dart
lib/features/vendor/data/repositories/vendor_orders_repository.dart
lib/features/vendor/data/services/vendor_auth_service.dart
lib/features/vendor/data/services/vendor_catalog_service.dart
lib/features/vendor/data/services/vendor_orders_service.dart
lib/features/vendor/presentation/cubit/vendor_auth_cubit.dart
lib/features/vendor/presentation/cubit/vendor_catalog_cubit.dart
lib/features/vendor/presentation/cubit/vendor_orders_cubit.dart
lib/features/vendor/presentation/dialogs/category_dialog.dart
lib/features/vendor/presentation/screens/vendor_dashboard_screen.dart
lib/features/vendor/presentation/screens/vendor_login_screen.dart
lib/features/vendor/presentation/screens/vendor_order_detail_screen.dart
lib/features/vendor/presentation/screens/vendor_root_screen.dart
lib/features/vendor/presentation/widgets/product_editor_sheet.dart
lib/features/vendor/presentation/widgets/vendor_shared_widgets.dart
lib/features/vendor/presentation/vendor_app.dart
lib/features/vendor/presentation/vendor_screens.dart
```

## Proposed Move Map

### 1. Auth feature

Move authentication-specific files to:

```text
lib/features/auth/
  data/
    repositories/vendor_auth_repository.dart
    services/vendor_auth_service.dart
  domain/
  presentation/
    cubit/vendor_auth_cubit.dart
    screens/vendor_login_screen.dart
```

Notes:

- File names can stay unchanged in the first pass to avoid unnecessary churn.
- A later cleanup pass can rename `vendor_*` files if desired.

### 2. Catalog feature

Move menu/catalog-specific files to:

```text
lib/features/catalog/
  data/
    models/vendor_models.dart
    repositories/vendor_catalog_repository.dart
    services/vendor_catalog_service.dart
  domain/
  presentation/
    cubit/vendor_catalog_cubit.dart
    dialogs/category_dialog.dart
    widgets/product_editor_sheet.dart
    widgets/vendor_shared_widgets.dart
```

Notes:

- `vendor_models.dart` currently appears to support catalog-related data and can stay there in the first pass.
- If some models are order-specific, split them later only after the move is stable.

### 3. Orders feature

Move order-specific files to:

```text
lib/features/orders/
  data/
    repositories/vendor_orders_repository.dart
    services/vendor_orders_service.dart
  domain/
  presentation/
    cubit/vendor_orders_cubit.dart
    screens/vendor_order_detail_screen.dart
```

### 4. Dashboard feature

Move dashboard/root flow files to:

```text
lib/features/dashboard/
  presentation/
    screens/vendor_dashboard_screen.dart
    screens/vendor_root_screen.dart
    vendor_app_shell.dart
```

Notes:

- `vendor_app.dart` is not really a generic vendor presentation file. It is the app shell that wires repositories, cubits, and the root screen.
- It should move to the feature that owns the startup flow. `dashboard/presentation/vendor_app_shell.dart` is the cleanest first-pass location.

### 5. Remove the vendor barrel folder pattern

Remove this file after imports are updated:

```text
lib/features/vendor/presentation/vendor_screens.dart
```

Reason:

- It hides ownership.
- It keeps unrelated screens grouped together.
- It works against feature-first navigation and maintenance.

## What Stays Where

These files should remain where they are for now:

```text
lib/main.dart
lib/app/app.dart
lib/core/navigation/app_navigation.dart
lib/core/network/*
lib/core/constants/*
lib/core/theme/*
lib/features/shared/app_scope.dart
```

Reason:

- They are app bootstrap, shared infrastructure, or cross-feature support.

## Import Update Rules

When moving files, only update imports.

Do not:

- change widget trees
- change bloc logic
- change repository behavior
- change service methods
- change route behavior
- change strings or translations

Allowed changes:

- file moves
- import path updates
- barrel export removal or replacement
- folder creation

## Safe Migration Order

Use this order to keep the app stable during the restructure:

1. Create the new feature folders.
2. Move data files first.
3. Move cubits and presentation helpers next.
4. Move screens last.
5. Update `vendor_app.dart` imports and relocate it.
6. Update `app/app.dart` to import the new shell path.
7. Remove the old `vendor_screens.dart` barrel.
8. Run `flutter analyze`.

## First-Pass Naming Policy

To avoid accidental behavior changes, keep existing file names in the first pass even if they still contain `vendor_` prefixes.

Examples:

- keep `vendor_auth_cubit.dart`
- keep `vendor_dashboard_screen.dart`
- keep `vendor_orders_repository.dart`

After the structure is stable and validated, a second pass can rename symbols and files if needed.

## Concrete Target Mapping

```text
FROM: lib/features/vendor/data/services/vendor_auth_service.dart
TO:   lib/features/auth/data/services/vendor_auth_service.dart

FROM: lib/features/vendor/data/repositories/vendor_auth_repository.dart
TO:   lib/features/auth/data/repositories/vendor_auth_repository.dart

FROM: lib/features/vendor/presentation/cubit/vendor_auth_cubit.dart
TO:   lib/features/auth/presentation/cubit/vendor_auth_cubit.dart

FROM: lib/features/vendor/presentation/screens/vendor_login_screen.dart
TO:   lib/features/auth/presentation/screens/vendor_login_screen.dart

FROM: lib/features/vendor/data/models/vendor_models.dart
TO:   lib/features/catalog/data/models/vendor_models.dart

FROM: lib/features/vendor/data/services/vendor_catalog_service.dart
TO:   lib/features/catalog/data/services/vendor_catalog_service.dart

FROM: lib/features/vendor/data/repositories/vendor_catalog_repository.dart
TO:   lib/features/catalog/data/repositories/vendor_catalog_repository.dart

FROM: lib/features/vendor/presentation/cubit/vendor_catalog_cubit.dart
TO:   lib/features/catalog/presentation/cubit/vendor_catalog_cubit.dart

FROM: lib/features/vendor/presentation/dialogs/category_dialog.dart
TO:   lib/features/catalog/presentation/dialogs/category_dialog.dart

FROM: lib/features/vendor/presentation/widgets/product_editor_sheet.dart
TO:   lib/features/catalog/presentation/widgets/product_editor_sheet.dart

FROM: lib/features/vendor/presentation/widgets/vendor_shared_widgets.dart
TO:   lib/features/catalog/presentation/widgets/vendor_shared_widgets.dart

FROM: lib/features/vendor/data/services/vendor_orders_service.dart
TO:   lib/features/orders/data/services/vendor_orders_service.dart

FROM: lib/features/vendor/data/repositories/vendor_orders_repository.dart
TO:   lib/features/orders/data/repositories/vendor_orders_repository.dart

FROM: lib/features/vendor/presentation/cubit/vendor_orders_cubit.dart
TO:   lib/features/orders/presentation/cubit/vendor_orders_cubit.dart

FROM: lib/features/vendor/presentation/screens/vendor_order_detail_screen.dart
TO:   lib/features/orders/presentation/screens/vendor_order_detail_screen.dart

FROM: lib/features/vendor/presentation/screens/vendor_dashboard_screen.dart
TO:   lib/features/dashboard/presentation/screens/vendor_dashboard_screen.dart

FROM: lib/features/vendor/presentation/screens/vendor_root_screen.dart
TO:   lib/features/dashboard/presentation/screens/vendor_root_screen.dart

FROM: lib/features/vendor/presentation/vendor_app.dart
TO:   lib/features/dashboard/presentation/vendor_app_shell.dart

REMOVE AFTER UPDATE:
lib/features/vendor/presentation/vendor_screens.dart
```

## Decision For This Repository

For this repository, the correct first action is:

1. Approve this move plan.
2. Apply the folder/file moves without changing code behavior.
3. Validate imports and analysis.

This keeps the project aligned with feature-first structure while preserving the current UI and logic exactly as they are.