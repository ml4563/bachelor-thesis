import 'package:flutter/material.dart';
import 'package:gem_flutter/services/file_services.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:gem_flutter/widgets/elevated_button_widget.dart';
import 'package:gem_flutter/widgets/icon_widget.dart';
import 'package:gem_flutter/widgets/main_container_widget.dart';
import 'package:gem_flutter/widgets/main_page_layout_widget.dart';
import 'package:gem_flutter/widgets/snack_bar_widget.dart';
import 'package:go_router/go_router.dart';

/// A stateless widget that displays the results page once the analysis of
/// multiple articles has been completed. The page allows the user to download the
/// results and navigate back to the home page.
class ArticlesResultsPage extends StatefulWidget {
  /// The name of the file containing the analysis results.
  final String fileName;

  const ArticlesResultsPage({super.key, required this.fileName});

  @override
  ArticlesResultsPageState createState() => ArticlesResultsPageState();
}

class ArticlesResultsPageState extends State<ArticlesResultsPage> {
  /// Displays a snack bar with the given message.
  void _showSnackBar(String message) {
    SnackBarWidget.showSnackBar(context, message);
  }

  /// Downloads the analysis results file.
  void _downloadResults(String fileName) async {
    try {
      FileServices().downloadAnalysisResults(fileName);
    } catch (e) {
      _showSnackBar("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPageLayoutWidget(
        child: MainContainerWidget(
          title: GlobalVariables.analysisCompletedTitle,
          child: Column(
            children: [
              // Icon
              const IconWidget(
                icon: Icons.check_circle_rounded,
                color: Colors.green,
                size: GlobalVariables.sizeMediumIcon,
              ),
              GlobalVariables.mediumVerticalSizedBox,
              // Button to download analysis results
              ElevatedButtonWidget(
                text: GlobalVariables.downloadResultsButtonText,
                onPressed: () async {
                  _downloadResults(widget.fileName);
                },
                icon: Icons.download_rounded,
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
