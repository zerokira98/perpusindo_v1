import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'loginui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return DynamicTheme(
    //   defaultBrightness: Brightness.dark,
    //   data: (brightness) => ThemeData(
    //     primarySwatch: Colors.indigo,
    //     // accentColor: Colors.orange,
    //     // accentColorBrightness: brightness,
    //     // buttonColor: Colors.indigo,
    //     brightness: brightness,
    //   ),
    //   themedWidgetBuilder: (context, theme) {
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
        home: MyHomePage(title: 'Flutter Demo Home Page'));
    //   },
    // );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      // DynamicTheme.of(context).setBrightness(
      //     Theme.of(context).brightness == Brightness.dark
      //         ? Brightness.light
      //         : Brightness.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This m.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
                child: Text('next Page'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginForm())))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
