import 'package:flutter/material.dart';
import 'package:lang_demo/lang_state.dart';

class AppState with ChangeNotifier {
  late final langState = LangState(notify: notifyListeners);
}
