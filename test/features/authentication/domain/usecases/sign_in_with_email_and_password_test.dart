import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_email_and_password.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late SignInWithEmailAndPassword usecase;
  late AuthenticationRepository repository;

  const params = SignInWithEmailAndPasswordParams.empty();
  final response = User.empty();

  setUp(() {
    repository = MockAuthRepo();
    usecase = SignInWithEmailAndPassword(repository);
  });

  test(
      'Should call the [AuthRepo.SignInWithEmailAndPassword] '
      'and return [User]', () async {
    //? Arrange
    when(
      () => repository.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => Right(response));

    //? Act
    final result = await usecase(params);

    //? Assert
    expect(result, equals(Right<dynamic, User>(response)));
    verify(
      () => repository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      ),
    ).called(1);

    verifyNoMoreInteractions(repository);
  });
}
