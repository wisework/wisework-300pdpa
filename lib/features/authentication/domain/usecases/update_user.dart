import 'package:equatable/equatable.dart';
import 'package:pdpa/core/usecases/usecase_with_params.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  UpdateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call(UpdateUserParams params) => _repository.updateUser(
        user: params.user,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.user,
  });

  UpdateUserParams.empty() : this(user: UserEntity.empty());

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}
