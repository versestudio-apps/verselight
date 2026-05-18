import 'package:flutter/material.dart';

import '../screens/audio_screen.dart';
import '../screens/devotional_screen.dart';
import '../screens/home_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/plans_screen.dart';
import '../screens/shop_screen.dart';
import 'app_state_scope.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key});

  static const _screens = [
    HomeScreen(),
    DevotionalScreen(),
    JournalScreen(),
    PlansScreen(),
    AudioScreen(),
    ShopScreen(),
  ];

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.menu_book_outlined),
      selectedIcon: Icon(Icons.menu_book_rounded),
      label: 'Devotional',
    ),
    NavigationDestination(
      icon: Icon(Icons.edit_note_outlined),
      selectedIcon: Icon(Icons.edit_note_rounded),
      label: 'Journal',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today_rounded),
      label: 'Plans',
    ),
    NavigationDestination(
      icon: Icon(Icons.headphones_outlined),
      selectedIcon: Icon(Icons.headphones_rounded),
      label: 'Audio',
    ),
    NavigationDestination(
      icon: Icon(Icons.shopping_bag_outlined),
      selectedIcon: Icon(Icons.shopping_bag_rounded),
      label: 'Shop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: appState.tabIndex,
            children: _screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: appState.tabIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: appState.selectTab,
            destinations: _destinations,
          ),
        );
      },
    );
  }
}
