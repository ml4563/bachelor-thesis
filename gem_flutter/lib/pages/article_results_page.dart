import 'package:flutter/material.dart';
import 'package:gem_flutter/services/file_services.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:gem_flutter/widgets/card_container_widget.dart';
import 'package:gem_flutter/widgets/elevated_button_widget.dart';
import 'package:gem_flutter/widgets/icon_widget.dart';
import 'package:gem_flutter/widgets/main_container_widget.dart';
import 'package:gem_flutter/widgets/main_page_layout_widget.dart';
import 'package:gem_flutter/widgets/snack_bar_widget.dart';
import 'package:go_router/go_router.dart';

/// A stateful widget that displays the results page once an article
/// analysis has been completed. The page allows the user to download the
/// results and navigate back to the home page.
class ArticleResultsPage extends StatefulWidget {
  /// The name of the file containing the analysis results.
  final String fileName;

  const ArticleResultsPage({super.key, required this.fileName});

  @override
  ArticleResultsPageState createState() => ArticleResultsPageState();
}

class ArticleResultsPageState extends State<ArticleResultsPage> {
  /// Stores the data of the CSV file.
  List<List<dynamic>>? csvData;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  /// Loads the CSV data from the provided file.
  void _loadCsvData() async {
    try {
      final data = await FileServices().fetchAnalysisResults(widget.fileName);
      setState(() {
        csvData = data;
      });
    } catch (e) {
      _showSnackBar(GlobalVariables.errorLoadingCsvDataText);
    }
  }

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

  /// Decodes the value from the CSV data using the [CodingTable] mapping.
  String _decodeValue(String key, dynamic value) {
    if (CodingTable.codingMap.containsKey(key)) {
      return CodingTable.codingMap[key]?[value] ?? value.toString();
    }
    return value.toString();
  }

  /// Builds the content of the CSV file to be displayed.
  Widget _buildCsvContent() {
    if (csvData == null) {
      return const CircularProgressIndicator();
    }

    List<Widget> rows = [];
    for (int i = 1; i < csvData!.length; i++) {
      for (int j = 0; j < csvData![i].length; j++) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    csvData![0][j].toString(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                  ),
                ),
                GlobalVariables.smallhorizontalSizedBox,
                Expanded(
                  flex: 4,
                  child: Text(
                    _decodeValue(csvData![0][j].toString(), csvData![i][j]),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
        if (j < csvData![i].length - 1) {
          rows.add(const Divider());
        }
      }
    }

    return Column(
      children: rows,
    );
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
                  size: GlobalVariables.sizeMediumIcon),
              GlobalVariables.mediumVerticalSizedBox,
              // Build CSV content
              CardContainerWidget(
                cardTitle: GlobalVariables.resultsText,
                child: SelectionArea(
                  child: _buildCsvContent(),
                ),
              ),
              GlobalVariables.mediumVerticalSizedBox,
              // Button to download analysis results
              ElevatedButtonWidget(
                text: GlobalVariables.downloadResultsButtonText,
                onPressed: () {
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
