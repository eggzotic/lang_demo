import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:lang_demo/app_state.dart';
import 'package:lang_demo/default_localization_delegate.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.langState.init();
  runApp(
    LocalizedApp(
      appState.langState.delegate,
      ChangeNotifierProvider.value(value: appState, child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    appState.langState.initContext(context);
    final delegate = appState.langState.delegate;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      localizationsDelegates: [
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultMaterialLocalizationDelegate(),
        DefaultCupertinoLocalizationDelegate(),
      ],
      supportedLocales: delegate.supportedLocales,
      locale: delegate.currentLocale,
    );
  }
}
