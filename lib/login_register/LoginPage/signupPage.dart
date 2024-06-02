import 'package:fp_golekost/model/user_model.dart';

import 'package:flutter/material.dart';
import '../Animation/FadeAnimation.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fp_golekost/service/user_service.dart';

//TODO Switch to login
class SignupPage extends StatefulWidget {
  @override


    List<DropdownMenuItem<int>> get genderList {
      List<DropdownMenuItem<int>> menuItems = [
        DropdownMenuItem(child: Text("Laki-laki"), value: 0),
        DropdownMenuItem(child: Text("Perempuan"), value: 1),
        DropdownMenuItem(child: Text("Tidak ingin menyebutkan"), value: 2),
      ];
      return menuItems;
    }

    List<DropdownMenuItem<int>> get roleList {
      List<DropdownMenuItem<int>> menuItems = [
        DropdownMenuItem(child: Text("Penghuni Kost"), value: 0),
        DropdownMenuItem(child: Text("Pemilik Kost"), value: 1),
      ];
      return menuItems;
    }


  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late DateTime selectedDate = DateTime(1900);
  int? selectedGender = 0;
  int? selectedRole = 0;
  // text editing controllers
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final dateController = TextEditingController();

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        // Umur minimal 18 tahun
        initialDate:
            DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
        firstDate: DateTime(1930),
        lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
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
      selectedDate = newSelectedDate;
      dateController
        ..text = DateFormat.yMMMd().format(selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Future<void> signUserUp() async {
    // Loading Indicator

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //TODO : Implementasi sanitazion dan validation pakai package khusus (sanitizationChain & validationChain)
    // If password confirmation failed
    if (passwordController.text != passwordConfirmController.text) {
      Navigator.pop(context);
      genericErrorMessage("Confirmation didn't match the password!");
    }
    else if (namaController.text == ""){
      Navigator.pop(context);
      genericErrorMessage("Please fill the name field!");
    }
    //TODO : Validation untuk tanggal dan gender, walau user tidak bisa pilih selain pilihan, mungkin bisa jadi vulnerability
    else {
      // Sign in validation
      try {
        //TODO : Figure out how to handle both auth and database exception so firebaseauth account is deleted if user data encounters exception
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Pop loading indicator if success
        Navigator.pop(context);
        // If sign up succeed, create new user entry
        UserModel newUser = UserModel(emailController.text, namaController.text, selectedDate.toString(), selectedGender ?? 2, "Isi nomor HP", DateTime(1900).toString(), selectedRole ?? 0, 0);
        UserService().addUser(newUser);
      
      } on FirebaseAuthException catch (e) {
        // Pop loading indicator before displaying error
        Navigator.pop(context);

        switch (e.code) {
          case 'weak-password':
            genericErrorMessage("The password provided is too weak!");
          case 'email-already-in-use':
            genericErrorMessage("The account already exists for that email!");
          case 'invalid-email':
            genericErrorMessage("Invalid email!");
          default:
            print(e.code);
            genericErrorMessage("Unknown error occurred!");
        }
      }
      // If another type of error
      catch (e) {
        print(e);
      }
    }
  }

  void genericErrorMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
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
                        //Email, Nama, Tanggal Lahir, Jenis Kelamin, Role, Password + Confirm
                        children: <Widget>[
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          TextField(
                            controller: namaController,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nama Lengkap",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          //TODO : Field tanggal lahir dan dropdown jenis kelamin

                          TextField(
                              style: TextStyle(color: Colors.black),
                              focusNode: AlwaysDisabledFocusNode(),
                              controller: dateController,
                              //editing controller of this TextField
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  //icon of text field
                                  labelText: "Enter Date" //label text of field
                                  ),
                              readOnly: true,
                              // when true user cannot edit text
                              onTap: () async {
                                _selectDate(context);
                              }),
                          DropdownButtonFormField(
                            autovalidateMode: AutovalidateMode.always,
                            dropdownColor: Colors.white70,
                            style: TextStyle(color: Colors.black),
                            hint: const Text("Pilih jenis kelamin"),
                            items: widget.genderList,
                            onChanged: (int? value) {
                              selectedGender = value;
                              setState(() {});
                            },
                            value: 0,
                            validator: (int? value) {
                              return value == null
                                  ? "Pilih jenis kelamin"
                                  : null;
                            },
                          ),
                          DropdownButtonFormField(
                            autovalidateMode: AutovalidateMode.always,
                            dropdownColor: Colors.white70,
                            style: TextStyle(color: Colors.black),
                            hint: const Text("Apakah anda penghuni atau pemilik kost?"),
                            items: widget.roleList,
                            onChanged: (int? value) {
                              selectedRole = value;
                              setState(() {});
                            },
                            value: 0,
                            validator: (int? value) {
                              return value == null
                                  ? "Pilih jenis kelamin"
                                  : null;
                            },
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          TextField(
                            controller: passwordConfirmController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
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
          FadeAnimation(
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
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent),
                onPressed: () {signUserUp();},
                child: Center(
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
          )
        ],
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
