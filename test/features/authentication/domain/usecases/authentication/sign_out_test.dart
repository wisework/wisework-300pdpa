import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:pdpa/features/authentication/domain/usecases/authentication/sign_out.dart';

class MockAuthRepo extends Mock implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late SignOut usecase;

  setUp(() {
    repository = MockAuthRepo();
    usecase = SignOut(repository);
  });

  test('Should call the [AuthRepo.SignOut]', () async {
    //? Arrange
    when(() => repository.signOut()).thenAnswer((_) async => const Right(null));

    //? Act
    final result = await usecase();

    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repository.signOut()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
