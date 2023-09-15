import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdpa/core/errors/exceptions.dart';
import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/authentication/data/datasources/remote/authentication_remote_data_source_implementation.dart';
import 'package:pdpa/features/authentication/data/models/user_model.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuthUser extends Mock implements User {
  @override
  String get uid => (jsonDecode(fixture('user.json')) as DataMap)['id'];
}

// ignore: subtype_of_sealed_class
class MockCollectionReference extends Mock
    implements CollectionReference<DataMap> {}

// ignore: subtype_of_sealed_class
class MockDocumentReference extends Mock
    implements DocumentReference<DataMap> {}

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<DataMap> {
  @override
  bool get exists => true;

  @override
  String get id => (jsonDecode(fixture('user.json')) as DataMap)['id'];

  @override
  DataMap data() {
    DataMap map = jsonDecode(fixture('user.json'));
    map.remove('id');
    return map;
  }
}

// ignore: subtype_of_sealed_class
class MockEmptyQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<DataMap> {
  @override
  bool get exists => false;
}

void main() {
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;
  late GoogleSignIn googleSignIn;

  late UserCredential userCredential;
  late User user;
  late CollectionReference<DataMap> collectionReference;
  late DocumentReference<DataMap> documentReference;
  late QueryDocumentSnapshot<DataMap> queryDocumentSnapshot;

  late AuthenticationRemoteDataSourceImplementation remoteDataSourceImpl;

  setUp(() {
    firestore = MockFirestore();
    auth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();

    userCredential = MockUserCredential();
    user = MockFirebaseAuthUser();
    collectionReference = MockCollectionReference();
    documentReference = MockDocumentReference();

    remoteDataSourceImpl = AuthenticationRemoteDataSourceImplementation(
      firestore,
      auth,
      googleSignIn,
    );
  });

  group('Test signInWithEmailAndPassword:', () {
    const email = 'mock@gmail.com';
    const password = '123456';

    test(
      'Should return [UserModel] when sign-in with email and password is successful',
      () async {
        //? Arrange
        queryDocumentSnapshot = MockQueryDocumentSnapshot();

        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);
        when(() => userCredential.user).thenReturn(user);

        when(() => firestore.collection(any())).thenReturn(collectionReference);
        when(() => collectionReference.doc(any()))
            .thenReturn(documentReference);
        when(() => documentReference.get())
            .thenAnswer((_) async => queryDocumentSnapshot);

        //? Act
        final result = await remoteDataSourceImpl.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        //? Assert
        expect(result, isA<UserModel>());
        verify(
          () => auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
        verify(
          () => firestore.collection(any()).doc(any()).get(),
        ).called(1);

        verifyNoMoreInteractions(auth);
        verifyNoMoreInteractions(firestore);
      },
    );

    test(
      'Should return [ApiException] when sign-in with email and password is failed',
      () async {
        //? Arrange
        queryDocumentSnapshot = MockEmptyQueryDocumentSnapshot();

        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        //? Act
        final methodCall = remoteDataSourceImpl.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        //? Assert
        expect(() => methodCall, throwsA(isA<ApiException>()));
        verify(
          () => auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);

        verifyNoMoreInteractions(auth);
        verifyNoMoreInteractions(firestore);
      },
    );

    test(
      'Should return [ApiException] when sign-in with email and password is user not found',
      () async {
        //? Arrange
        queryDocumentSnapshot = MockEmptyQueryDocumentSnapshot();

        when(
          () => auth.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);
        when(() => userCredential.user).thenReturn(user);

        when(() => firestore.collection(any())).thenReturn(collectionReference);
        when(() => collectionReference.doc(any()))
            .thenReturn(documentReference);
        when(() => documentReference.get())
            .thenAnswer((_) async => queryDocumentSnapshot);

        //? Act
        final methodCall = remoteDataSourceImpl.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        //? Assert
        expect(() => methodCall, throwsA(isA<ApiException>()));
        verify(
          () => auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);

        verifyNoMoreInteractions(auth);
        verifyNoMoreInteractions(firestore);
      },
    );
  });
}
