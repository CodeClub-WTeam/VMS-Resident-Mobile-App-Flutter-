
# Project Blueprint

## Overview

This document outlines the structure, design, and features of the VMS Resident App. It serves as a single source of truth for the application's implementation details.

## Style, Design, and Features

### Implemented

* **Feature-first architecture:** The project is organized by features, such as auth, home, and visitor_codes.
* **Navigation:** `go_router` is used for declarative routing.
* **State Management:** `provider` is used for state management.
* **Dependencies:**
    * `dio` for network requests.
    * `flutter_secure_storage` for secure storage.
    * `google_fonts` for custom fonts.
    * `intl` for internationalization.
    * `json_annotation` and `json_serializable` for JSON serialization.
    * `qr_flutter` for generating QR codes.
    * `font_awesome_flutter` for icons.
    * `url_launcher` for launching URLs.
    * `path_provider` for path management.
    * `share_plus` for sharing content.
    * `screenshot` for taking screenshots.
    * `http` for http requests.
    * `image_picker` for picking images.
    * `flutter_native_splash` for splash screen.

### Current Task: Theme Refactoring

#### Plan

1.  **Centralize Theme:** Refactor the `main.dart` file to create a centralized `ThemeData` for both light and dark modes.
    *   Use `ColorScheme.fromSeed` for a consistent color palette.
    *   Integrate `google_fonts` for typography.
    *   Use the `provider` package to create a theme provider for switching between light and dark modes.
2.  **Refactor `history_screen.dart`:** Update the `history_screen.dart` to use the new centralized theme from `Theme.of(context)` instead of hardcoded colors and styles.
3.  **Future Enhancements:**
    * Apply the centralized theme to all screens for a consistent look and feel.
    * Implement a settings screen where users can manually switch between light, dark, and system theme modes.

