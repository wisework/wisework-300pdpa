import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class LocalizedModel extends Equatable {
  final String language;
  final String text;

  const LocalizedModel({
    required this.language,
    required this.text,
  });

  const LocalizedModel.empty() : this(language: '', text: '');

  LocalizedModel.fromMap(DataMap map)
      : this(
          language: map['language'] as String,
          text: map['text'] as String,
        );

  DataMap toMap() => {
        'language': language,
        'text': text,
      };

  LocalizedModel copyWith({
    String? language,
    String? text,
  }) {
    return LocalizedModel(
      language: language ?? this.language,
      text: text ?? this.text,
    );
  }

  @override
  List<Object> get props => [language, text];
}
