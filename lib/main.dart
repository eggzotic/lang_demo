import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'home_page.dart';

void main() async {
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: [
      'en_US',
      'en_GB',
      'es',
      // deliberately including this here, without the corresponding asset file,
      //  `en.json`, to observe the behaviour (in debug-mode)
      'en',
    ],
    basePath: 'assets/i18n/',
  );
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var delegate = LocalizedApp.of(context).delegate;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      localizationsDelegates: [delegate],
      supportedLocales: delegate.supportedLocales,
      locale: delegate.currentLocale,
    );
  }
}
