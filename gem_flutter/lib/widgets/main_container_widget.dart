import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// A container widget that serves as a primary layout element .
class MainContainerWidget extends StatelessWidget {
  /// The child widget that will be displayed inside the container.
  final Widget child;

  /// The title that will be displayed at the top of the container.
  final String title;

  const MainContainerWidget({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: GlobalVariables.bigPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(GlobalVariables.borderRadiusSize),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          GlobalVariables.smallVerticalSizedBox,
          child,
        ],
      ),
    );
  }
}
