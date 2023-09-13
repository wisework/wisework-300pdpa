import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/features/authentication/domain/entities/user.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pdpa/features/authentication/domain/usecases/sign_in_with_google.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late SignInWithGoogle usecase;
  late AuthenticationRepository repository;

  final response = User.empty();

  setUp(() {
    repository = MockAuthRepo();
    usecase = SignInWithGoogle(repository);
  });

  test(
      'Should call the [AuthRepo.SignInWithGoogle] '
      'and return [User]', () async {
    //? Arrange
    when(() => repository.signInWithGoogle())
        .thenAnswer((_) async => Right(response));

    //? Act
    final result = await usecase();

    //? Assert
    expect(result, equals(Right<dynamic, User>(response)));
    verify(() => repository.signInWithGoogle()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
