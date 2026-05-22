import 'package:flutter/material.dart';

import '../screens/audio_screen.dart';
import '../screens/devotional_screen.dart';
import '../screens/home_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/plans_screen.dart';
import '../screens/shop_screen.dart';
import '../utils/constants.dart';
import 'app_state_scope.dart';

class BottomNavShell extends StatelessWidget {
  const BottomNavShell({super.key});

  // Audio tab is gated behind AppConstants.kEnableAudioTab (Phase 09J).
  // When the flag is false, Audio is dropped from both screens and
  // destinations so the visible bottom-nav layout stays in sync with the
  // index space used by AppState.selectTab.
  static List<Widget> get _screens => [
        const HomeScreen(),
        const DevotionalScreen(),
        const JournalScreen(),
        const PlansScreen(),
        if (AppConstants.kEnableAudioTab) const AudioScreen(),
        const ShopScreen(),
      ];

  static List<NavigationDestination> get _destinations => [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book_rounded),
          label: 'Devotional',
        ),
        const NavigationDestination(
          // Heart = prayer / personal journal — warmer than edit_note.
          icon: Icon(Icons.favorite_outline_rounded),
          selectedIcon: Icon(Icons.favorite_rounded),
          label: 'Journal',
        ),
        const NavigationDestination(
          // Route = a journey through Scripture — friendlier than a calendar.
          icon: Icon(Icons.route_outlined),
          selectedIcon: Icon(Icons.route_rounded),
          label: 'Plans',
        ),
        if (AppConstants.kEnableAudioTab)
          const NavigationDestination(
            icon: Icon(Icons.headphones_outlined),
            selectedIcon: Icon(Icons.headphones_rounded),
            label: 'Audio',
          ),
        const NavigationDestination(
          // Storefront = curated resources, less "sales-y" than shopping_bag.
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront_rounded),
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
