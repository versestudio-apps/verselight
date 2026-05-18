import 'package:flutter/material.dart';

import '../utils/theme.dart';

/// Renders a devotional asset (PNG in `assets/images/devotional/`) with a
/// graceful gradient fallback when the file is missing.
///
/// The PNGs are AI-generated app-owned artwork that ships in a later pass —
/// the fallback keeps the UI building and looking on-brand in the meantime.
class DevotionalImage extends StatelessWidget {
  const DevotionalImage({
    super.key,
    required this.assetPath,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.auto_stories_rounded,
    this.overlay,
    this.semanticLabel,
  });

  /// Path under `assets/` — typically a `DevotionalImages.*` constant.
  final String assetPath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  /// Drawn over the bottom of the image (e.g. text on a hero).
  final Widget? overlay;

  /// Icon shown inside the gradient fallback when the asset cannot load.
  final IconData fallbackIcon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadii.card);

    final image = Image.asset(
      assetPath,
      height: height,
      width: width,
      fit: fit,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stack) => _Fallback(
        height: height,
        width: width,
        icon: fallbackIcon,
      ),
      // Avoid the default grey loading flash — the fallback covers this.
      gaplessPlayback: true,
    );

    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          image,
          if (overlay != null) Positioned.fill(child: overlay!),
        ],
      ),
    );
  }
}

/// Gentle gradient placeholder used when a PNG hasn't shipped yet.
class _Fallback extends StatelessWidget {
  const _Fallback({this.height, this.width, required this.icon});

  final double? height;
  final double? width;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFEAF1F6), // soft Marian blue tint
            Color(0xFFFFF6E1), // warm soft gold
            Color(0xFFFAF7F0), // ivory
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 36,
        color: AppColors.warmGold.withValues(alpha: 0.55),
      ),
    );
  }
}

/// Convenience: a [DevotionalImage] sized like a hero banner (16:9-ish).
class DevotionalHeroImage extends StatelessWidget {
  const DevotionalHeroImage({
    super.key,
    required this.assetPath,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.overlay,
    this.darken = 0.18,
    this.semanticLabel,
  });

  final String assetPath;
  final double aspectRatio;
  final BorderRadius? borderRadius;

  /// Optional widget drawn on top (e.g. title + verse).
  final Widget? overlay;

  /// 0–1 darkening applied at the bottom for legible text. Set to 0 for none.
  final double darken;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadii.card);
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: DevotionalImage(
        assetPath: assetPath,
        fit: BoxFit.cover,
        borderRadius: radius,
        semanticLabel: semanticLabel,
        overlay: Stack(
          fit: StackFit.expand,
          children: [
            if (darken > 0)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: darken),
                    ],
                    stops: const [0.55, 1.0],
                  ),
                ),
              ),
            if (overlay != null) overlay!,
          ],
        ),
      ),
    );
  }
}
