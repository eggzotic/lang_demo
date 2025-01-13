# Flutter Language Demo

Demo project for making your Flutter app multi-lingual.

## Getting Started

Populate your asset files under `assets/i18n/` with all the strings from your app. Whereever your user-visible strings appear (most often inside `Text(...)` widgets, replace the string reference with `translate(<string_key>)`).

Note how we distinguish between system-locales (what your device supports) and available-locales (what your app supports) and how we access them:

```DART
    // what the browser knows
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    final delegate = LocalizedApp.of(context).delegate;
    // what this app supports
    final supportedLocales = delegate.supportedLocales;
    // what we're using right now
    final current = delegate.currentLocale;
```

To run this in debug mode in a browser, as ever:

```BASH
flutter run -d chrome
```

2025 Richard Shepherd