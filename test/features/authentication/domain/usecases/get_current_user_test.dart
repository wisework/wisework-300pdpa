import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/features/authentication/domain/entities/user_entity.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pdpa/features/authentication/domain/usecases/get_current_user.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late GetCurrentUser usecase;

  final response = UserEntity.empty();

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetCurrentUser(repository);
  });

  test(
      'Should call the [AuthRepo.GetCurrentUser] '
      'and return [User]', () async {
    //? Arrange
    when(
      () => repository.getCurrentUser(),
    ).thenAnswer((_) async => Right(response));

    //? Act
    final result = await usecase();

    //? Assert
    expect(result, equals(Right<dynamic, UserEntity>(response)));
    verify(
      () => repository.getCurrentUser(),
    ).called(1);

    verifyNoMoreInteractions(repository);
  });
}
