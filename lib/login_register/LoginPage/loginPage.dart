import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_golekost/navigation/nav_drawer.dart';
import './verificationFields.dart';
import './loginButton.dart';
import './signupPage.dart';
import './loginDecoration.dart';
import '../Animation/FadeAnimation.dart';
import '../../service/payment_service.dart';
//TODO : Switch to signup
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _pageLogin = true;
  // bool _rememberPassword = false;

  void _togglePage(bool _switchme) {
    setState(() {
        _pageLogin = _switchme;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    PaymentService service = PaymentService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Navigation Drawer',
        ),
        backgroundColor: const Color(0xff764abc),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              LoginDecoration(),
              FadeAnimation(
                0.5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor : _pageLogin
                            ? Color.fromRGBO(143, 148, 251, 1)
                            : Colors.transparent,
                      ),

                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: _pageLogin
                              ? Colors.white
                              : Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                      onPressed: () {
                        _togglePage(true);
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor : !_pageLogin
                            ? Color.fromRGBO(143, 148, 251, 1)
                            : Colors.transparent,
                      ),
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: _pageLogin
                              ? Color.fromRGBO(143, 148, 251, 1)
                              : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _togglePage(false);
                      },
                    ),
                  ],
                ),
              ),
              _pageLogin
                  ? Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          VerificationFields(),
                          /* Remember Password */
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: <Widget>[
                          //     Text("Remember Password?"),
                          //     Checkbox(
                          //       value: _rememberPassword ? true : false,
                          //       onChanged: (bool _newValue) {
                          //         setState(() {
                          //             _rememberPassword = _newValue;
                          //           },
                          //         );
                          //       },
                          //     ),
                          //   ],
                          // ),
                          FadeAnimation(
                            0.5,
                            Container(
                              alignment: AlignmentDirectional(1.0, 0.0),
                              child: TextButton(
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                                onPressed: () => {} //TODO : RESET PASSWORD,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LoginButton(),
                          // FadeAnimation(
                          //   0.5,
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       Text(
                          //         "New User?",
                          //       ),
                          //       FlatButton(
                          //         highlightColor: Colors.transparent,
                          //         splashColor: Colors.transparent,
                          //         child: Text(
                          //           "Sign Up",
                          //           style: TextStyle(
                          //             color: Color.fromRGBO(143, 148, 251, 1),
                          //           ),
                          //         ),
                          //         onPressed: () => {},
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  : SignupPage()
            ],
          ),
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
