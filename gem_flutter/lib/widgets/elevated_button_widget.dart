import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// A custom elevated button widget with optional icon and customizable properties.
class ElevatedButtonWidget extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// The icon to display on the button (optional).
  final IconData? icon;

  const ElevatedButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.onSecondary,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(GlobalVariables.borderRadiusSize),
          ),
          padding: GlobalVariables.bigPadding),
      icon: icon != null ? Icon(icon) : Container(),
      label: Text(text,
          style: theme.textTheme.displayMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
          )),
    );
  }
}
