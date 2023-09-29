import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class LocalizedText extends Equatable {
  final String language;
  final String text;

  const LocalizedText({
    required this.language,
    required this.text,
  });

  const LocalizedText.empty() : this(language: '', text: '');

  LocalizedText.fromMap(DataMap map)
      : this(
          language: map['language'] as String,
          text: map['text'] as String,
        );

  DataMap toMap() => {
        'language': language,
        'text': text,
      };

  LocalizedText copyWith({
    String? language,
    String? text,
  }) {
    return LocalizedText(
      language: language ?? this.language,
      text: text ?? this.text,
    );
  }

  @override
  List<Object> get props => [language, text];
}
