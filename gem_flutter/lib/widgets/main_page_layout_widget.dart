import 'package:flutter/material.dart';

/// A widget that provides a consistent layout for the main pages of the application.
class MainPageLayoutWidget extends StatelessWidget {
  /// The widget to be displayed as the main content of the page.
  final Widget child;

  const MainPageLayoutWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
