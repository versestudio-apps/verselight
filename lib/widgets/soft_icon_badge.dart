import 'package:flutter/material.dart';

import '../utils/theme.dart';

/// Rounded tinted square holding a single icon — used for quick-action
/// tiles, audio track artwork, feature lists, and empty-state hero icons.
class SoftIconBadge extends StatelessWidget {
  const SoftIconBadge({
    super.key,
    required this.icon,
    this.color = AppColors.warmGold,
    this.size = 44,
    this.iconSize,
    this.shape = SoftIconBadgeShape.rounded,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double? iconSize;
  final SoftIconBadgeShape shape;

  @override
  Widget build(BuildContext context) {
    final radius = shape == SoftIconBadgeShape.circle
        ? BorderRadius.circular(size / 2)
        : BorderRadius.circular(size * 0.28);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: radius,
      ),
      child: Icon(
        icon,
        size: iconSize ?? (size * 0.5),
        color: color,
      ),
    );
  }
}

enum SoftIconBadgeShape { rounded, circle }
