/// Class representing an Article
class Article {
  final int no;
  final int semaine;
  final int media;
  final int articleRepris;
  final String url;
  final String title;
  final String chapo;
  final String content;

  /// Creates an [Article] with the specified attributes.
  Article({
    required this.no,
    required this.semaine,
    required this.media,
    required this.articleRepris,
    required this.url,
    required this.title,
    required this.chapo,
    required this.content,
  });

  /// Converts the [Article] instance into a JSON object.
  ///
  /// Returns a [Map] representation of the [Article] instance.
  Map<String, dynamic> toJson() => {
        'no': no,
        'semaine': semaine,
        'media': media,
        'articleRepris': articleRepris,
        'url': url,
        'title': title,
        'chapo': chapo,
        'content': content,
      };

  /// Provides a string representation of the [Article] instance.
  ///
  /// Returns a string containing all the attributes of the [Article].
  @override
  String toString() {
    return 'Article{no: $no, semaine: $semaine, media: $media, articleRepris: $articleRepris, url: $url, title: $title, chapo: $chapo, content: $content }';
  }
}
