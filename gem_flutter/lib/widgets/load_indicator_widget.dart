import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// A widget that displays a loading indicator with a message.
class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          GlobalVariables.smallVerticalSizedBox,
          Text(
            GlobalVariables.analysisInProgressText,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
