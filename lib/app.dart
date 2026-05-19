import 'package:flutter/material.dart';

import 'services/local_storage_service.dart';
import 'state/app_state.dart';
import 'utils/routes.dart';
import 'utils/theme.dart';
import 'widgets/app_state_scope.dart';
import 'widgets/bottom_nav_shell.dart';
import 'widgets/brand_splash.dart';

class VerseLightApp extends StatefulWidget {
  const VerseLightApp({super.key});

  @override
  State<VerseLightApp> createState() => _VerseLightAppState();
}

class _VerseLightAppState extends State<VerseLightApp> {
  late final AppState _appState = AppState();
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await LocalStorageService.instance.initialize();
      await _appState.loadFromStorage();
    } catch (e, st) {
      debugPrint('[VerseLightApp] bootstrap failed: $e\n$st');
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const BrandSplash(),
      );
    }

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
