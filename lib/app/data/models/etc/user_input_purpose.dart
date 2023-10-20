import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserInputPurpose extends Equatable {
  const UserInputPurpose({
    required this.id,
    required this.value,
    required this.purposeCategoryId,
  });

  final String id;
  final bool value;
  final String purposeCategoryId;

  const UserInputPurpose.empty()
      : this(
          id: '',
          value: true,
          purposeCategoryId: '',
        );

  UserInputPurpose.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          value: map['value'] as bool,
          purposeCategoryId: map['purposeCategoryId'] as String,
        );

  DataMap toMap() => {
        id: {
          'value': value,
          'purposeCategoryId': purposeCategoryId,
        }
      };

  UserInputPurpose copyWith({
    String? id,
    bool? value,
    String? purposeCategoryId,
  }) {
    return UserInputPurpose(
      id: id ?? this.id,
      value: value ?? this.value,
      purposeCategoryId: purposeCategoryId ?? this.purposeCategoryId,
    );
  }

  @override
  List<Object> get props => [id, value, purposeCategoryId];
}
