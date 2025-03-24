import 'package:gem_flutter/pages/error_page.dart';
import 'package:gem_flutter/pages/home_page.dart';
import 'package:gem_flutter/pages/articles_analysis_page.dart';
import 'package:gem_flutter/pages/articles_results_page.dart';
import 'package:gem_flutter/pages/article_analysis_page.dart';
import 'package:gem_flutter/pages/article_results_page.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:go_router/go_router.dart';

/// The main router configuration for the application using GoRouter.
/// It defines the routes for the application and specifies the corresponding pages for each route.
final GoRouter router = GoRouter(
  routes: [
    // Route for the HomePage
    GoRoute(
      path: AppRouteConfiguration.homePath,
      name: AppRouteConfiguration.homeName,
      builder: (context, state) => const HomePage(),
    ),
    // Route for the ArticleAnalysisPage
    GoRoute(
      path: AppRouteConfiguration.articlePath,
      name: AppRouteConfiguration.articleName,
      builder: (context, state) => const ArticleAnalysisPage(),
    ),
    // Route for the ArticlesAnalysisPage
    GoRoute(
      path: AppRouteConfiguration.articlesPath,
      name: AppRouteConfiguration.articlesName,
      builder: (context, state) => const ArticlesAnalysisPage(),
    ),
    // Route for the ArticleResultsPage with a dynamic fileName parameter
    GoRoute(
      path: "${AppRouteConfiguration.articleResultsPath}/:fileName",
      name: AppRouteConfiguration.articleResultsName,
      builder: (context, state) => ArticleResultsPage(
        fileName: state.pathParameters['fileName']!,
      ),
    ),
    // Route for the ArticlesResultsPage with a dynamic fileName parameter
    GoRoute(
      path: "${AppRouteConfiguration.articlesResultsPath}/:fileName",
      name: AppRouteConfiguration.articlesResultsName,
      builder: (context, state) => ArticlesResultsPage(
        fileName: state.pathParameters['fileName']!,
      ),
    ),
  ],
  // Route for the ErrorPage, displayed in case of any routing errors
  errorBuilder: (context, state) => const ErrorPage(),
);
