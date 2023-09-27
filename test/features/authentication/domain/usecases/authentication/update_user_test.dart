import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/update_user.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late UpdateUser usecase;

  final model = UserEntity.empty();
  final params = UpdateUserParams(user: model);

  setUp(() {
    repository = MockAuthRepo();
    usecase = UpdateUser(repository);
  });

  setUpAll(() {
    registerFallbackValue(model);
  });

  test('Should call the [AuthRepo.UpdateUser]', () async {
    //? Arrange
    when(
      () => repository.updateUser(
        user: any(named: 'user'),
      ),
    ).thenAnswer((_) async => const Right(null));

    //? Act
    final result = await usecase(params);

    //? Assert
    expect(result, equals(const Right<dynamic, void>(null)));
    verify(
      () => repository.updateUser(
        user: params.user,
      ),
    ).called(1);

    verifyNoMoreInteractions(repository);
  });
}
