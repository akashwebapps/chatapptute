import 'package:chatapptute/services/auth/AuthGate.dart';
import 'package:chatapptute/firebase_options.dart';
import 'package:chatapptute/services/auth/login_or_register.dart';
import 'package:chatapptute/pages/login_page.dart';
import 'package:chatapptute/routes/Routes.dart';
import 'package:chatapptute/themes/light_mode.dart';
import 'package:chatapptute/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context, listen: true).themeData,
      routes: Routes.data,
      initialRoute: Routes.authScreen,
    );
  }
}
