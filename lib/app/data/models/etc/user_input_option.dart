import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserInputOption extends Equatable {
  final String id;
  final String parentId;
  final bool value;

  const UserInputOption({
    required this.id,
    required this.parentId,
    required this.value,
  });

  UserInputOption.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          parentId: map['parentId'] as String,
          value: map['value'] as bool,
        );

  DataMap toMap() => {
        'id': id,
        'parentId': parentId,
        'value': value,
      };

  UserInputOption copyWith({
    String? id,
    String? parentId,
    bool? value,
  }) {
    return UserInputOption(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      value: value ?? this.value,
    );
  }

  @override
  List<Object> get props => [id, parentId, value];
}
