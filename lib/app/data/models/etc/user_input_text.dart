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

// import 'package:equatable/equatable.dart';
// import 'package:pdpa/app/shared/utils/typedef.dart';

// class UserInputField extends Equatable {
//   final String id;
//   final String value;
//   final String fieldId;

//   const UserInputField({
//     required this.id,
//     required this.value,
//     required this.fieldId,
//   });

//   UserInputField.fromMap(DataMap map)
//       : this(
//           id: map['id'] as String,
//           value: map['value'] as String,
//           fieldId: map['fieldId'] as String,
//         );

//   DataMap toMap() => {
//         id: {
//           'value': value,
//           'fieldId': fieldId,
//         }
//       };

//   UserInputField copyWith({
//     String? id,
//     String? value,
//     String? fieldId,
//   }) {
//     return UserInputField(
//       id: id ?? this.id,
//       value: value ?? this.value,
//       fieldId: fieldId ?? this.fieldId,
//     );
//   }

//   @override
//   List<Object> get props => [id, value, fieldId];
// }
