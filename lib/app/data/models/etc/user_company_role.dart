import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class UserCompanyRole extends Equatable {
  const UserCompanyRole({
    required this.id,
    required this.role,
  });

  final String id;
  final UserRoles role;

  const UserCompanyRole.empty()
      : this(
          id: '',
          role: UserRoles.viewer,
        );

  UserCompanyRole.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          role: UserRoles.values[map['role'] as int],
        );

  DataMap toMap() => {id: role.index};

  UserCompanyRole copyWith({
    String? id,
    UserRoles? role,
  }) {
    return UserCompanyRole(
      id: id ?? this.id,
      role: role ?? this.role,
    );
  }

  @override
  List<Object> get props => [id, role];
}
