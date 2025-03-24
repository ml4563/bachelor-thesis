import 'package:gem_flutter/models/article.dart';
import 'package:gem_flutter/models/chat_gpt_parameters.dart';

/// Class representing a request to analyze multiple articles
///
/// This class encapsulates a list of articles and the ChatGPT parameters required for analysis
class ArticlesAnalysisRequest {
  final List<Article>? articles;
  final ChatGptParameters parameters;

  /// Creates a [ArticlesAnalysisRequest] with the specified articles and ChatGPT parameters.
  ArticlesAnalysisRequest({
    required this.articles,
    required this.parameters,
  });

  /// Converts the [ArticlesAnalysisRequest] instance into a JSON object.
  ///
  /// Returns a [Map] representation of the [ArticlesAnalysisRequest] instance.
  Map<String, dynamic> toJson() => {
        'articles': articles?.map((article) => article.toJson()).toList(),
        'parameters': parameters.toJson(),
      };
}
