import 'package:auth_repo/addexpense/add_expense_repo.dart';
import 'package:auth_repo/authrepo/auth_repository.dart';
import 'package:fcc/screens/bloc/authentication/authentication_bloc.dart';
import 'package:fcc/screens/dashboard/home/add_travel_expense_screen.dart';
import 'package:fcc/screens/auth/auth_screen.dart';
import 'package:fcc/screens/dashboard/dashboard_screen.dart';
import 'package:fcc/screens/bloc/expense/add_expense_bloc.dart';
import 'package:fcc/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/Routes/routes.dart';
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
    case ScreenName.ConvertCurrencies:
      screenWidget = const AuthScreen();
      break;
    case ScreenName.CurrencySearch:
      screenWidget = const AuthScreen();
      break;
    case ScreenName.ExpenseList:
      screenWidget = const AuthScreen();
      break;
  }

  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              screenWidget ?? (throw Exception("Screen must be defined!"))));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  late final AuthenticationRepository _authenticationRepository;
  late final ExpenseRepository _addExpenseRepository;

  @override
  void initState() {
    _authenticationRepository = AuthenticationRepository();
    _addExpenseRepository = ExpenseRepository();
    super.initState();
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    _addExpenseRepository.dispose();
    super.dispose();
  }

  var kColorScheme =
      ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 96, 141, 255));

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: _authenticationRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (_) => AuthenticationBloc(
                      authenticationRepository: _authenticationRepository,
                    )),
            BlocProvider(
                create: (_) =>
                    ExpenseBloc(addExpenseRepository: _addExpenseRepository))
          ],
          child: MaterialApp.router(
            theme: ThemeData().copyWith(
                colorScheme: kColorScheme,
                appBarTheme: AppBarTheme().copyWith(
                    foregroundColor: kColorScheme.primaryContainer,
                    backgroundColor: kColorScheme.primary)),
            routerConfig: getRouters(),
            title: "Travel Expense",
          ),
        ));
  }
}
