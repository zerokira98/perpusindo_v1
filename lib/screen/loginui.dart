import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:provider/provider.dart';
import 'package:perpusindo_v1/bloc/authstate.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'math';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  Animation myanimation;
  AnimationController anicont;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode fsEmail = FocusNode();
  FocusNode fsPassword = FocusNode();
  bool securetext = true;
  bool check = false;
  AccelerometerEvent event;
  StreamSubscription accel;
  double horizontal = 0;
  Timer timer;
  double loading = 0;
  bool tapped = false;
  bool ready = false;
  Alignment ali = Alignment(-0.1, 0);
  @override
  void initState() {
    anicont =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    myanimation = Tween(begin: 0.0, end: 1.0).animate(anicont);
    accel = accelerometerEvents.listen((AccelerometerEvent even) {
      setState(() {
        event = even;
      });
    });
    if (mounted) {
      timer = Timer.periodic(Duration(milliseconds: 30), (_) {
        setHorizontal(event);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    anicont.dispose();
    accel.cancel();
    timer.cancel();
    super.dispose();
  }

  setHorizontal(AccelerometerEvent event) {
    setState(() {
      horizontal = event.x / 20;
      ali = Alignment.lerp(ali, Alignment(0.5 - horizontal, 0), 0.1);
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authp = Provider.of<AuthProvider>(context);

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
              top: 2,
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
                top: 10,
                left: 18,
                child: SafeArea(
                  child: Text(
                    '__',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                )),
            AnimatedPositioned(
                duration: Duration(milliseconds: 245),
                bottom: 16,
                right: 14,
                // + loading, //14
                child: Image.asset(
                  'images/pilogo.png',
                  height: 45,
                  color: Colors.white,
                )),
            // AnimatedPositioned(
            //   duration: Duration(milliseconds: 300),
            //   bottom: 16,
            //   right: 14 - 70 + loading,
            //   child: Container(
            //     height: 45,
            //     padding:
            //         EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 16),
            //     color: Colors.white,
            //     child: AnimatedSwitcher(
            //       duration: Duration(milliseconds: 200),
            //       child: !ready
            //           ? CircularProgressIndicator()
            //           : AnimatedIcon(
            //               icon: AnimatedIcons.pause_play,
            //               color: Colors.green,
            //               size: 28,
            //               progress: myanimation),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
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
                        child: BottomForm(),
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

class BottomForm extends StatefulWidget {
  @override
  _BottomFormState createState() => _BottomFormState();
}

class _BottomFormState extends State<BottomForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode fsEmail = FocusNode();
  FocusNode fsPassword = FocusNode();
  bool securetext = true;
  bool check = false;

  final _formKey = GlobalKey<FormState>();
  // List<Widget> bottomStatic() {
  //     return ;
  //   }
  @override
  Widget build(BuildContext context) {
    final authp = Provider.of<AuthProvider>(context);
    var orient = MediaQuery.of(context).orientation.index;
    bool orientBool = (orient == 0);

    return Container(
      height: !orientBool ? MediaQuery.of(context).size.height : null,
      child: Column(
        // crossAxisAlignment: orientBool?CrossAxisAlignment.start,
        mainAxisAlignment: orientBool
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(),
          Container(),
          Container(
            padding: EdgeInsets.only(top: 8, left: 18, right: 18),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: email,
                          focusNode: fsEmail,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            return val.isEmpty ? "can't be empty" : null;
                          },
                          onFieldSubmitted: (val) {
                            fsEmail.unfocus();
                            FocusScope.of(context).requestFocus(fsPassword);
                          },
                          decoration:
                              InputDecoration(labelText: 'Username/Email'),
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
                          obscureText: securetext,
                          validator: (val) {
                            return val.isEmpty ? "can't be empty" : null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    securetext = !securetext;
                                  });
                                },
                                child: Icon(securetext
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              )),
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
                      Expanded(
                        flex: 3,
                        child: Builder(
                          builder: (context) => MaterialButton(
                            onPressed: () {
                              // if (email.text == "" && password.text == "") {}
                              _formKey.currentState.validate();
                              authp.loginCheck(
                                  email.text, password.text, context);
                              // setState(() {
                              //   tapped = !tapped;
                              //   if (tapped) {
                              //     loading = 50;
                              //     Future.delayed(Duration(seconds: 5), () {
                              //       setState(() {
                              //         ready = !ready;
                              //         anicont.forward();
                              //       });
                              //     });
                              //   } else {
                              //     loading = 0;
                              //     setState(() {
                              //       ready = !ready;
                              //       anicont.reverse();
                              //     });
                              //   }
                              // });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 2),
                              child: Text(' Masuk '),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Expanded(flex: 2, child: Center(child: Text('atau'))),
                      Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'Daftar menggunakan email',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
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
                          InkWell(
                            onTap: () {},
                            child: Container(
                              child: ImageIcon(
                                  AssetImage('images/icon/twitter.png')),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              authp.signInWithFacebook();
                            },
                            child: Container(
                              child: ImageIcon(
                                  AssetImage('images/icon/facebook.png')),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              authp.signInWithGoogle();
                            },
                            child: Container(
                              child: ImageIcon(
                                  AssetImage('images/icon/google.png')),
                              margin: EdgeInsets.only(left: 4),
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                            ),
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
          ),
          // Spacer(),
          Container(
            padding: EdgeInsets.all(12),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[100],
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
  }
}
