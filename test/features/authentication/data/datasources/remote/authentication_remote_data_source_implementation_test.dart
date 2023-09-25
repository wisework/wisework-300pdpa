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

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {
  @override
  String get email => 'mock@gmail.com';
}

class MockGoogleSignInAuth extends Mock implements GoogleSignInAuthentication {
  @override
  String? get accessToken => 'mock-access-token';

  @override
  String? get idToken => 'mock-id-token';
}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuthUser extends Mock implements User {
  @override
  String get uid => (jsonDecode(fixture('user.json')) as DataMap)['id'];

  @override
  String? get displayName => 'mock-name';

  @override
  String get email => 'mock@gmail.com';

  @override
  bool get emailVerified => true;
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

  late GoogleSignInAccount googleSignInAccount;
  late GoogleSignInAuthentication googleSignInAuth;
  late AuthCredential authCredential;
  late UserCredential userCredential;
  // late User user;
  // late CollectionReference<DataMap> collectionReference;
  // late DocumentReference<DataMap> documentReference;
  // late QueryDocumentSnapshot<DataMap> queryDocumentSnapshot;

  late AuthenticationRemoteDataSourceImplementation remoteDataSourceImpl;

  setUp(() {
    firestore = MockFirestore();
    auth = MockFirebaseAuth();
    googleSignIn = MockGoogleSignIn();

    googleSignInAccount = MockGoogleSignInAccount();
    googleSignInAuth = MockGoogleSignInAuth();
    userCredential = MockUserCredential();
    // user = MockFirebaseAuthUser();
    // collectionReference = MockCollectionReference();
    // documentReference = MockDocumentReference();

    remoteDataSourceImpl = AuthenticationRemoteDataSourceImplementation(
      firestore,
      auth,
      googleSignIn,
    );
  });

  setUpAll(() {
    authCredential = MockAuthCredential();
    registerFallbackValue(authCredential);
  });

  group('Test getCurrentUser:', () {
    // test(
    //   'Should return [UserModel] when get current user is successful',
    //   () async {
    //     //? Arrange
    //     queryDocumentSnapshot = MockQueryDocumentSnapshot();

    //     when(
    //       () => auth.currentUser,
    //     ).thenReturn(user);

    //     when(() => firestore.collection(any())).thenReturn(collectionReference);
    //     when(() => collectionReference.doc(any()))
    //         .thenReturn(documentReference);
    //     when(() => documentReference.get())
    //         .thenAnswer((_) async => queryDocumentSnapshot);

    //     //? Act
    //     final result = await remoteDataSourceImpl.getCurrentUser();

    //     //? Assert
    //     expect(result, isA<UserModel>());
    //     verify(
    //       () => auth.currentUser,
    //     ).called(1);
    //     verify(
    //       () => firestore.collection(any()).doc(any()).get(),
    //     ).called(1);

    //     verifyNoMoreInteractions(auth);
    //     verifyNoMoreInteractions(firestore);
    //   },
    // );

    test(
      'Should return [UserModel.empty()] when get current user is failed',
      () async {
        //? Arrange
        // queryDocumentSnapshot = MockEmptyQueryDocumentSnapshot();

        when(
          () => auth.currentUser,
        ).thenReturn(null);

        //? Act
        final result = await remoteDataSourceImpl.getCurrentUser();

        //? Assert
        expect(result, equals(UserModel.empty()));
        verify(
          () => auth.currentUser,
        ).called(1);

        verifyNoMoreInteractions(auth);
        verifyNoMoreInteractions(firestore);
      },
    );

    // test(
    //   'Should return [ApiException] when get current user is user not found',
    //   () async {
    //     //? Arrange
    //     queryDocumentSnapshot = MockEmptyQueryDocumentSnapshot();

    //     when(
    //       () => auth.currentUser,
    //     ).thenReturn(user);

    //     when(() => firestore.collection(any())).thenReturn(collectionReference);
    //     when(() => collectionReference.doc(any()))
    //         .thenReturn(documentReference);
    //     when(() => documentReference.get())
    //         .thenAnswer((_) async => queryDocumentSnapshot);

    //     //? Act
    //     final methodCall = remoteDataSourceImpl.getCurrentUser();

    //     //? Assert
    //     expect(() => methodCall, throwsA(isA<ApiException>()));
    //     verify(
    //       () => auth.currentUser,
    //     ).called(1);
    //     verify(
    //       () => firestore.collection(any()).doc(any()).get(),
    //     ).called(1);

    //     verifyNoMoreInteractions(auth);
    //     verifyNoMoreInteractions(firestore);
    //   },
    // );
  });

  group('Test signInWithGoogle:', () {
    // test(
    //   'Should return [UserModel] when sign-in with Google is successful',
    //   () async {
    //     //? Arrange
    //     queryDocumentSnapshot = MockQueryDocumentSnapshot();

    //     when(
    //       () => googleSignIn.signIn(),
    //     ).thenAnswer((_) async => googleSignInAccount);
    //     when(() => googleSignInAccount.authentication)
    //         .thenAnswer((_) async => googleSignInAuth);
    //     when(
    //       () => auth.signInWithCredential(any()),
    //     ).thenAnswer((_) async => userCredential);
    //     when(() => userCredential.user).thenReturn(user);

    //     when(() => firestore.collection(any())).thenReturn(collectionReference);
    //     when(() => collectionReference.doc(any()))
    //         .thenReturn(documentReference);
    //     when(() => documentReference.get())
    //         .thenAnswer((_) async => queryDocumentSnapshot);

    //     //? Act
    //     final result = await remoteDataSourceImpl.signInWithGoogle();

    //     //? Assert
    //     expect(result, isA<UserModel>());
    //     verify(
    //       () => googleSignIn.signIn(),
    //     ).called(1);
    //     verify(
    //       () => auth.signInWithCredential(any()),
    //     ).called(1);
    //     verify(
    //       () => firestore.collection(any()),
    //     ).called(1);

    //     verifyNoMoreInteractions(googleSignIn);
    //     verifyNoMoreInteractions(auth);
    //     verifyNoMoreInteractions(firestore);
    //   },
    // );

    // test(
    //   'Should return [UserModel] when sign-in with Google is user not found '
    //   'then create this user for the first time',
    //   () async {
    //     //? Arrange
    //     queryDocumentSnapshot = MockEmptyQueryDocumentSnapshot();

    //     when(
    //       () => googleSignIn.signIn(),
    //     ).thenAnswer((_) async => googleSignInAccount);
    //     when(() => googleSignInAccount.authentication)
    //         .thenAnswer((_) async => googleSignInAuth);
    //     when(
    //       () => auth.signInWithCredential(any()),
    //     ).thenAnswer((_) async => userCredential);
    //     when(() => userCredential.user).thenReturn(user);

    //     when(() => firestore.collection(any())).thenReturn(collectionReference);
    //     when(() => collectionReference.doc(any()))
    //         .thenReturn(documentReference);
    //     when(() => documentReference.get())
    //         .thenAnswer((_) async => queryDocumentSnapshot);
    //     when(() => collectionReference.doc(any()))
    //         .thenReturn(documentReference);
    //     when(() => documentReference.set(any())).thenAnswer((_) async {});

    //     //? Act
    //     final result = await remoteDataSourceImpl.signInWithGoogle();

    //     //? Assert
    //     expect(result, isA<UserModel>());
    //     verify(
    //       () => googleSignIn.signIn(),
    //     ).called(1);
    //     verify(
    //       () => auth.signInWithCredential(any()),
    //     ).called(1);
    //     verify(
    //       () => firestore.collection(any()).doc(any()),
    //     ).called(2);
    //     verify(
    //       () => documentReference.get(),
    //     ).called(1);
    //     verify(
    //       () => documentReference.set(any()),
    //     ).called(1);

    //     verifyNoMoreInteractions(googleSignIn);
    //     verifyNoMoreInteractions(auth);
    //     verifyNoMoreInteractions(firestore);
    //   },
    // );

    test(
      'Should return [ApiException] when sign-in with Google is failed',
      () async {
        //? Arrange
        when(
          () => googleSignIn.signIn(),
        ).thenAnswer((_) async => googleSignInAccount);
        when(() => googleSignInAccount.authentication)
            .thenAnswer((_) async => googleSignInAuth);
        when(
          () => auth.signInWithCredential(any()),
        ).thenAnswer((_) async => userCredential);

        //? Act
        final methodCall = remoteDataSourceImpl.signInWithGoogle();

        //? Assert
        expect(() => methodCall, throwsA(isA<ApiException>()));
        verify(
          () => googleSignIn.signIn(),
        ).called(1);

        verifyNoMoreInteractions(googleSignIn);
      },
    );
  });

  group('Test signOut:', () {
    test(
      'Should sign-out completely',
      () async {
        //? Arrange
        when(
          () => googleSignIn.isSignedIn(),
        ).thenAnswer((_) async => true);
        when(
          () => googleSignIn.disconnect(),
        ).thenAnswer((_) async => googleSignInAccount);
        when(
          () => auth.signOut(),
        ).thenAnswer((_) async {});

        //? Act
        await remoteDataSourceImpl.signOut();

        //? Assert
        verify(
          () => googleSignIn.isSignedIn(),
        ).called(1);
        verify(
          () => googleSignIn.disconnect(),
        ).called(1);
        verify(
          () => auth.signOut(),
        ).called(1);

        verifyNoMoreInteractions(googleSignIn);
        verifyNoMoreInteractions(auth);
      },
    );
  });
}
