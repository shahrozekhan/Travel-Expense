import 'package:fcc/screens/add_travel_expense.dart';
import 'package:fcc/screens/auth/auth.dart';
import 'package:fcc/screens/dashboard_screen.dart';
import 'package:fcc/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'common/screens_enum.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

void screenSwitcher(ScreenName screen, BuildContext context) {
  Widget? screenWidget;
  switch (screen) {
    case ScreenName.Splash:
      screenWidget = const SplashScreen();
      break;
    case ScreenName.Dashboard:
      screenWidget = const DashBoardScreen();
      break;
    case ScreenName.AddTravelExpense:
      screenWidget = const AddExpense();
      break;
    case ScreenName.Authentication:
      screenWidget = const AuthScreen();
      break;
  }

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              screenWidget ?? (throw Exception("Screen must be defined!"))));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
