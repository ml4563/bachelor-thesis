import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:input_quantity/input_quantity.dart';

/// A widget for double quantity input.
class InputQuantityDoubleWidget extends StatefulWidget {
  /// Minimum value for the input.
  final double minVal;

  /// Maximum value for the input.
  final double maxVal;

  /// Initial value for the input.
  final double initVal;

  /// Step increments for the input.
  final double steps;

  /// Callback function to handle changes in the input value.
  final ValueChanged<double> onChanged;

  const InputQuantityDoubleWidget({
    super.key,
    required this.minVal,
    required this.maxVal,
    required this.initVal,
    required this.steps,
    required this.onChanged,
  });

  @override
  InputQuantityDoubleWidgetState createState() =>
      InputQuantityDoubleWidgetState();
}

class InputQuantityDoubleWidgetState extends State<InputQuantityDoubleWidget> {
  /// The current value of the input.
  late double currentValue;

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
        InputQty(
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
                      BorderRadius.circular(GlobalVariables.borderRadiusSize))),
        ),
      ],
    );
  }
}
