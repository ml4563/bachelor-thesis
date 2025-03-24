import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// A text field widget with customizable properties.
class TextFieldWidget extends StatelessWidget {
  /// The controller for the text field, which allows for text manipulation and retrieval.
  final TextEditingController controller;

  /// The hint text displayed when the text field is empty.
  final String? hintText;

  /// The minimum number of lines for the text field.
  final int minLines;

  /// The maximum number of lines for the text field.
  final int maxLines;

  /// A callback function that is triggered whenever the text in the text field changes.
  final ValueChanged<String>? onChanged;

  const TextFieldWidget({
    super.key,
    required this.controller,
    this.hintText,
    required this.minLines,
    required this.maxLines,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      style: theme.textTheme.displaySmall,
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GlobalVariables.borderRadiusSize),
        ),
        filled: true,
        fillColor: theme.colorScheme.tertiary,
        hintText: hintText,
        hintStyle: theme.textTheme.displaySmall,
        contentPadding: GlobalVariables.mediumPadding,
      ),
    );
  }
}
