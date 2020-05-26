// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:perpusindo_v1/model/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    authState = AuthState.Authenticating;
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var accessToken = result.accessToken;
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
        var profile = json.decode(graphResponse.body);
        var proid = profile["id"];
        print(accessToken.token);
        userdata = LoggedUser(
          displayName: profile['name'],
          email: profile['email'],
          id: profile['id'],
          photoProfile:
              "https://graph.facebook.com/v6.0/$proid/picture?type=large",
          token: accessToken.token,
        );
        signIn();
        break;
      case FacebookLoginStatus.cancelledByUser:
        authState = AuthState.Unauthenticated;
        print('cancelled');
        break;
      case FacebookLoginStatus.error:
        authState = AuthState.Unauthenticated;
        print('error');
        break;
    }
  }

  Future signInWithGoogle() async {
    authState = AuthState.Authenticating;
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      userdata = LoggedUser(
        displayName: googleSignInAccount.displayName,
        email: googleSignInAccount.email,
        id: googleSignInAccount.id,
        photoProfile: googleSignInAccount.photoUrl,
      );
      signIn();
    } catch (e) {
      authState = AuthState.Unauthenticated;
    }
  }

  void loginCheck(String email, String pass, BuildContext context) async {
    var jsonData;
    Map body = {
      'email': email,
      'password': pass,
    };
    try {
      var req = await http
          .post('http://192.168.1.3/ci_rest/index.php/kontak/ind2', body: body);
      if (req.statusCode == 200) {
        jsonData = json.decode(req.body);
        signInWithEmail(jsonData);
      } else if (req.statusCode == 204) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('failure : ' + "Incorrect password/email"),
          duration: Duration(seconds: 5),
        ));
      }
    } catch (e) {
      // print(e);
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Failure : ' + e.toString()),
          duration: Duration(seconds: 5),
        ));
    }
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
    bool googleLogged = await googleSignIn.isSignedIn();
    bool fblogged = await facebookLogin.isLoggedIn;
    print('here');
    if (shp.getString('LoginUser') != null) {
      data = shp.getString('LoginUser');
      Map jsonData = json.decode(data);
      signInWithEmail(jsonData);
    } else if (googleLogged) {
      await signInWithGoogle();
    } else if (fblogged) {
      await signInWithFacebook();
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
    await facebookLogin.logOut();
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
