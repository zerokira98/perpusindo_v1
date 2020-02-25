import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
// import 'math';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode fsEmail = FocusNode();
  FocusNode fsPassword = FocusNode();
  bool check = false;
  AccelerometerEvent event;
  StreamSubscription accel;
  double horizontal = 0;
  Timer timer;
  double loading = 0;
  bool tapped = false;
  Alignment ali = Alignment(-0.1, 0);
  // Alignment alib = Alignment(0, 0);
  @override
  void initState() {
    // TODO: implement initState
    accel = accelerometerEvents.listen((AccelerometerEvent even) {
      setState(() {
        event = even;
      });
    });
    timer = Timer.periodic(Duration(milliseconds: 30), (_) {
      setHorizontal(event);
      // print(event);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    accel.cancel();
    timer.cancel();
    super.dispose();
  }

  setHorizontal(AccelerometerEvent event) {
    setState(() {
      horizontal = event.x / 65;
      ali = Alignment.lerp(ali, Alignment(0.5 - horizontal, 0), 0.12);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget head(bool landscape) {
      bool lands = landscape;
      return Container(
        height: lands ? MediaQuery.of(context).size.height : 160,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor, BlendMode.modulate),
                child: Image.asset(
                  'images/banner.jpg',
                  // alignment: Alignment(0.5 - horizontal, 0),
                  alignment: ali,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 18,
              child: SafeArea(
                child: Text(
                  'Masuk',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Positioned(
                top: 18,
                left: 18,
                child: SafeArea(
                  child: Text(
                    '__',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                )),
            AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                bottom: 14,
                right: 14 + loading, //14
                child: Image.asset(
                  'images/pilogo.png',
                  height: 45,
                  color: Colors.white,
                )),
            AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                bottom: 14,
                right: 14 - 52 + loading,
                child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    Widget bottom(int orients) {
      int orient = orients;
      if (orient == 0) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 8, left: 18, right: 18),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: email,
                            focusNode: fsEmail,
                            textInputAction: TextInputAction.next,
                            // onSubmitted: ,
                            onFieldSubmitted: (val) {
                              fsEmail.unfocus();
                              FocusScope.of(context).requestFocus(fsPassword);
                            },
                            decoration:
                                InputDecoration(labelText: 'Username/Email'),

                            // decoration:,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: password,
                            focusNode: fsPassword,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          check = !check;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              // checkColor: ,
                              value: check,
                              onChanged: (val) {
                                setState(() {
                                  check = val;
                                });
                              }),
                          Text('Tetap login di perangkat ini'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            setState(() {
                              tapped = !tapped;
                              if (tapped) {
                                loading = 50;
                              } else {
                                loading = 0;
                              }
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 14.0, right: 14),
                            child: Text(' Masuk '),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text('atau'),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Daftar menggunakan email',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Atau gunakan SNS'),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.g_translate),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            Container(
                              child: Icon(Icons.g_translate),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            Container(
                              child: Icon(Icons.g_translate),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
              // Spacer(),
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.white,
                child: InkWell(
                  onTap: () {},
                  child: Text(
                    'Ada masalah login?',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                width: double.maxFinite,
              )
            ],
          ),
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height,
          // color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Container(),
              Container(
                padding: EdgeInsets.only(top: 8, left: 18, right: 18),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: email,
                            focusNode: fsEmail,
                            textInputAction: TextInputAction.next,
                            // onSubmitted: ,
                            onFieldSubmitted: (val) {
                              fsEmail.unfocus();
                              FocusScope.of(context).requestFocus(fsPassword);
                            },
                            decoration:
                                InputDecoration(labelText: 'Username/Email'),

                            // decoration:,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: password,
                            focusNode: fsPassword,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: true,
                            onChanged: (val) {
                              setState(() {});
                            }),
                        Text('Tetap login di perangkat ini'),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 14.0, right: 14),
                            child: Text(' Masuk '),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).accentColor,
                        ),
                        Text('atau'),
                        Text(
                          'Daftar menggunakan email',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).primaryColor
                                    : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Atau gunakan SNS'),
                        Row(
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.g_translate,
                                size: 18,
                              ),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            Container(
                              child: Icon(
                                Icons.g_translate,
                                size: 18,
                              ),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                            Container(
                              child: Icon(
                                Icons.g_translate,
                                size: 18,
                              ),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(18)),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              // Spacer(),
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.white,
                child: Text(
                  'Ada masalah login?',
                  style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColor
                          : Colors.orange,
                      fontWeight: FontWeight.w500),
                ),
                width: double.maxFinite,
              )
            ],
          ),
        );
      }
    }

    return Scaffold(
      body:
          // SingleChildScrollView(
          //   child:
          Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/login-default.jpg'),
                fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Center(
            child: Container(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.blueGrey[900],
              child: SingleChildScrollView(
                child: Column(children: [
                  MediaQuery.of(context).orientation.index == 0
                      ? head(false)
                      : Container(
                          height: 0,
                        ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: MediaQuery.of(context).orientation.index == 1
                            ? 3
                            : 0,
                        child: MediaQuery.of(context).orientation.index == 1
                            ? head(true)
                            : Container(
                                width: 0,
                              ),
                      ),
                      Expanded(
                        flex: 5,
                        // child: SingleChildScrollView(
                        child: MediaQuery.of(context).orientation.index == 0
                            ? bottom(0)
                            : bottom(1),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
