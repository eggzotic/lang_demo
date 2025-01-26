import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'supported_langs.dart';

class LangState {
  LangState({required this.notify});
  final void Function() notify;

  final fallback = 'en_US';

  Locale get currentLocale => delegate.currentLocale;

  final _systemLocales = WidgetsBinding.instance.platformDispatcher.locales;

  LocalizationDelegate? _delegate;
  LocalizationDelegate get delegate =>
      _delegate ?? (throw _lateInitError("delegate"));
  Future<void> init() async {
    if (_delegate != null) return;
    _delegate = await LocalizationDelegate.create(
      fallbackLocale: fallback,
      supportedLocales: SupportedLangs.allCodes,
      basePath: 'assets/i18n/',
    );
    await initializeDateFormatting();
  }

  /// Should be the top-level BuildContext of this app
  BuildContext get context => _topContext ?? (throw _lateInitError("context"));
  BuildContext? _topContext;

  /// Call once: to pass in the top-level BuildContext + initial locale
  // void init(BuildContext context, String locale) {
  void initContext(BuildContext context) {
    if (_topContext != null) return;
    _topContext = context;
    // Find the 1st client/device-language that we support
    String? locale;
    for (final lang in _systemLocales) {
      if (delegate.supportedLocales.contains(lang)) {
        debugPrint("Initial locale = $lang");
        locale = lang.toString();
        break;
      } else {
        debugPrint("Skipping unsupported locale: $lang");
      }
    }
    // last-restort - use US English
    if (locale == null) {
      debugPrint("No supported languages found - using $fallback");
      locale = fallback;
    }
    setLocale(locale, true)
        .then((_) => debugPrint("Language init complete: $locale"));
  }

  bool _localeReady = false;

  /// Whether the new `locale` is ready to use (e.g. for `translate`())
  bool get localeReady => _localeReady;

  Exception _lateInitError(String item) =>
      Exception("$item: You must call initContext before accessing this!");

  String? _dateNumericLocale;

  /// Use as `locale` parameter to `NumberFormat()` and `DateFormat()`
  String get dateNumericLocale =>
      _dateNumericLocale ?? (throw _lateInitError("dateNumericLocale"));

  Future<void> setLocale(String localeName, [bool init = false]) async {
    _localeReady = false;
    // necessary when setLocale is called from init, i.e from a Widget.build()
    if (!init) notify();

    // this try-wrapper avoids a crash if/when the language files are not-found
    try {
      // change language first - any errors here will abort the following
      await changeLocale(context, localeName);
      debugPrint("Lang-state   current: $localeName");
      debugPrint("Localization current: $currentLocale");
      // Deal with unknown (to Flutter(!)) languages w.r.t Dates, numbers
      // NZ Maori
      final thisLocale = localeName == "mi" ? "en_NZ" : localeName;
      // could alternatively use DateFormat.localeExists(...) here
      final localeExists = NumberFormat.localeExists(thisLocale);
      _dateNumericLocale = localeExists ? thisLocale : fallback;
      if (_dateNumericLocale != localeName) {
        debugPrint("Alternate date/numeric locale: $_dateNumericLocale");
      }
    } catch (e) {
      debugPrint("Change locale error: $e");
    } finally {
      _localeReady = true;
      notify();
    }
  }
}
