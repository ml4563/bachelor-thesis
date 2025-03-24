import 'package:flutter/material.dart';
import 'package:gem_flutter/models/article.dart';
import 'package:gem_flutter/models/chat_gpt_parameters.dart';
import 'package:gem_flutter/models/article_analysis_request.dart';
import 'package:gem_flutter/services/api_services.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:gem_flutter/widgets/elevated_button_widget.dart';
import 'package:gem_flutter/widgets/card_container_widget.dart';
import 'package:gem_flutter/widgets/parameters_information_floating_action_button_widget.dart';
import 'package:gem_flutter/widgets/general_article_data_container_widget.dart';
import 'package:gem_flutter/widgets/load_indicator_widget.dart';
import 'package:gem_flutter/widgets/main_container_widget.dart';
import 'package:gem_flutter/widgets/chat_gpt_parameters_container_widget.dart';
import 'package:gem_flutter/widgets/main_page_layout_widget.dart';
import 'package:gem_flutter/widgets/snack_bar_widget.dart';
import 'package:gem_flutter/widgets/text_field_widget.dart';
import 'package:go_router/go_router.dart';

/// A StatefulWidget that allows the user to analyze an article using
/// OpenAI's ChatGPT model.
class ArticleAnalysisPage extends StatefulWidget {
  const ArticleAnalysisPage({super.key});

  @override
  ArticleAnalysisPageState createState() => ArticleAnalysisPageState();
}

class ArticleAnalysisPageState extends State<ArticleAnalysisPage> {
  final APIServices apiServices = APIServices();

  /// TextEditingController for the url text field.
  final TextEditingController urlController = TextEditingController();

  /// TextEditingController for the title text field.
  final TextEditingController titleController = TextEditingController();

  /// TextEditingController for the chapo text field.
  final TextEditingController chapoController = TextEditingController();

  /// TextEditingController for the content text field.
  final TextEditingController contentController = TextEditingController();

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

  /// Map to store general article data.
  Map<String, dynamic> generalArticleData = {
    'no': GlobalVariables.noValue,
    'semaine': GlobalVariables.dateValue,
    'media': GlobalVariables.mediaMap.values.first,
    'articleRepris': GlobalVariables.reprintedArticleMap.values.first,
  };

  /// Flag to indicate whether the app is currently loading data.
  bool isLoading = false;

  /// Updates the ChatGPT parameters.
  void _updateChatGptParameters(String key, dynamic value) {
    setState(() {
      chatGptParameters[key] = value;
    });
  }

  /// Updates the general article data
  void _updateGeneralArticleData(String key, dynamic value) {
    setState(() {
      generalArticleData[key] = value;
    });
  }

  /// Submits the analysis request and handles the API call.
  void _analyzeArticle() async {
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final article = _createArticle();
      final chatGptParameters = _createChatGptParameters();
      final request = ArticleAnalysisRequest(
        article: article,
        parameters: chatGptParameters,
      );

      final response = await apiServices.analyseArticle(request);

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
    context.goNamed(AppRouteConfiguration.articleResultsName,
        pathParameters: {'fileName': fileName});
  }

  /// Validates the input fields before submission.
  bool _validateInputs() {
    if (urlController.text.isEmpty ||
        titleController.text.isEmpty ||
        chapoController.text.isEmpty ||
        contentController.text.isEmpty ||
        promptController.text.isEmpty) {
      _showSnackBar(GlobalVariables.fillAllFieldsMsg);
      return false;
    }

    if (!isValidUrl(urlController.text)) {
      _showSnackBar(GlobalVariables.invalidUrlErrorMessage);
      return false;
    }

    for (var data in generalArticleData.values) {
      if (data == null || data.toString().isEmpty) {
        _showSnackBar(GlobalVariables.fillAllFieldsMsg);
        return false;
      }
    }

    for (var param in chatGptParameters.values) {
      if (param == null || param.toString().isEmpty) {
        _showSnackBar(GlobalVariables.fillAllFieldsMsg);
        return false;
      }
    }
    return true;
  }

  /// Validates if the URL is a valid URL.
  bool isValidUrl(String url) {
    return RegularExpression.urlRegExp.hasMatch(url);
  }

  /// Creates an Article object from the input data.
  Article _createArticle() {
    return Article(
      no: generalArticleData['no'],
      semaine: generalArticleData['semaine'],
      media: generalArticleData['media'],
      articleRepris: generalArticleData['articleRepris'],
      url: urlController.text,
      title: titleController.text,
      chapo: chapoController.text,
      content: contentController.text,
    );
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
    return Scaffold(
      body: isLoading
          ? const LoadingIndicatorWidget()
          : MainPageLayoutWidget(
              child: MainContainerWidget(
                title: GlobalVariables.articleAnalyseTitle,
                child: Column(
                  children: [
                    GlobalVariables.smallVerticalSizedBox,
                    // General article data
                    CardContainerWidget(
                        cardTitle: GlobalVariables.articleDataLabel,
                        child: GeneralArticleDataContainerWidget(
                          generalArticleData: generalArticleData,
                          onChanged: _updateGeneralArticleData,
                        )),
                    GlobalVariables.smallVerticalSizedBox,
                    // URL
                    _buildTextField(
                      cardTitle: GlobalVariables.urlLabel,
                      controller: urlController,
                      hintText: GlobalVariables.articleUrlText,
                      minLines: GlobalVariables.minLinesValueSmallTextField,
                      maxLines: GlobalVariables.maxLinesValueSmallTextField,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // Title
                    _buildTextField(
                      cardTitle: GlobalVariables.articleTitleLabel,
                      controller: titleController,
                      hintText: GlobalVariables.articleTitleText,
                      minLines: GlobalVariables.minLinesValueSmallTextField,
                      maxLines: GlobalVariables.maxLinesValueSmallTextField,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // Chapô
                    _buildTextField(
                      cardTitle: GlobalVariables.chapoLabel,
                      controller: chapoController,
                      hintText: GlobalVariables.articleChapoText,
                      minLines: GlobalVariables.minLinesValueSmallTextField,
                      maxLines: GlobalVariables.maxLinesValueSmallTextField,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // Content
                    _buildTextField(
                      cardTitle: GlobalVariables.contentLabel,
                      controller: contentController,
                      hintText: GlobalVariables.articleContentText,
                      minLines: GlobalVariables.minLinesValueBigTextField,
                      maxLines: GlobalVariables.maxLinesValueBigTextField,
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
                    // ChatGPT prompt
                    _buildTextField(
                      cardTitle: GlobalVariables.promptLabel,
                      controller: promptController,
                      minLines: GlobalVariables.minLinesValueBigTextField,
                      maxLines: GlobalVariables.maxLinesValueBigTextField,
                    ),
                    GlobalVariables.smallVerticalSizedBox,
                    // Button to analyze article
                    ElevatedButtonWidget(
                      text: GlobalVariables.startAnalyseButtonText,
                      onPressed: () {
                        _analyzeArticle();
                      },
                    ),
                  ],
                ),
              ),
            ),

      // Floating action button containing parameter explanation panel
      floatingActionButton:
          const ParametersInformationFloatingActionButtonWidget(),
      // Position Floating action button at bottom right of screen, with spacing from edge
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
