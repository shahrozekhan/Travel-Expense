import 'package:fcc/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../screens/dashboard/home/add_travel_expense_screen.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';

GoRouter getRouters() {
  return GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
          path: "/DashBoardScreen",
          builder: (context, state) => const DashBoardScreen(),
          routes: [
            GoRoute(
              path: "AddExpense",
              builder: (context, state) => const AddExpense(),
            ),
          ]),
      GoRoute(
        path: "/AuthScreen",
        builder: (context, state) => const AuthScreen(),
      )
    ],
  );
}

// void screenSwitcher(ScreenName screen, BuildContext context) {
//   Widget? screenWidget;
//   switch (screen) {
//     case ScreenName.Splash:
//       screenWidget = const SplashScreen();
//       break;
//     case ScreenName.Dashboard:
//       screenWidget = const DashBoardScreen();
//       break;
//     case ScreenName.AddTravelExpense:
//       screenWidget = const AddExpense();
//       break;
//     case ScreenName.Authentication:
//       screenWidget = const AuthScreen();
//       break;
//     case ScreenName.ConvertCurrencies:
//       screenWidget = const AuthScreen();
//       break;
//     case ScreenName.CurrencySearch:
//       screenWidget = const AuthScreen();
//       break;
//     case ScreenName.ExpenseList:
//       screenWidget = const AuthScreen();
//       break;
//   }
//
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//           screenWidget ?? (throw Exception("Screen must be defined!"))));
// }
