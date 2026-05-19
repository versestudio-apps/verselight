import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/theme.dart';

/// Branded bootstrap screen shown while local storage / app state load.
/// Bridges the native Android launch screen (cream + centered symbol) to
/// the Home screen so the user never sees a bare spinner on a blank canvas.
class BrandSplash extends StatelessWidget {
  const BrandSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'VerseLight',
                style: GoogleFonts.lora(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepNavy,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A quiet moment with God',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.slate,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.warmGold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
