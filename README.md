# Qunova Antripe - Flutter Contact Management App

A professional Flutter application for managing contacts, featuring creative animations, robust API integration, and a premium UI design.

## Features
- **Splash Screen**: Smooth, professional animations with brand logo fade-in and sliding welcome sheet.
- **Home Screen**:
  - **API Integration**: Fetches contact data from `https://api.antripe.com/v1/contact/api.json`.
  - **Category Filtering**: Horizontal scroll for categories with active selection tracking.
  - **Search**: Real-time debounced search by name or phone number.
  - **Tab Navigation**: "Contact" and "Recent" tabs with animated indicators.
- **Add Contact**: Sleek bottom sheet for adding new contacts with validation.

## Tech Stack & Libraries
- **Flutter SDK**: `^3.10.8`
- **[GetX](https://pub.dev/packages/get)**: Used for high-performance state management, dependency injection, and advanced navigation logic.
- **[Dio](https://pub.dev/packages/dio)**: Handles HTTP networking with better timeout support and interceptors.
- **[Flutter SVG](https://pub.dev/packages/flutter_svg)**: Renders high-quality vector graphics for FAB and logos.
- **[Google Fonts](https://pub.dev/packages/google_fonts)**: Dynamically loads the **Inter** font family as specified in the UI design.
- **[Lucide Icons](https://pub.dev/packages/lucide_icons)**: Provides modern, consistent iconography.
- **[Country Picker](https://pub.dev/packages/country_picker)**: Enables elegant, interactive country flag and phone prefix selection.
- **[Cached Network Image](https://pub.dev/packages/cached_network_image)**: Efficiently fetches and caches contact avatars to reduce data usage.
- **[Shimmer](https://pub.dev/packages/shimmer)**: Provides elegant loading placeholders (skeleton screens) while data is being fetched.

## Setup & Running the App

### Prerequisites
- Flutter SDK installed (Version 3.10.8 or higher recommended).
- Android Studio / VS Code with Flutter extension.
- Chrome or an Emulator (iOS/Android).

### Installation Steps
1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd qunova_antripe
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   # For any available device
   flutter run

   # For Chrome
   flutter run -d chrome
   ```

## Assumptions & Design Decisions
- **Responsive Layout**: The design was provided for a 390px width screen. A global scaling factor (`scale = screenWidth / 390.0`) was implemented to ensure the UI feels premium across different phone sizes.
- **Data Management**: The "All" category is injected locally into the category list if not provided by the API to ensure a better UX for viewing the full list.
- **Recent Activity**: The "Recent" tab dynamically displays contacts that the user has tapped on or newly created during the current session.
- **Empty States**: Custom-styled empty states were built from CSS specs to provide a user-friendly experience when no data is found or errors occur.

## Project Structure
- `lib/core`: App themes and constants.
- `lib/data`: Data models and API services.
- `lib/features`: Feature-based architecture (Splash, Home) containing Views, Controllers, and Widgets.
- `lib/routes`: Application routing configuration.
