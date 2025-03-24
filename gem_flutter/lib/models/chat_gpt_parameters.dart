/// Class representing ChatGPT parameters
class ChatGptParameters {
  final String prompt;
  final String model;
  final String content;
  final double topP;
  final double frequencyPenalty;
  final double presencePenalty;
  final int thresholdWord;
  final int maxTokens;
  final double temperature;

  /// Creates a [ChatGptParameters] with the specified attributes.
  ChatGptParameters({
    required this.prompt,
    required this.model,
    required this.content,
    required this.topP,
    required this.frequencyPenalty,
    required this.presencePenalty,
    required this.thresholdWord,
    required this.maxTokens,
    required this.temperature,
  });

  /// Converts the [ChatGptParameters] instance into a JSON object.
  ///
  /// Returns a [Map] representation of the [ChatGptParameters] instance.
  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'model': model,
        'content': content,
        'topP': topP,
        'frequencyPenalty': frequencyPenalty,
        'presencePenalty': presencePenalty,
        'thresholdWord': thresholdWord,
        'maxTokens': maxTokens,
        'temperature': temperature,
      };

  /// Provides a string representation of the [ChatGptParameters] instance.
  ///
  /// Returns a string containing all the attributes of the [ChatGptParameters].
  @override
  String toString() {
    return 'Parametes{prompt: $prompt, model: $model, content: $content, topP: $topP, frequencyPenalty: $frequencyPenalty, presencePenalty: $presencePenalty, thresholdWord: $thresholdWord, maxTokens: $maxTokens, temperature: $temperature}';
  }
}
