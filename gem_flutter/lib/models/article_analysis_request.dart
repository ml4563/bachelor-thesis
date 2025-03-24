import 'package:gem_flutter/models/article.dart';
import 'package:gem_flutter/models/chat_gpt_parameters.dart';

/// Class representing a request to analyze a single article
///
/// This class encapsulates an article and the ChatGPT parameters required for analysis
class ArticleAnalysisRequest {
  final Article article;
  final ChatGptParameters parameters;

  /// Creates a [ArticleAnalysisRequest] with the specified article and ChatGPT parameters.
  ArticleAnalysisRequest({
    required this.article,
    required this.parameters,
  });

  /// Converts the [ArticleAnalysisRequest] instance into a JSON object.
  ///
  /// Returns a [Map] representation of the [ArticleAnalysisRequest] instance.
  Map<String, dynamic> toJson() => {
        'article': article.toJson(),
        'parameters': parameters.toJson(),
      };
}
