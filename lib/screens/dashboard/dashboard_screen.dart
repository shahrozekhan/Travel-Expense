import 'package:auth_repo/authrepo/auth_repository.dart';
import 'package:fcc/screens/bloc/authentication/authentication_bloc.dart';
import 'package:fcc/screens/dashboard/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'home/home_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashBoardScreen();
  }
}

int _selectedIndex = 0;
Widget? selectedTab;

List<Widget> getSelectedTab(BuildContext context, int selectedIndex) {
  if (selectedIndex == 0) {
    return [
      IconButton(
          onPressed: () {
            context.go("/DashBoardScreen/AddExpense");
          },
          icon: const Icon(Icons.add))
    ];
  } else {
    return [
      IconButton(
          onPressed: () {
            GoToAuthScreen(context);
          },
          icon: const Icon(Icons.exit_to_app))
    ];
  }
}

void GoToAuthScreen(BuildContext context) async {
  context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());
}

class _DashBoardScreen extends State<DashBoardScreen> {
  final String assetName = 'icons/splash_logo.svg';

  @override
  Widget build(BuildContext context) {
    _selectedTabScreen();

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (ctx, state) {
        if (state.status == AuthenticationStatus.unauthenticated) {
          context.go("/AuthScreen");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Travel Expense"),
          actions: [...getSelectedTab(context, _selectedIndex)],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            _selectedIndex = index;
            _switchTab();
          },
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.trending_up), label: "Expense"),
            // BottomNavigationBarItem(icon: Icon(Icons.money), label: "Convertor"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ],
          selectedItemColor: Colors.black,
          // Color of selected item
          unselectedItemColor: Colors.grey,
          // Color of unselected items
          selectedLabelStyle: const TextStyle(color: Colors.black),
          // Label color of selected item
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
        ),
        body: selectedTab,
      ),
    );
  }

  Widget? _selectedTabScreen() {
   if (_selectedIndex == 0) {
      selectedTab = const HomeScreen();
    } else {
      selectedTab = const SettingsScreen();
    }
  }

  void _switchTab() {
    setState(() {
      _selectedTabScreen();
    });
  }
}
