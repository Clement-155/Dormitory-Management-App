import 'package:flutter/material.dart';

import '../Animation/FadeAnimation.dart';

class SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.5,
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
            ],
          ),
          borderRadius: BorderRadius.circular(100.0),
        ),
        height: 50,
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          onPressed: () {},

          child:
            Center(
              child: Text(
                "SignUp",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ),
      ),
    );
  }
}
