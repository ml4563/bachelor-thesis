import 'dart:convert';

import 'package:gem_flutter/models/article_analysis_request.dart';
import 'package:gem_flutter/models/articles_analysis_request.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:http/http.dart' as http;

/// Service class to interact with API for analyzing articles.
class APIServices {
  /// Sends a request to the API to analyze a single article.
  Future<String> analyseArticle(ArticleAnalysisRequest request) async {
    final response = http.post(
      Uri.parse(ApiEndpoint.apiUrlAnalyseArticle),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(request.toJson()),
    );

    return response.then((response) {
      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return responseBody['result'] as String;
      } else if (response.statusCode == 400) {
        throw Exception(
            '${GlobalVariables.badRequestErrorMessage} ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception(
            '${GlobalVariables.serverErrorMessage} ${response.body}');
      } else {
        throw Exception(
            "${GlobalVariables.apiCallFailMessage} ${response.statusCode}");
      }
    }).catchError((e) {
      throw Exception("${GlobalVariables.apiCallErrorMessage} $e");
    });
  }

  /// Sends a request to the API to analyze multiple articles.
  Future<String> analyseArticles(ArticlesAnalysisRequest request) async {
    final response = http.post(
      Uri.parse(ApiEndpoint.apiUrlAnalyseArticles),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(request.toJson()),
    );

    return response.then((response) {
      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return responseBody['result'] as String;
      } else if (response.statusCode == 400) {
        throw Exception(
            '${GlobalVariables.badRequestErrorMessage} ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception(
            '${GlobalVariables.serverErrorMessage} ${response.body}');
      } else {
        throw Exception(
            "${GlobalVariables.apiCallFailMessage} ${response.statusCode}");
      }
    }).catchError((e) {
      throw Exception("${GlobalVariables.apiCallErrorMessage} $e");
    });
  }
}
