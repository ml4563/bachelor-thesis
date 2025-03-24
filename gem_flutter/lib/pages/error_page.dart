import 'package:flutter/material.dart';
import 'package:gem_flutter/widgets/main_page_layout_widget.dart';
import 'package:go_router/go_router.dart';

import '../utils/global_variables.dart';
import '../widgets/elevated_button_widget.dart';
import '../widgets/icon_widget.dart';
import '../widgets/main_container_widget.dart';

/// A StatelessWidget that represents the error page in the application.
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPageLayoutWidget(
        child: MainContainerWidget(
          title: GlobalVariables.errorPageText,
          child: Column(
            children: [
              // Icon
              const IconWidget(
                icon: Icons.cancel_rounded,
                color: Colors.red,
                size: GlobalVariables.sizeMediumIcon,
              ),
              GlobalVariables.mediumVerticalSizedBox,
              // Button to return to home page
              ElevatedButtonWidget(
                text: GlobalVariables.backHomeButtonText,
                onPressed: () {
                  context.goNamed(AppRouteConfiguration.homeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
