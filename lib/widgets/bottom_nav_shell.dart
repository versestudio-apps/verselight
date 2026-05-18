import 'package:flutter/material.dart';

import '../screens/audio_screen.dart';
import '../screens/devotional_screen.dart';
import '../screens/home_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/plans_screen.dart';
import '../screens/shop_screen.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _index = 0;

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
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _destinations,
      ),
    );
  }
}
