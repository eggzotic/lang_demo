import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // what the browser knows
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    final delegate = LocalizedApp.of(context).delegate;
    // what this app supports
    final supportedLocales = delegate.supportedLocales;
    // what we're using right now
    final current = delegate.currentLocale;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Languages Demo"),
        actions: [
          DropdownButton<Locale>(
            menuWidth: 100,
            value: current,
            items: supportedLocales
                .map((l) => DropdownMenuItem<Locale>(
                      value: l,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(l.toString()),
                      ),
                    ))
                .toList(),
            onChanged: (locale) async {
              await changeLocale(context, locale.toString());
              // Now rebuild this widget
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Text("$current"),
            title: Text(
              "${translate("hello")}\n"
              "${translate("color")}\n"
              "${translate("door")}",
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
