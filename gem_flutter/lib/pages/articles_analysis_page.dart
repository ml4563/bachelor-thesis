import 'package:flutter/material.dart';
import 'package:gem_flutter/models/article.dart';
import 'package:gem_flutter/models/chat_gpt_parameters.dart';
import 'package:gem_flutter/models/articles_analysis_request.dart';
import 'package:gem_flutter/services/api_services.dart';
import 'package:gem_flutter/services/file_services.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:gem_flutter/widgets/elevated_button_widget.dart';
import 'package:gem_flutter/widgets/card_container_widget.dart';
import 'package:gem_flutter/widgets/parameters_information_floating_action_button_widget.dart';
import 'package:gem_flutter/widgets/load_indicator_widget.dart';
import 'package:gem_flutter/widgets/main_container_widget.dart';
import 'package:gem_flutter/widgets/chat_gpt_parameters_container_widget.dart';
import 'package:gem_flutter/widgets/main_page_layout_widget.dart';
import 'package:gem_flutter/widgets/snack_bar_widget.dart';
import 'package:gem_flutter/widgets/text_field_widget.dart';
import 'package:go_router/go_router.dart';

/// A StatefulWidget that allows the user to analyze multiple articles using
/// OpenAI's ChatGPT model. This page includes functionalities to upload an
/// Excel file containing articles, set various parameters for the analysis,
/// and download the csv template.
class ArticlesAnalysisPage extends StatefulWidget {
  const ArticlesAnalysisPage({super.key});

  @override
  ArticlesAnalysisPageState createState() => ArticlesAnalysisPageState();
}

class ArticlesAnalysisPageState extends State<ArticlesAnalysisPage> {
  final APIServices apiServices = APIServices();

  /// TextEditingController for the prompt text field.
  final TextEditingController promptController =
      TextEditingController(text: GlobalVariables.promptValue);

  /// Map to store ChatGPT parameters.
  Map<String, dynamic> chatGptParameters = {
    'model': GlobalVariables.modelValue,
    'content': GlobalVariables.systemMessageContentValue,
    'frequencyPenalty': GlobalVariables.frequencyPenaltyValue,
    'presencePenalty': GlobalVariables.presencePenaltyValue,
    'temperature': GlobalVariables.temperatureValue,
    'topP': GlobalVariables.topPValue,
    'maxTokens': GlobalVariables.maxTokensValue,
    'threshold': GlobalVariables.thresholdWordValue,
  };

  /// Flag to indicate whether the app is currently loading data.
  bool isLoading = false;

  /// List to store uploaded articles.
  List<Article>? uploadedArticles;

  /// Updates the ChatGPT parameters.
  void _updateChatGptParameters(String key, dynamic value) {
    setState(() {
      chatGptParameters[key] = value;
    });
  }

  /// Submits the analysis request and handles the API call.
  void _analyzeArticles() async {
    if (!_validateFile()) {
      _showSnackBar(GlobalVariables.fileMissingMsg);
      return;
    }

    if (!_validateInputs()) {
      _showSnackBar(GlobalVariables.fillAllFieldsMsg);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      setState(() {
        isLoading = true;
      });

      final chatGptParameters = _createChatGptParameters();
      final request = ArticlesAnalysisRequest(
        articles: uploadedArticles,
        parameters: chatGptParameters,
      );

      final response = await apiServices.analyseArticles(request);

      setState(() {
        isLoading = false;
      });
      _goToResultPage(response);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar("$e");
    }
  }

  /// Navigates to the result page with the given file name.
  void _goToResultPage(String fileName) {
    context.goNamed(AppRouteConfiguration.articlesResultsName,
        pathParameters: {'fileName': fileName});
  }

  ///
  bool _validateFile() {
    if (uploadedArticles == null ||
        uploadedArticles!.isEmpty ||
        promptController.text.isEmpty) {
      return false;
    }
    return true;
  }

  /// Validates the inputs before submission.
  bool _validateInputs() {
    for (var param in chatGptParameters.values) {
      if (param == null || param.toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  /// Creates a ChatGptParameters object from the input data.
  ChatGptParameters _createChatGptParameters() {
    return ChatGptParameters(
      prompt: promptController.text,
      model: chatGptParameters['model'],
      content: chatGptParameters['content'],
      topP: chatGptParameters['topP'],
      frequencyPenalty: chatGptParameters['frequencyPenalty'],
      presencePenalty: chatGptParameters['presencePenalty'],
      thresholdWord: chatGptParameters['threshold'],
      maxTokens: chatGptParameters['maxTokens'],
      temperature: chatGptParameters['temperature'],
    );
  }

  /// Displays a snack bar with the given message.
  void _showSnackBar(String message) {
    SnackBarWidget.showSnackBar(context, message);
  }

  /// Uploads an Excel file containing articles.
  void _uploadExcel() async {
    try {
      final articles = await FileServices().uploadExcel();
      if (articles.isNotEmpty) {
        setState(() {
          uploadedArticles = articles;
        });
        _showSnackBar(GlobalVariables.fileSuccessfullyDownloaded);
      }
    } catch (e) {
      _showSnackBar("$e");
    }
  }

  /// Downloads a template Excel file.
  void _downloadTemplate() async {
    try {
      FileServices().downloadExcelTemplate();
    } catch (e) {
      _showSnackBar("$e");
    }
  }

  /// Builds a text field widget wrapped in a CardContainerWidget.
  Widget _buildTextField({
    required String cardTitle,
    required TextEditingController controller,
    String? hintText,
    required int minLines,
    required int maxLines,
  }) {
    return CardContainerWidget(
      cardTitle: cardTitle,
      child: TextFieldWidget(
        controller: controller,
        hintText: hintText,
        minLines: minLines,
        maxLines: maxLines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: isLoading
          ? const LoadingIndicatorWidget()
          : MainPageLayoutWidget(
              child: MainContainerWidget(
                title: GlobalVariables.articlesAnalyseTitle,
                child: Column(
                  children: [
                    // Explanation text
                    Text(
                      GlobalVariables.articlesAnalyseText,
                      style: theme.textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // Button to download csv file
                    ElevatedButtonWidget(
                      text: GlobalVariables.downloadTemplateExcelButtonText,
                      onPressed: () {
                        _downloadTemplate();
                      },
                      icon: Icons.download_rounded,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // Button to upload csv file
                    ElevatedButtonWidget(
                      text: GlobalVariables.uploadExcelButtonText,
                      onPressed: () {
                        _uploadExcel();
                      },
                      icon: Icons.upload_rounded,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // ChatGPT parameters
                    CardContainerWidget(
                        cardTitle: GlobalVariables.chatGptparametersLabel,
                        child: ChatGptParametersContainerWidget(
                          chatGptParameters: chatGptParameters,
                          onChanged: _updateChatGptParameters,
                        )),
                    GlobalVariables.smallVerticalSizedBox,
                    // ChatGPT Prompt
                    _buildTextField(
                      cardTitle: GlobalVariables.promptLabel,
                      controller: promptController,
                      minLines: GlobalVariables.minLinesValueBigTextField,
                      maxLines: GlobalVariables.maxLinesValueBigTextField,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // Button to analyze multiple articles
                    ElevatedButtonWidget(
                      text: GlobalVariables.startAnalyseButtonText,
                      onPressed: () {
                        _analyzeArticles();
                      },
                    ),
                  ],
                ),
              ),
            ),
      // Floating action button containing parameter explanation panel
      floatingActionButton:
          const ParametersInformationFloatingActionButtonWidget(),
      // Position FloatingActionButton at bottom right of screen, with spacing from edge
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
