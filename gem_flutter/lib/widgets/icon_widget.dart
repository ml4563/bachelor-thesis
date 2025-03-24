import 'package:flutter/material.dart';

/// A widget that displays an icon.
class IconWidget extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// The color of the icon.
  final Color? color;

  /// The size of the icon.
  final double size;

  const IconWidget({
    super.key,
    required this.icon,
    this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(
      icon,
      color: color ?? theme.iconTheme.color,
      size: size,
    );
  }
}
