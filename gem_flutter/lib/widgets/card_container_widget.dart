import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// A custom widget that displays a card container with a title and child widget.
class CardContainerWidget extends StatelessWidget {
  /// The title text displayed at the top of the card.
  final String cardTitle;

  /// The widget content to be displayed within the card.
  final Widget child;

  const CardContainerWidget({
    super.key,
    required this.cardTitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: GlobalVariables.mediumPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(GlobalVariables.borderRadiusSize),
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              cardTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ),
          GlobalVariables.smallVerticalSizedBox,
          child,
        ],
      ),
    );
  }
}
