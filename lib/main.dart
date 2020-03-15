import 'package:flutter/material.dart';
import 'loginui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'authstate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange,
        accentColor: Color.fromRGBO(255, 152, 0, 1.0),
        toggleableActiveColor: Colors.orange,
        appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            color: Color.fromRGBO(12, 12, 12, 1.0),
            textTheme: TextTheme(title: TextStyle(color: Colors.white))),
      ),
      title: 'Flutter Demo',
      home: TestAProvider(),
    );
    //   },
    // );
  }
}

class TestAProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
      child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: Consumer(
            builder: (context, AuthProvider appState, _) {
              switch (appState.authState) {
                case AuthState.Initialize:
                  return Splash('Initialize');
                case AuthState.Authenticated:
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('List Page'),
                    ),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Welcome ' + appState.userData.displayName),
                          Text('Email :' + appState.userData.email),
                          Image.network(appState.userData.photoProfile),
                          RaisedButton(
                              onPressed: () {
                                print('pressed');
                                appState.signOut();
                              },
                              child: Text('LogOut')),
                        ],
                      ),
                    ),
                  );
                case AuthState.Unauthenticated:
                  return LoginForm();
                case AuthState.Authenticating:
                  return Splash('Authenticating');
              }
            },
          )),
    );
  }
}

class Splash extends StatelessWidget {
  Splash(this.data);
  final String data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            Text('$data'),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
