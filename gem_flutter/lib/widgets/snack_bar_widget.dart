import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';

/// Class for displaying snack bars in the application.
class SnackBarWidget {
  static void showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: GlobalVariables.snackBarDurationInSec),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
