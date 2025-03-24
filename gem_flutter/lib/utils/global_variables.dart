import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

/// Configuration for the application.
class AppConfiguration {
  /// The title of the application.
  static const String appTitle = "GEM2024";

  /// The base URL for the development API.
  static const String devAPIURL = "http://localhost:8000/gem_app/api/";

  /// The base URL for the production API.
  static const String prodAPIURL = "http://localhost:8080/gem_app/api/";
}

/// API endpoints for the application.
class ApiEndpoint {
  /// Endpoint for analyzing a single article.
  static const String apiUrlAnalyseArticle =
      "${AppConfiguration.prodAPIURL}analyzearticle/";

  /// Endpoint for analyzing multiple articles.
  static const String apiUrlAnalyseArticles =
      "${AppConfiguration.prodAPIURL}analyzearticles/";

  /// Endpoint for downloading analysis results.
  static const String apiUrlDownloadResults =
      "${AppConfiguration.prodAPIURL}downloadcsvanalysisresults/";
}

/// Route configuration for the application.
class AppRouteConfiguration {
  /// Home route path.
  static const String homePath = "/";

  /// Home route name.
  static const String homeName = "home";

  /// Single article analysis route path.
  static const String articlePath = "/article";

  /// Single article analysis route name.
  static const String articleName = "article";

  /// Multiple articles analysis route path.
  static const String articlesPath = "/articles";

  /// Multiple articles analysis route name.
  static const String articlesName = "articles";

  /// Single article results route path.
  static const String articleResultsPath = "/article/resultats";

  /// Single article results route name.
  static const String articleResultsName = "articleResults";

  /// Multiple articles results route path.
  static const String articlesResultsPath = "/articles/resultats";

  /// Multiple articles results route name.
  static const String articlesResultsName = "articlesResults";
}

/// Template for Excel files with headers and example data.
class ExcelTemplate {
  /// Headers for the Excel template.
  static const List<CellValue> headers = [
    TextCellValue('no'),
    TextCellValue('semaine'),
    TextCellValue('média'),
    TextCellValue('article repris'),
    TextCellValue('url'),
    TextCellValue('article_title'),
    TextCellValue('article_desc'),
    TextCellValue('article_content'),
  ];

  /// Example data for the Excel template.
  static const List<CellValue> data = [
    IntCellValue(123),
    IntCellValue(1),
    IntCellValue(3),
    IntCellValue(2),
    TextCellValue('https://example.com/article1'),
    TextCellValue('Faux Article 1'),
    TextCellValue('Description du Faux Article 1'),
    TextCellValue('Contenu complet du Faux Article 1'),
  ];
}

/// Regular expressions used in the application.
class RegularExpression {
  /// Regular expression for validating URLs.
  static RegExp urlRegExp = RegExp(
    r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
    multiLine: false,
  );
}

/// Coding table to match CSV values to their explanations.
class CodingTable {
  /// Map of coding tables.
  static const Map<String, Map<int, String>> codingMap = {
    "média": mediaMap,
    "article repris": reprintedArticleMap,
    "Article provient d'une agence": articleComesFromAnAgencyMap,
    "Article en lien direct avec une affaire": articleDirectlyRelatedToACaseMap,
    "Taille de l'article": articleSizeMap,
    "Type de violence traitées": typeOfViolenceTreatedMap,
    "Féminicide": feminicideMap,
    "Le vocabulaire": vocabularyMap,
    "Mention féminicide": feminicideMentionMap,
    "Les sources": sourcesMap,
    "La validité des informations": informationValidityMap,
    "Hiérarchisation de l'information": informationPrioritizationMap,
    "La description de la victime": victimDescriptionMap,
    "La description de l'agresseur": aggressorDescriptionMap,
    "La nationalité est mentionnée": nationalityIsMentionedMap,
    "La santé mentale est mentionnée": mentalHealthIsMentionedMap,
    "Le rapport à des substances psychotropes est mentionné":
        useOfPsychotropicSubstancesIsMentionedMap,
    "Une forme d'animalisation est présente": formOfAnimalizationIsPresentMap,
    "La description de la relation entre les protagonistes":
        describingTheRelationshipBetweenTheProtagonistsMap,
    "Les mécanismes qui sous-tendent les violences":
        mechanismsBehindViolenceMap,
    "L'escalade/continuum  des violences est mentionnée":
        escalationContinuumOfViolenceIsMentionedMap,
    "Le processus de sidération est mentionnée":
        dumbfoundingProcessIsMentionedMap,
    "La culture du viol / objetisation /sexisme sont mentionnée":
        rapeCultureObjectificationSexismAreMentionedMap,
    "Les statistiques": statisticsMap,
    "La mention d'autres violences": mentionOfOtherFormsOfViolenceMap,
    "Citations": quotesMap,
    "Ressources proposées": suggestedResourcesMap,
  };

  /// Map for media coding.
  static const Map<int, String> mediaMap = {
    1: "Le Courrier",
    2: "Tribune de Genève",
    3: "Le Temps",
    4: "RTSinfo",
    5: "24h",
    6: "Le Nouvelliste",
    7: "Léman Bleu",
    8: "20 minutes",
    9: "La Télé",
    10: "Le Matin",
    11: "Canal 9",
    12: "Swissinfo",
    13: "La Liberté",
    14: "Le Matin Dimanche et Femina",
    15: "Arcinfo",
    16: "Watson",
    17: "L'Illustré",
    18: "ats",
    19: "Blick",
  };

  /// Map for reprinted article coding.
  static const Map<int, String> reprintedArticleMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for article comes from an agency coding.
  static const Map<int, String> articleComesFromAnAgencyMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for article directly related to a case coding.
  static const Map<int, String> articleDirectlyRelatedToACaseMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for article size coding.
  static const Map<int, String> articleSizeMap = {
    1: "Bref",
    2: "Moyen",
    3: "Grand format",
  };

  /// Map for type of violence treated coding.
  static const Map<int, String> typeOfViolenceTreatedMap = {
    1: "Harcèlement sexuel professionnel",
    2: "Harcèlement sexuel privée",
    3: "Attouchements sexuels",
    4: "Viol et contraintes sexuelles",
    5: "Violences conjugales",
    6: "Harcèlement de rue",
    7: "Mutilations génitales",
    8: "Autre",
    9: "Multiple",
  };

  /// Map for feminicide coding.
  static const Map<int, String> feminicideMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for vocabulary coding.
  static const Map<int, String> vocabularyMap = {
    -1: "L'article contient un vocabulaire amoureux ou de la séduction et/ou minimisant et réducteur ( ex. drame passionnel, jeux érotique, caresse buccale).",
    0: "L'article contient un vocabulaire ambigu et/ou un mélange (ex. drame, féminicide et drame passionnel).",
    1: "L'article contient un vocabulaire de la violence  (ex. féminicide, viol, violence conjugale).",
  };

  /// Map for feminicide mention coding.
  static const Map<int, String> feminicideMentionMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for sources coding.
  static const Map<int, String> sourcesMap = {
    -1: "L'article ne contient que la version de l'agresseur.",
    0: "L'article croise la version de la victime et de l'agresseur / ou contient la version de la victime.",
    1: "L'article croise la version de la victime, de l'agresseur et une version d'expert-e-s.",
  };

  /// Map for information validity coding.
  static const Map<int, String> informationValidityMap = {
    -1: "Le journaliste peut affirmer 50% des informations données.",
    0: "Le journaliste peut affirmer 75% des informations données.",
    1: "Le journaliste peut affirmer 100% des informations données.",
  };

  /// Map for information prioritization coding.
  static const Map<int, String> informationPrioritizationMap = {
    -1: "Le titre et/ou le chapeau mentionnent des informations ambiguës sur le contexte ou tendent à choquer.",
    0: "Le titre et/ou le chapeau ne mentionnent pas les violences.",
    1: "Le titre et le chapeau mentionnent les violences.",
  };

  /// Map for victim description coding.
  static const Map<int, String> victimDescriptionMap = {
    -1: "L'article remet en cause la légitimité de la parole de la victime.",
    0: "Le comportement de la victime est décrit de manière ambiguë dans l'article.",
    1: "Ni la légitimité de la parole de la victime, ni son comportement ne sont remis en cause.",
  };

  /// Map for aggressor description coding.
  static const Map<int, String> aggressorDescriptionMap = {
    -1: "La description de l'auteur  participe à l'excuser (perte de contrôle à cause de l'émotion, de pulsions, de drogues, d'alcool, de maladie).",
    0: "La description de l'auteur contient des termes ambigus (prédateur/ mention de l'alcool, de la drogue, mention de la nationalité).",
    1: "L'auteur est décrit comme un homme « normal »et son comportement n'est pas excusé - on ne mentionne pas de traits spécifiques l'aliénant.",
  };

  /// Map for nationality is mentioned coding.
  static const Map<int, String> nationalityIsMentionedMap = {
    1: "Nationalité extra-européenne",
    2: "Nationalité européenne",
    3: "Nationalité suisse",
    4: "Pas de mention de la nationalité",
  };

  /// Map for mental health is mentioned coding.
  static const Map<int, String> mentalHealthIsMentionedMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for the use of psychotropic substances is mentioned coding.
  static const Map<int, String> useOfPsychotropicSubstancesIsMentionedMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for a form of animalization is present coding.
  static const Map<int, String> formOfAnimalizationIsPresentMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for describing the relationship between the protagonists coding.
  static const Map<int, String>
      describingTheRelationshipBetweenTheProtagonistsMap = {
    -1: "Les protagonistes sont mis à un pied d'égalité.",
    0: "La relation de pouvoir entre les protagonistes n'est pas mentionnée.",
    1: "La relation de pouvoir entre les protagonistes est clairement mentionnée (ex. ascendance, possibilité de pression).",
  };

  /// Map for the mechanisms behind violence coding.
  static const Map<int, String> mechanismsBehindViolenceMap = {
    -1: "L'article ne fait pas mention de violence.",
    0: "Les mécanismes amenant à l'escalade des violences n'est pas mentionné clairement.",
    1: "Les mécanismes amenant à l'escalade des violences et l'emprise de l'agresseur est décrit clairement.",
  };

  /// Map for escalation/continuum of violence is mentioned coding.
  static const Map<int, String> escalationContinuumOfViolenceIsMentionedMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for the dumbfounding process is mentioned coding.
  static const Map<int, String> dumbfoundingProcessIsMentionedMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for rape culture/objectification/sexism are mentioned coding.
  static const Map<int, String>
      rapeCultureObjectificationSexismAreMentionedMap = {
    1: "Oui",
    2: "Non",
  };

  /// Map for statistics coding.
  static const Map<int, String> statisticsMap = {
    -1: "Aucune statistique n'est présentes dans l'article.",
    0: "Des statistiques mettant en perspective un seul type de violence sont utilisées.",
    1: "Des statistiques mettant en perspective les violences en général comme un fait de société sont utilisées.",
  };

  /// Map for mention of other forms of violence coding.
  static const Map<int, String> mentionOfOtherFormsOfViolenceMap = {
    -1: "L'article ne cite pas d'autres violences sexistes.",
    0: "L'article cite quelques violences passées du même type ou dans la même affaire.",
    1: "L'article inclut la violence citée dans un mécanisme d'ampleur contenant toutes les violences sexistes ou diverses formes.",
  };

  /// Map for quotes coding.
  static const Map<int, String> quotesMap = {
    -1: "L'article ne fait aucune référence aux personnes / associations / institutions travaillant sur la question des violences sexistes.",
    0: "L'article mentionne un-e expert-e / association / institution travaillant sur la question des violences sexistes.",
    1: "L'article interroge un-e expert-e des violences sexistes.",
  };

  /// Map for suggested resources coding.
  static const Map<int, String> suggestedResourcesMap = {
    -1: "L'article ne mentionne aucun élément informatif pour les éventuelles victimes.",
    0: "L'article mentionne  indirectement une ressource pouvant aider les éventuelles victimes ( texte de loi, organisation aidant, etc…).",
    1: "L'article mentionne un numéro d'aide / site internet  aux éventuelles victimes (encadré, numéro, lien direct).",
  };
}

/// Other global variables used throughout the application.
class GlobalVariables {
  /// Duration for snack bars (in seconds).
  static const int snackBarDurationInSec = 4;

  /// Medium sized box for vertical spacing.
  static const SizedBox mediumVerticalSizedBox = SizedBox(height: 32);

  /// Small sized box for vertical spacing.
  static const SizedBox smallVerticalSizedBox = SizedBox(height: 16);

  /// Small sized box for horizontal spacing.
  static const SizedBox smallhorizontalSizedBox = SizedBox(width: 16);

  /// Circular border radius.
  static const double borderRadiusSize = 40;

  /// Big padding.
  static const EdgeInsets bigPadding = EdgeInsets.all(20.0);

  /// Medium padding.
  static const EdgeInsets mediumPadding = EdgeInsets.all(16.0);

  /// Small padding.
  static const EdgeInsets smallPadding = EdgeInsets.all(8.0);

  /// Minimum lines value for a big text field.
  static const int minLinesValueBigTextField = 10;

  /// Maximum lines value for a big text field.
  static const int maxLinesValueBigTextField = 30;

  /// Minimum lines value for a small text field.
  static const int minLinesValueSmallTextField = 1;

  /// Maximum lines value for a small text field.
  static const int maxLinesValueSmallTextField = 5;

  /// Size for medium icons.
  static const double sizeMediumIcon = 80;

  /// Size for small icons.
  static const double sizeSmallIcon = 80;

  /// Divider widget.
  static const Divider divider = Divider();

  /// Button text for a single article analysis on the home page.
  static const String articleButtonText = "Analyser un seul article";

  /// Button text for multiple articles analysis on the home page.
  static const String articlesButtonText = "Analyser plusieurs articles";

  /// Welcome text for the home page.
  static const String welcomeText = "Bienvenue !";

  /// Label for ChatGPT parameters in analysis pages.
  static const String chatGptparametersLabel = "Paramètres du LLM";

  /// Step value for integer parameters.
  static const int stepsValueIntParams = 1;

  /// Step value for double parameters.
  static const double stepsValueDoubleParams = 0.1;

  /// Text for required fields.
  static const String requiredFieldText = "Champs obligatoire";

  /// Text indicating that the analysis is in progress.
  static const String analysisInProgressText = "Analyse en cours...";

  /// Title for the information panel explaining parameters.
  static const String infoPanelTitle = "Explications des paramètres";

  /// Label for the model parameter.
  static const String modelLabel = "Model";

  /// Default value for the model parameter.
  static const String modelValue = "gpt-4";

  /// List of available models.
  static const List<String> modelList = ['gpt-4', 'gpt-4o'];

  /// Information about the model parameter.
  static const String modelInfo =
      "Le nom du modèle que vous souhaitez utiliser.";

  /// Label for the system message content parameter.
  static const String systemMessageContentLabel = "Content";

  /// Default value for the system message content parameter.
  static const String systemMessageContentValue =
      "Vous êtes un expert en sociologie.";

  /// Information about the system message content parameter.
  static const String systemMessageContentInfo =
      "Définit le contexte du modèle en fournissant des informations sur le rôle attendu du modèle.";

  /// Label for the threshold word parameter.
  static const String thresholdWordLabel = "Threshold word";

  /// Default value for the threshold word parameter.
  static const int thresholdWordValue = 2800;

  /// Information about the threshold word parameter.
  static const String thresholdWordInfo =
      "Le nombre seuil de mots avant d'arrêter la génération de la réponse.";

  /// Minimum value for the threshold word parameter.
  static const int thresholdWordMinValue = 0;

  /// Maximum value for the threshold word parameter.
  static const int thresholdWordMaxValue = 4000;

  /// Label for the top_p parameter.
  static const String topPLabel = "Top p";

  /// Default value for the top_p parameter.
  static const double topPValue = 0.6;

  /// Information about the top_p parameter.
  static const String topPInfo =
      "Nombre compris entre 0 et 1.\nUne alternative à l'échantillonnage avec température, appelée échantillonnage par noyau, où le modèle prend en compte les résultats des jetons ayant la masse de probabilité la plus élevée. Ainsi, 0,1 signifie que seuls les jetons comprenant les 10 % de masse de probabilité les plus élevés sont pris en compte.\nRecommandation : modifier ce paramètre ou la température, mais pas les deux.";

  /// Minimum value for the top_p parameter.
  static const double topPMinValue = 0;

  /// Maximum value for the top_p parameter.
  static const double topPMaxValue = 1;

  /// Label for the max_tokens parameter.
  static const String maxTokensLabel = "Max tokens";

  /// Default value for the max_tokens parameter.
  static const int maxTokensValue = 1200;

  /// Information about the max_tokens parameter.
  static const String maxTokensInfo =
      "Définit le nombre maximum de tokens, séquences communes de caractères trouvées dans un ensemble de texte, qui peuvent être générés dans la complétion du chat. La longueur totale des tokens d'entrée et des tokens générés est limitée par la longueur du contexte du modèle.";

  /// Minimum value for the max_tokens parameter.
  static const int maxTokensMinValue = 0;

  /// Maximum value for the max_tokens parameter.
  static const int maxTokensMaxValue = 4000;

  /// Label for the presence_penalty parameter.
  static const String presencePenaltyLabel = "Presence penalty";

  /// Default value for the presence_penalty parameter.
  static const double presencePenaltyValue = 0.1;

  /// Information about the presence_penalty parameter.
  static const String presencePenaltyInfo =
      "Nombre compris entre -2,0 et 2,0.\nLes valeurs positives pénalisent les nouveaux tokens en fonction de leur apparition dans le texte, ce qui augmente la probabilité que le modèle parle de nouveaux sujets.";

  /// Label for the frequency_penalty parameter.
  static const String frequencyPenaltyLabel = "Frequency penalty";

  /// Default value for the frequency_penalty parameter.
  static const double frequencyPenaltyValue = 0.5;

  /// Information about the frequency_penalty parameter.
  static const String frequencyPenaltyInfo =
      "Nombre compris entre -2,0 et 2,0.\nLes valeurs positives pénalisent les nouveaux tokens en fonction de leur fréquence dans le texte jusqu'à présent, ce qui diminue la probabilité que le modèle répète la même ligne mot pour mot.";

  /// Minimum value for the presence_penalty and the frequency_penalty parameters.
  static const double presenceFrequencyPenaltyMinValue = -2;

  /// Maximum value for the presence_penalty and the frequency_penalty parameters.
  static const double presenceFrequencyPenaltyMaxValue = 2;

  /// Label for the temperature parameter.
  static const String temperatureLabel = "Temperature";

  /// Default value for the temperature parameter.
  static const double temperatureValue = 0.4;

  /// Information about the temperature parameter.
  static const String temperatureInfo =
      "Température d'échantillonnage à utiliser, entre 0 et 2.\nDes valeurs plus élevées comme 0,8 rendront la sortie plus aléatoire, tandis que des valeurs plus faibles comme 0,2 la rendront plus ciblée et déterministe.\nRecommandation : modifier cette valeur ou top p, mais pas les deux.";

  /// Minimum value for the temperature parameter.
  static const double temperatureMinValue = 0;

  /// Maximum value for the temperature parameter.
  static const double temperatureMaxValue = 2;

  /// Label for the prompt parameter.
  static const String promptLabel = "Prompt";

  /// Default value for the prompt parameter.
  static const String promptValue =
      "D'abord, j'aimerais vous demander de lire un article d'actualité lié à la violence sexiste et sexuelle et, ensuite, de répondre aux 14 questions suivantes. Question 1 : à quelle catégorie appartient le type de violence traité dans l'article ? Il y a 9 catégories possibles, choisissiez une des 9 catégorie et expliquez votre choix. Ces 9 catégories sont : 1. Harcèlement sexuel dans le cadre professionnel ; 2. Harcèlement sexuel dans le cadre privé ; 3. Attouchements sexuels ; 4. Viol et contraintes sexuelles ; 5. Violences conjugales ; 6. Harcèlement de rue ; 7. Mutilations génitales ; 8. Autres catégorie, à l'exclusion des 7 catégories que j'ai mentionnées ; 9. Multiples violences mentionnées dans les 7 catégories que j'ai citées. Pouvez-vous analyser l'article et faire le bon choix ? Question 2 : Cet article mentionne-t-il un féminicide, le meurtre d'une femme ou d'une fille? Il y a 2 options à choisir : 1) oui ; 2) non. Pouvez-vous analyser l'article et faire le bon choix ? Question 3 : Cet article contient-il la version des faits des différents protagonistes, notamment de la victime, de l'agresseur ou/et d'un-e expert-e ? Il y a 3 options à choisir : 1) l'article croise la version de la victime, de l'agresseur et une version d'expert-e-s ; 0) l'article croise la version de la victime et de l'agresseur / ou contient la version de la victime ; -1) l'article ne contient que la version de l'agresseur. Pouvez-vous analyser l'article et faire le bon choix ? Question 4 : Veuillez récupérer le titre et le chapeau de l'article dans les deux premiers paragraphes de l'article et faire votre choix : 1) le titre et le chapeau mentionnent les violences ; 0) le titre et/ou le chapeau ne mentionnent pas les violences ; -1) le titre et/ou le chapeau mentionne des informations ambiguës sur le contexte ou tendent à choquer, le titre soit sensationnaliste. Question 5: Est-ce que cet article décrit le comportement de la victime pour la délégitimer ? Il y a 3 options à choisir : 1) ni la légitimité de la parole de la victime ni son comportement et ses réactions face à l'auteur des violences ne sont remis en cause ou ne sont décrits; 0) la légitimité de la parole de la victime, son comportement et ses réactions face à l'auteur des violences sont décrits et partiellement remis en cause (l'article sous-entend que la victime de violence a une part de responsabilité ou a provoqué les violences qu'elle a subies); -1) la légitimité de la parole de la victime, son comportement et ses réactions face à l'auteur des violences sont clairement remis en cause (l'article affirme que la victime ment ou ne dit pas toute la vérité ou l'article affirme que la victime est responsable des violences qu'elle a subies). Pouvez-vous analyser l'article et faire le bon choix ? Question 6: est-ce que cet article décrit le comportement de l'auteur des violences ? Il y a 3 options à choisir : 1) L'auteur est décrit comme un homme « normal » et son comportement n'est pas excusé - on ne mentionne pas de traits spécifiques l'aliénant ; 0) la description de l'auteur contient des termes ambigus (prédateur/ mention d'abus d'alcool, de prise de drogue, mention de la nationalité) ; -1) la description de l'auteur participe à l'excuser (perte de contrôle à cause de l'émotion, de pulsions, de drogues, d'alcool, de maladie, de passion). Pouvez-vous analyser l'article et faire le bon choix ? Question 7 : est-ce que cet article mentionne directement ou indirectement la nationalité et/ou l'origine de l'auteur, par exemple \"ces joueurs de l'équipe national canadienne de hockey\" ou \"l'auteur d'origine égyptienne\"? Il y a 4 options à choisir : 1) nationalité extra-européenne ; 2) nationalité européenne ; 3) nationalité suisse ; et 4) pas de mention de la nationalité. Pouvez-vous analyser l'article et faire le bon choix ? Question 8 : est-ce que cet article décrit la relation de pouvoir entre la victime et l'auteur des violences et l'emprise de l'auteur sur la victime ? Il y a 3 options à choisir : 1) la relation de pouvoir et l'emprise entre la victime et l'auteur des violences est clairement mentionnée (ascendance psychologique ou physique, domination, possibilité de pression dans le cadre privé ou professionnel, différence d'âge importante); 0) la relation de pouvoir entre la victime et l'auteur des violences n'est pas mentionnée explicitement ; -1) la victime et l'auteur des violences sont tenus responsables des violences. Pouvez-vous analyser l'article et faire le bon choix ? Question 9 : est-ce que cet article décrit les mécanismes d'escalade, de sidération ou d'objetisation (isolement, dévalorisation, inversion de la culpabilité, climat de peur et de menace, tabous des violences, objetisation des femmes, sidération psychologique, escalade des violences, cycle de la violence) qui sous-tendent les violences verbales, psychologiques, physiques et sexuelles ? Il y a 3 options à choisir : 1) les mécanismes amenant aux violences sont décrits clairement ; 0) les mécanismes amenant aux violences ne sont pas mentionnés clairement, mais l'article considère les faits rapportés comme des violences; -1) les faits rapportés par l'article ne sont pas considérés comme des violences. Pouvez-vous analyser l'article et faire le bon choix ? Question 10 : est-ce que cet article mentionne l'escalade et/ou le continuum des violences ? Il y a 2 options à choisir : 1) oui; 2) non. Pouvez-vous analyser l'article et faire le bon choix ? Question 11 : est-ce que cet article utilise des statistiques ? Il y a 3 options à choisir : 1) des statistiques mettant en perspective les violences en général comme un fait de société sont utilisées ; 0) des statistiques mettant en perspective un seul type de violence sont utilisées ; -1) aucune statistique n'est présentes dans l'article. Pouvez-vous analyser cet article et faire le bon choix ? Question 12 : est-ce que cet article cite d'autres violences sexistes et sexuelles qui ont lieu dans la société en général ? Il y a 3 options à choisir : 1) l'article inclut la violence citée dans un mécanisme contenant toutes les violences sexistes ou diverses formes de violences ; 0) l'article cite quelques violences sexistes passées du même type ou dans la même affaire ; -1) l'article ne cite pas d'autres violences sexistes. Pouvez-vous analyser cet article et faire le bon choix ? Question 13 : est-ce que cet article interroge un-e expert-e des violences sexistes ? Il y a 3 options à choisir : 1) l'article interroge un-e expert-e des violences sexistes ; 0) l'article mentionne un-e expert-e / association / institution travaillant sur la question des violences sexistes ; -1) l'article ne fait aucune référence aux personnes / associations / institutions travaillant sur la question des violences sexistes. Pouvez-vous analyser cet article et faire le bon choix ? Question 14 : Cet article mentionne-t-il des informations supplémentaires susceptibles d'aider les victimes, notamment un numéro d'assistance téléphonique ou un site Web ? Il y a 3 options à choisir : 1) l'article mentionne un numéro d'aide / site internet pour les éventuelles victimes (encadré, numéro, lien direct); 0) l'article mentionne indirectement une ressource pouvant aider les éventuelles victimes (texte de loi, organisation aidant les victimes, etc…) ; -1) l'article ne mentionne aucun élément informatif pour les éventuelles victimes. Pouvez-vous analyser l'article et faire le bon choix ? Vous placez chaque réponse dans des paragraphes distincts. Commencez par indiquer votre choix avec le numéro d'option que je vous ai donné, puis expliquez votre choix pour chaque question dans chaque paragraphe. Veuillez noter que votre réponse pour chaque question est bien stricte par un chiffre qui représente l'option que nous avons choisi, voici un exemple : Question (numéro de question) : option (numéro d'option choisie). Voici l'article à analyser :";

  /// Button text for start the analysis
  static const String startAnalyseButtonText = "Lancer l'analyse";

  /// Message to fill all fields.
  static const String fillAllFieldsMsg = "Veuillez remplir tous les champs.";

  /// Message to fill all fields.
  static const String fileMissingMsg =
      "Fichier Excel contenant les articles à analyser manquant.";

  /// Title for single article analysis page.
  static const String articleAnalyseTitle = "Analyse d'un seul article";

  /// Label for general article data.
  static const String articleDataLabel = "Données générales";

  /// Label for the article number.
  static const String noLabel = "Numéro de l'article";

  /// Label for the value
  static const String valueLabel = "Valeur:";

  /// Default value for the article number.
  static const int noValue = 0;

  /// Label for the publication date.
  static const String dateLabel = "Date de publication";

  /// Default value for the publication date.
  static int dateValue = Jiffy.parseFromDateTime(DateTime.now()).weekOfYear;

  /// Text for choosing a date.
  static const String dateText = "Choisir une date";

  /// Label for media.
  static const String mediaLabel = "Média";

  /// Map of media values.
  static const Map<String, int> mediaMap = {
    "Le Courrier": 1,
    "Tribune de Genève": 2,
    "Le Temps": 3,
    "RTS info": 4,
    "24h": 5,
    "Le Nouvelliste": 6,
    "Léman Bleu": 7,
    "20 minutes": 8,
    "La Télé": 9,
    "Le Matin": 10,
    "Canal 9": 11,
    "Swissinfo": 12,
    "La Liberté": 13,
    "Le Matin Dimanche et Femina": 14,
    "Arcinfo": 15,
    "Watson": 16,
    "L'Illustré": 17,
    "ats": 18,
    "Blick": 19,
  };

  /// Label for reprinted articles.
  static const String reprintedArticleLabel = "Article repris";

  /// Map of reprinted article values.
  static const Map<String, int> reprintedArticleMap = {
    "Oui": 1,
    "Non": 2,
  };

  /// Label for URL.
  static const String urlLabel = "URL";

  /// Label for article title.
  static const String articleTitleLabel = "Titre";

  /// Label for article summary (chapo).
  static const String chapoLabel = "Chapô";

  /// Label for article content.
  static const String contentLabel = "Contenu";

  /// Placeholder text for article URL.
  static const String articleUrlText = "Entrez l'URL.";

  /// Placeholder text for article title.
  static const String articleTitleText = "Entrez le titre de l'article.";

  /// Placeholder text for article summary.
  static const String articleChapoText = "Entrez le chapô de l'article.";

  /// Placeholder text for article content.
  static const String articleContentText = "Entrez le contenu de l'article.";

  /// Button text for uploading an Excel file.
  static const String uploadExcelButtonText = "Téléchargez votre fichier Excel";

  /// Button text for downloading the Excel template.
  static const String downloadTemplateExcelButtonText = "Téléchargez le modèle";

  /// Title for multiple articles analysis page.
  static const String articlesAnalyseTitle = "Analyse de plusieurs articles";

  /// Text for multiple articles analysis page.
  static const String articlesAnalyseText =
      "Ici vous pouvez analyser plusieurs articles à la fois en téléchargeant un fichier Excel.\n\n"
      "Si vous n'avez pas encore de fichier Excel prêt qui respecte le schéma requis, vous pouvez télécharger un modèle de fichier en appuyant sur le bouton ci-dessous. Ce modèle contient tous les en-têtes de colonnes nécessaires et des exemples de données pour vous guider dans la préparation de votre fichier.";

  /// Message for file successfully uploaded
  static const String fileSuccessfullyDownloaded =
      "Fichier téléchargé avec succès.";

  /// Title for analysis completed page.
  static const String analysisCompletedTitle = "Analyse terminée";

  /// Button text for downloading results on the results page.
  static const String downloadResultsButtonText = "Télécharger les résultats";

  /// Label for the results on the single article results page.
  static const String resultsText = "Résultats";

  /// Error message for loading CSV data.
  static const String errorLoadingCsvDataText =
      'Erreur lors du chargement des données CSV';

  /// Button text for returning to the home page on the error page
  static const String backHomeButtonText = "Retour à l'accueil";

  /// Text for the error page.
  static const String errorPageText =
      "Il semble qu'il y ait eu un problème de navigation.\nVeuillez vérifier l'URL ou revenir à la page d'accueil.";

  /// Error message for invalid URL in single article analyse page
  static const String invalidUrlErrorMessage =
      "Veuillez saisir une URL valide.";

  /// Error message for server errors in file services and ChatGPT services.
  static const String serverErrorMessage = "Erreur de serveur:";

  /// Error message for failed API calls in ChatGPT services.
  static const String apiCallFailMessage = "L'appel à l'API a échoué.";

  /// Error message for errors during API calls in ChatGPT services.
  static const String apiCallErrorMessage = "Erreur lors de l'appel à l'API:";

  /// Error message for bad requests in ChatGPT services.
  static const String badRequestErrorMessage = "Mauvaise requête:";

  /// Error message for downloading file errors in file services.
  static const String downloadingFileErrorMessage =
      "Erreur lors du téléchargement du fichier:";

  /// Error message for rows with null values in file services.
  static const String lineHasNullValueErrorMessage =
      "La ligne suivante a une valeur nulle qui est obligatoire:";

  /// Error message for rows missing required columns in file services.
  static const String lineDoesntHaveRequiredColumnsErrorMessage =
      "La ligne suivante n'a pas les colonnes requises:";

  /// Error message for empty or null sheets in file services.
  static const String sheetIsEmptyOrNullErrorMessage =
      "La feuille suivante est vide ou nulle:";

  /// Error message for files with no content in file services.
  static const String noFileContentErrorMessage = "Pas de contenu de fichier.";

  /// Message for no file selected in file services.
  static const String noFileSelectedMessage = "Aucun fichier sélectionné.";

  /// Error message for file not found in file services.
  static const String fileNotFoundErrorMessage = "Fichier non trouvé:";

  /// Error message for unexpected errors in file services.
  static const String unexpectedErrorMessage = "Erreur inattendue:";

  /// Error message for errors fetching analysis results in file services.
  static const String fetchingDataErrorMessage =
      "Erreur dans l'extraction des résultats d'analyse:";
}
