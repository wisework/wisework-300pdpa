import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserInputText extends Equatable {
  const UserInputText({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;

  const UserInputText.empty()
      : this(
          id: '',
          text: '',
        );

  UserInputText.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          text: map['text'] as String,
        );

  DataMap toMap() => {id: text};

  UserInputText copyWith({
    String? id,
    String? text,
  }) {
    return UserInputText(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  @override
  List<Object> get props => [id, text];
}
