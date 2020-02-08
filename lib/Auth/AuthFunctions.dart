import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnus/Models/User.dart';


class AuthFunctions {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _createUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_createUser);
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(error) {
      print(error.toString());
      return null;
    }
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _createUser(user);
    } catch(error) {
      print(error.toString());
      return null;
    }
  }

    Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _createUser(user);
    } catch(error) {
      print(error.toString());
      return null;
    }
  }

  Future<bool> cognitoSignIn(email, password, first, last, number, zip) async {
        print('email: $email, first: $first');
    final userPool = new CognitoUserPool(
    'us-east-2_GITI5y4tm', '7lkbib6sircnvn2n77csgc5kjs');
    final userAttributes = [
      new AttributeArg(name: 'given_name', value: first),
      new AttributeArg(name: 'family_name', value: last),
      new AttributeArg(name: 'phone_number', value: '+1$number'),
      new AttributeArg(name: 'email', value: email),
      //new AttributeArg(name: 'zip code', value: zip),
    ];

    var data;
    try {
      data = await userPool.signUp(email, password,
          userAttributes: userAttributes);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

}