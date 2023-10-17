import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserInputField extends Equatable {
  final String id;
  final String value;

  const UserInputField({
    required this.id,
    required this.value,
  });

  UserInputField.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          value: map['value'] as String,
        );

  DataMap toMap() => {
        'id': id,
        'value': value,
      };

  UserInputField copyWith({
    String? id,
    String? value,
  }) {
    return UserInputField(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  @override
  List<Object> get props => [id, value];
}
