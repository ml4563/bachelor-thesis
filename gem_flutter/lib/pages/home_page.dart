import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:gem_flutter/widgets/elevated_button_widget.dart';
import 'package:gem_flutter/widgets/main_container_widget.dart';
import 'package:gem_flutter/widgets/main_page_layout_widget.dart';
import 'package:go_router/go_router.dart';

/// A StatelessWidget that represents the home page in the application.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPageLayoutWidget(
        child: MainContainerWidget(
          title: GlobalVariables.welcomeText,
          child: Column(
            children: [
              // Button to go to the analysis page for a single article
              ElevatedButtonWidget(
                text: GlobalVariables.articleButtonText,
                onPressed: () {
                  context.go(AppRouteConfiguration.articlePath);
                },
                icon: Icons.keyboard_arrow_right_rounded,
              ),
              GlobalVariables.mediumVerticalSizedBox,
              // Button to go to the analysis page of several articles
              ElevatedButtonWidget(
                text: GlobalVariables.articlesButtonText,
                onPressed: () {
                  context.go(AppRouteConfiguration.articlesPath);
                },
                icon: Icons.keyboard_arrow_right_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
