// ignore_for_file: prefer_const_constructors

import 'package:chatapptute/pages/chat_page.dart';
import 'package:chatapptute/services/auth/AuthGate.dart';
import 'package:chatapptute/pages/settings_page.dart';

class Routes {
  static const authScreen = "authScreen";
  static const settingsScreen = "settingsScreen";
  static const chatScreen = "chatScreen";

  static final data = {
    authScreen: (context) => AuthGate(),
    settingsScreen: (context) => SettingsPage(),
    chatScreen: (context) => ChatPage(),
  };
}
