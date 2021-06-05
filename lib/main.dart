import 'package:flutter/material.dart';
import 'package:perpusindo_v1/screen/loginui.dart';
import 'package:provider/provider.dart';
import 'package:perpusindo_v1/bloc/authstate.dart';

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
            textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
      ),
      title: 'Flutter Demo',
      home: TestAProvider(),
    );
    //   },
    // );
  }
}

class TestAProvider extends StatefulWidget {
  @override
  _TestAProviderState createState() => _TestAProviderState();
}

class _TestAProviderState extends State<TestAProvider> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // init();
  }

  // init() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await FlutterDownloader.initialize(
  //       debug: true // optional: set false to disable printing logs to console
  //       );
  // }

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
                          ElevatedButton(
                            onPressed: () async {},
                            child: Text('Download Images'),
                          ),
                          ElevatedButton(
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
                  showDialog(
                    builder: (context) {
                      return AlertDialog(
                        content: CircularProgressIndicator(),
                      );
                    },
                    context: context,
                  );
                  break;
                default:
                  return Scaffold();
                // return Splash('Authenticating');
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
