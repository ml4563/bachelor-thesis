import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:input_quantity/input_quantity.dart';

/// A widget for integer quantity input.
class InputQuantityIntWidget extends StatefulWidget {
  /// Minimum value for the input.
  final int minVal;

  /// Maximum value for the input.
  final int maxVal;

  /// Initial value for the input.
  final int initVal;

  /// Step increments for the input.
  final int steps;

  /// Callback function to handle changes in the input value.
  final ValueChanged<int> onChanged;

  const InputQuantityIntWidget({
    super.key,
    required this.minVal,
    required this.maxVal,
    required this.initVal,
    required this.steps,
    required this.onChanged,
  });

  @override
  InputQuantityIntWidgetState createState() => InputQuantityIntWidgetState();
}

class InputQuantityIntWidgetState extends State<InputQuantityIntWidget> {
  /// The current value of the input.
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initVal;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InputQty.int(
          maxVal: widget.maxVal,
          minVal: widget.minVal,
          initVal: widget.initVal,
          steps: widget.steps,
          messageBuilder: (minVal, maxVal, value) {
            return Text("${GlobalVariables.valueLabel} $value",
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                ),
                textAlign: TextAlign.center);
          },
          onQtyChanged: (value) {
            setState(() {
              currentValue = value;
              widget.onChanged(value);
            });
          },
          qtyFormProps: QtyFormProps(
              style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.onTertiary,
          )),
          decoration: QtyDecorationProps(
            contentPadding: GlobalVariables.mediumPadding,
            width: 50,
            fillColor: theme.colorScheme.tertiary,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(GlobalVariables.borderRadiusSize),
            ),
          ),
        ),
      ],
    );
  }
}
