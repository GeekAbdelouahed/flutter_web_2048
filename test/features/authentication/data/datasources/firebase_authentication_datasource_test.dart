import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_2048/core/error/exceptions.dart';
import 'package:flutter_web_2048/features/authentication/data/datasources/authentication_datasource.dart';
import 'package:flutter_web_2048/features/authentication/data/datasources/firebase_authentication_datasource.dart';
import 'package:flutter_web_2048/features/authentication/data/models/user_model.dart';
import 'package:flutter_web_2048/features/authentication/domain/entities/user.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements Firestore {}

class MockAuthResult extends Mock implements AuthResult {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

main() {
  FirebaseAuthenticationDatasource datasource;
  MockFirebaseAuth mockFirebaseAuth;
  MockFirestore mockFirestore;
  MockCollectionReference mockCollectionReference;
  MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirestore();
    datasource = FirebaseAuthenticationDatasource(
      firebaseAuth: mockFirebaseAuth,
      firestore: mockFirestore,
    );

    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
  });

  test('should implement [AuthenticationDatasource]', () {
    // ASSERT
    expect(datasource, isA<AuthenticationDatasource>());
  });

  test('should throw when initialized with null argument', () async {
    // ACT & ASSERT
    expect(() => FirebaseAuthenticationDatasource(firebaseAuth: null, firestore: mockFirestore),
        throwsA(isA<AssertionError>()));
    expect(() => FirebaseAuthenticationDatasource(firebaseAuth: mockFirebaseAuth, firestore: null),
        throwsA(isA<AssertionError>()));
  });

  group('signinAnonymously', () {
    test('should call firebase auth', () async {
      // ARRANGE
      String username = 'username';
      String email = 'email';
      String photoUrl = 'photoUrl';
      var firebaseUser = MockFirebaseUser();
      when(firebaseUser.displayName).thenReturn(username);
      when(firebaseUser.email).thenReturn(email);
      when(firebaseUser.photoUrl).thenReturn(photoUrl);

      var authResult = MockAuthResult();
      when(authResult.user).thenReturn(firebaseUser);
      when(mockFirebaseAuth.signInAnonymously()).thenAnswer((_) async => authResult);

      // ACT
      await datasource.signInAnonymously();

      // ASSERT
      verify(mockFirebaseAuth.signInAnonymously()).called(1);
    });
    test('should throw a [FirebaseException] when datasource throw an error', () async {
      // ARRANGE
      when(mockFirebaseAuth.signInAnonymously()).thenThrow(Error);
      // ACT
      var call = () async => await datasource.signInAnonymously();

      // ASSERT
      expect(call, throwsA(isA<FirebaseException>()));
    });
    test('should throw a [FirebaseException] when datasource return null [AuthResult]', () async {
      // ARRANGE
      when(mockFirebaseAuth.signInAnonymously()).thenAnswer((_) => null);
      // ACT
      var call = () async => await datasource.signInAnonymously();

      // ASSERT
      expect(call, throwsA(isA<FirebaseException>()));
    });
    test('should return a [UserModel]', () async {
      // ARRANGE
      var authResult = MockAuthResult();
      when(authResult.user).thenReturn(MockFirebaseUser());
      when(mockFirebaseAuth.signInAnonymously()).thenAnswer((_) async => authResult);

      // ACT
      var user = await datasource.signInAnonymously();

      // ASSERT
      expect(user, isA<UserModel>());
    });
  });
  group('updateUserData', () {
    var testUser = UserModel(
      uid: 'uid',
      email: 'email',
      username: 'username',
      picture: 'picture',
      authenticationProvider: AuthenticationProvider.Anonymous,
    );
    test('should return the [DocumentReference.setData()] method output', () async {
      // ARRANGE
      var setDataOutput = Future.value();

      when(mockDocumentReference.setData(
        testUser.toJson(lastSeenDateTime: DateTime.now()),
        merge: true,
      )).thenAnswer((_) => setDataOutput);
      when(mockCollectionReference.document(testUser.uid)).thenReturn(mockDocumentReference);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);

      // ACT
      var actual = datasource.updateUserData(testUser);

      // ASSERT
      expect(actual, isA<Future>());
    });
    test('should call [DocumentReference.setData()]', () async {
      // ARRANGE
      var setDataOutput = Future.value();
      var lastSeendDateTime = DateTime.now();

      when(mockDocumentReference.setData(
        testUser.toJson(lastSeenDateTime: lastSeendDateTime),
        merge: true,
      )).thenAnswer((_) => setDataOutput);
      when(mockCollectionReference.document(testUser.uid)).thenReturn(mockDocumentReference);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);

      // ACT
      await datasource.updateUserData(testUser);

      // ASSERT
      verify(mockDocumentReference.setData(
        testUser.toJson(lastSeenDateTime: lastSeendDateTime),
        merge: true,
      )).called(1);
    }, retry: 5);
    test('should call [CollectionReference.document()]', () async {
      // ARRANGE
      var setDataOutput = Future.value();
      var lastSeendDateTime = DateTime.now();

      when(mockDocumentReference.setData(
        testUser.toJson(lastSeenDateTime: lastSeendDateTime),
        merge: true,
      )).thenAnswer((_) => setDataOutput);
      when(mockCollectionReference.document(testUser.uid)).thenReturn(mockDocumentReference);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);

      // ACT
      await datasource.updateUserData(testUser);

      // ASSERT
      verify(mockCollectionReference.document(testUser.uid)).called(1);
    });
    test('should call [Firestore.collection()]', () async {
      // ARRANGE
      var setDataOutput = Future.value();
      var lastSeendDateTime = DateTime.now();

      when(mockDocumentReference.setData(
        testUser.toJson(lastSeenDateTime: lastSeendDateTime),
        merge: true,
      )).thenAnswer((_) => setDataOutput);
      when(mockCollectionReference.document(testUser.uid)).thenReturn(mockDocumentReference);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);

      // ACT
      await datasource.updateUserData(testUser);

      // ASSERT
      verify(mockFirestore.collection('users')).called(1);
    });

    test('should throw a FirestoreException if something goes wrong', () async {
      // ARRANGE
      var lastSeendDateTime = DateTime.now();

      when(mockDocumentReference.setData(
        testUser.toJson(lastSeenDateTime: lastSeendDateTime),
        merge: true,
      )).thenThrow(Exception());
      when(mockCollectionReference.document(testUser.uid)).thenReturn(mockDocumentReference);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionReference);

      // ACT
      var call = () async => await datasource.updateUserData(testUser);

      // ASSERT
      expect(call, throwsA(isA<FirestoreException>()));
    }, retry: 10);
  });

  group('signOut', () {
    test('should call [FirebaseAuth.signOut()]', () async {
      // ACT
      await datasource.signOut();
      // ASSERT
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('should throw a [FirebaseException] when an error occurs', () async {
      // ARRANGE
      when(mockFirebaseAuth.signOut()).thenThrow(Exception());

      // ACT
      var call = () async => await datasource.signOut();

      // ASSERT
      expect(call, throwsA(isA<FirebaseException>()));
    });
  });

  group('signInWithEmailAndPassword', () {
    test('should call [Firebase.signInWithEmailAndPassword()] function', () async {
      // ARRANGE
      String email = 'email@example.com';
      String password = 'password';
      String username = 'username';
      String photoUrl = 'photoUrl';
      var firebaseUser = MockFirebaseUser();
      when(firebaseUser.displayName).thenReturn(username);
      when(firebaseUser.email).thenReturn(email);
      when(firebaseUser.photoUrl).thenReturn(photoUrl);

      var authResult = MockAuthResult();
      when(authResult.user).thenReturn(firebaseUser);
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async => authResult);

      // ACT
      await datasource.signInWithEmailAndPassword(email, password);

      // ASSERT
      verify(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .called(1);
    });
    test(
        'should throw [FirebaseException] if [Firebase.signInWithEmailAndPassword()] function returns NULL',
        () async {
      // ARRANGE
      String email = 'email@example.com';
      String password = 'password';

      when(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async => null);

      // ACT
      var call = () async => await datasource.signInWithEmailAndPassword(email, password);

      // ASSERT
      expect(call, throwsA(isA<FirebaseException>()));
    });

    test('should returns a [UserModel]', () async {
      // ARRANGE
      String email = 'email@example.com';
      String password = 'password';
      String username = 'username';
      String photoUrl = 'photoUrl';
      var firebaseUser = MockFirebaseUser();
      when(firebaseUser.displayName).thenReturn(username);
      when(firebaseUser.email).thenReturn(email);
      when(firebaseUser.photoUrl).thenReturn(photoUrl);

      var authResult = MockAuthResult();
      when(authResult.user).thenReturn(firebaseUser);
      when(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async => authResult);

      // ACT
      var actual = await datasource.signInWithEmailAndPassword(email, password);

      // ASSERT
      expect(actual, isA<UserModel>());
    });

    test('should throw [FirebaseException] if [Firebase.signInWithEmailAndPassword()] fails',
        () async {
      // ARRANGE
      String email = 'email@example.com';
      String password = 'password';

      when(mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: password))
          .thenThrow(Exception());

      // ACT
      var call = () async => await datasource.signInWithEmailAndPassword(email, password);

      // ASSERT
      expect(call, throwsA(isA<FirebaseException>()));
    });
  });
}
