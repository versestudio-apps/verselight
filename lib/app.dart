import 'package:flutter/material.dart';

import 'utils/routes.dart';
import 'utils/theme.dart';
import 'widgets/bottom_nav_shell.dart';

class VerseLightApp extends StatelessWidget {
  const VerseLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VerseLight',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const BottomNavShell(),
      routes: AppRoutes.routes,
    );
  }
}
