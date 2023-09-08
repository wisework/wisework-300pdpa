class LocalizedText {
  final String language;
  final String text;

  LocalizedText({
    required this.language,
    required this.text,
  });

  static List<Map<String, dynamic>> toList(List<LocalizedText> list) {
    return list
        .map((localizedText) => <String, dynamic>{
              'language': localizedText.language,
              'text': localizedText.text,
            })
        .toList();
  }

  static List<LocalizedText> fromList(List<Map<String, dynamic>> list) {
    return list
        .map((map) => LocalizedText(
              language: map['language'] as String,
              text: map['text'] as String,
            ))
        .toList();
  }

  LocalizedText copyWith({
    String? language,
    String? text,
  }) {
    return LocalizedText(
      language: language ?? this.language,
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'language': language,
      'text': text,
    };
  }

  factory LocalizedText.fromMap(Map<String, dynamic> map) {
    return LocalizedText(
      language: map['language'] as String,
      text: map['text'] as String,
    );
  }

  @override
  String toString() => 'LocalizedText(language: $language, text: $text)';
}
