import 'package:fcc/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common/screens_enum.dart';
import '../main.dart';
import 'home_screen.dart';

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
            screenSwitcher(ScreenName.AddTravelExpense, context);
          },
          icon: const Icon(Icons.add))
    ];
  } else {
    return [
      IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
            screenSwitcher(ScreenName.Authentication, context);
          },
          icon: const Icon(Icons.exit_to_app))
    ];
  }
}

class _DashBoardScreen extends State<DashBoardScreen> {
  final String assetName = 'icons/splash_logo.svg';

  @override
  Widget build(BuildContext context) {
    _selectedTabScreen();

    return Scaffold(
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
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
    );
  }

  Widget? _selectedTabScreen() {
    if (_selectedIndex == 0) {
      selectedTab = const HomeScreen();
    } else if (_selectedIndex == 0) {
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
