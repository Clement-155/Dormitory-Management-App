import 'passwordField.dart';
import 'package:flutter/material.dart';
import 'signupButton.dart';
import '../Animation/FadeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

//TODO Switch to login
class SignupPage extends StatefulWidget {
  @override
  late DateTime selectedDate = DateTime.now();
  int? selectedGender = 0;
  List<DropdownMenuItem<int>> get genderList{
    List<DropdownMenuItem<int>> menuItems = [
      DropdownMenuItem(child: Text("Laki-laki"),value: 0),
      DropdownMenuItem(child: Text("Perempuan"),value: 1),
      DropdownMenuItem(child: Text("Tidak ingin menyebutkan"),value: 2),
    ];
    return menuItems;
  }
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final dateController = TextEditingController();

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: widget.selectedDate != null ? widget.selectedDate : DateTime.now(),
        firstDate: DateTime(1930),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.onPrimary,
                onPrimary: Colors.white,
                surface: Colors.white70,
                onSurface: Theme.of(context).colorScheme.onSecondary,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child ?? SizedBox(),
          );
        });

    if (newSelectedDate != null) {
      widget.selectedDate = newSelectedDate;
      dateController
        ..text = DateFormat.yMMMd().format(widget.selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          Container(
            child: FadeAnimation(
              0.5,
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, .2),
                      blurRadius: 20.0,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Column(
                        //Email, Nama, Tanggal Lahir, Jenis Kelamin, Password + Confirm
                        children: <Widget>[
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          TextField(
                            cursorColor: Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nama Lengkap",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          //TODO : Field tanggal lahir dan dropdown jenis kelamin

                          TextField(
                              style: TextStyle(
                                  color: Colors.black),
                            focusNode: AlwaysDisabledFocusNode(),
                              controller: dateController, //editing controller of this TextField
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.calendar_today), //icon of text field
                                  labelText: "Enter Date" //label text of field
                              ),
                              readOnly: true,  // when true user cannot edit text
                              onTap: () async {
                                _selectDate(context);
                              }
                          ),
                          DropdownButtonFormField(

                            autovalidateMode: AutovalidateMode.always,
                            style: TextStyle(
                                color: Colors.black),
                              hint: const Text("Pilih jenis kelamin"),
                              items: widget.genderList,
                              onChanged: (int? value) {
                                widget.selectedGender = value;
                                setState(() {});
                              },
                            validator: (int? value) {
                              return value == null ? "Pilih jenis kelamin" : null;
                            },)
                          ,
                          TextField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor: Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          TextField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor: Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          PasswordField(),
                          PasswordField(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SignupButton(),
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}