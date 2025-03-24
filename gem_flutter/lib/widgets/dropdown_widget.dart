import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// A widget that provides a dropdown menu with customizable items and a label.
class DropdownWidget extends StatefulWidget {
  /// The label to display above the dropdown menu.
  final String label;

  /// The currently selected value in the dropdown menu.
  final String value;

  /// The list of items to display in the dropdown menu.
  final List<String> items;

  /// The callback function to handle value changes.
  final Function(String?) onChanged;

  const DropdownWidget({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget> {
  /// The currently selected value in the dropdown menu.
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSecondary,
          ),
        ),
        GlobalVariables.smallVerticalSizedBox,
        // Dropdown menu
        SizedBox(
          width: 250,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedValue,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.tertiary,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(GlobalVariables.borderRadiusSize),
              ),
            ),
            dropdownColor: theme.colorScheme.tertiary,
            iconEnabledColor: theme.colorScheme.onTertiary,
            style: theme.textTheme.displaySmall
                ?.copyWith(color: theme.colorScheme.onTertiary),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
                widget.onChanged(newValue);
              });
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(
                  child: Text(
                    value,
                    style: theme.textTheme.displaySmall
                        ?.copyWith(color: theme.colorScheme.onTertiary),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
