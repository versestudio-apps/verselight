import 'package:flutter/material.dart';

import 'state/app_state.dart';
import 'utils/routes.dart';
import 'utils/theme.dart';
import 'widgets/app_state_scope.dart';
import 'widgets/bottom_nav_shell.dart';

class VerseLightApp extends StatefulWidget {
  const VerseLightApp({super.key});

  @override
  State<VerseLightApp> createState() => _VerseLightAppState();
}

class _VerseLightAppState extends State<VerseLightApp> {
  late final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _appState,
      child: MaterialApp(
        title: 'VerseLight',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const BottomNavShell(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
