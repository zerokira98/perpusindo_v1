// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'user_model.dart';
import 'dart:convert';

enum AuthState { Initialize, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  LoggedUser userdata;
  AuthState authState = AuthState.Initialize;
  AuthProvider() {
    setup();
    userdata = LoggedUser();
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  GoogleSignInAccount get currentGoogleUser => googleSignIn.currentUser;

  String data;
  LoggedUser get userData => userdata;

  Future signInWithFacebook() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        signIn();
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelled');
        break;
      case FacebookLoginStatus.error:
        print('error');
        break;
    }
  }

  Future<String> signInWithGoogle() async {
    authState = AuthState.Authenticating;
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    userdata = LoggedUser(
      displayName: googleSignInAccount.displayName,
      email: googleSignInAccount.email,
      id: googleSignInAccount.id,
      photoProfile: googleSignInAccount.photoUrl,
    );
    print(googleSignIn.currentUser);
    signIn();
    return 'signInWithGoogle succeeded: ';
  }

  void signInWithEmail(jsonData) {
    authState = AuthState.Authenticating;
    print(jsonData[0]['email']);
    setLoggedUser(jsonData.toString());

    userdata = LoggedUser(
      displayName: jsonData[0]['first_name'] + " " + jsonData[0]['last_name'],
      email: jsonData[0]['email'],
      id: jsonData[0]['id'],
      photoProfile: "",
    );
    signIn();
  }

  void setup() async {
    SharedPreferences shp = await SharedPreferences.getInstance();
    bool issignin = await googleSignIn.isSignedIn();
    print('here');
    if (shp.getString('LoginUser') != null) {
      data = shp.getString('LoginUser');
      Map jsonData = json.decode(data);
      signInWithEmail(jsonData);
    } else if (issignin) {
      await signInWithGoogle();
    } else {
      authState = AuthState.Unauthenticated;
      notifyListeners();
    }
  }

  void setLoggedUser(String str) async {
    SharedPreferences shp = await SharedPreferences.getInstance();
    shp.setString('LoginUser', str);
    print(shp.getString('LoginUser'));
  }

  void signOut() async {
    await googleSignIn.signOut();
    SharedPreferences shp = await SharedPreferences.getInstance();
    shp.remove('LoginUser');
    authState = AuthState.Unauthenticated;
    notifyListeners();
  }

  void signIn() {
    authState = AuthState.Authenticated;
    notifyListeners();
  }
}
