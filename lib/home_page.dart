import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:lang_demo/supported_langs.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final langState = appState.langState;
    if (!langState.localeReady) {
      debugPrint("Awaiting language initialization...");
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    // what the browser knows
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    final delegate = langState.delegate;
    // what this app supports
    final supportedLocales = delegate.supportedLocales;
    // what we're using right now
    final current = langState.currentLocale;

    final aDate = DateTime.now();
    final locale = appState.langState.dateNumericLocale;
    final numberFormat = NumberFormat(null, locale);
    final dateFormat = DateFormat(null, locale);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => showAboutDialog(
            context: context,
            applicationName: "Languages Demo",
            applicationLegalese:
                "This About dialog's buttons (below) should also be in the current-language",
          ),
          icon: const Icon(Icons.info_outline),
        ),
        title: const Text("Languages Demo"),
        actions: [
          DropdownButton<SupportedLangs>(
            value: SupportedLangs.fromCode(current.toString()),
            items: SupportedLangs.values
                .map(
                  (lang) => DropdownMenuItem<SupportedLangs>(
                    value: lang,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(lang.fullName),
                    ),
                  ),
                )
                .toList(),
            onChanged: (lang) async =>
                await appState.langState.setLocale(lang!.name),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Text("$current"),
            title: Text(
              "hello = ${translate("hello")}\n"
              "color = ${translate("color")}\n"
              "door = ${translate("door")}",
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              "Number: ${numberFormat.format(123456789)}\n"
              "Date: ${dateFormat.format(aDate)}",
            ),
          ),
          const Divider(),
          ListTile(
            title: Text("Supported locales: ${supportedLocales.join(", ")}"),
          ),
          const Divider(),
          ListTile(
            title: Text("System locales: ${systemLocales.join(", ")}"),
          ),
        ],
      ),
    );
  }
}
