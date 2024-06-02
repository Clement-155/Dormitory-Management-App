import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_golekost/model/user_model.dart';
import 'package:fp_golekost/profile/ViewProfilePage.dart';
import 'package:fp_golekost/service/user_service.dart';
import 'package:intl/intl.dart';

class UpdateProfilePage extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser!;

  Map<int, String> jenis_kelamin = {
    0: "Laki-laki",
    1: "Perempuan",
    2: "Tidak ingin menyebutkan"
  };
  Map<int, String> role = {0: "Penghuni", 1: "Pemilik", 2: "Debug"};
  Map<int, String> status = {
    -1: "Tidak ada (Pemilik)",
    0: "Bukan anggota kost",
    1: "Belum membayar",
    2: "Sudah membayar",
    3: "Telat membayar"
  };

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

  UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  //TODO : SETUP INPUT VALIDATION
  late DateTime selectedDate = DateTime(1900);
  int? selectedGender = 0;
  int? selectedRole = 0;
  String? id;
  UserModel? oldUser;

  // text editing controllers
  final hpController = TextEditingController();
  final namaController = TextEditingController();
  final dateController = TextEditingController();

  //TODO : Validate and send update request
  Future<void> updateData(UserModel oldUser) async {
    // Loading Indicator

    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //TODO : Implementasi sanitazion dan validation pakai package khusus (sanitizationChain & validationChain)
    print(oldUser.no_hp.length );
    // If password confirmation failed
    if (hpController.text.length < 10 && hpController.text.length > 12 &&
        !(hpController.text.isEmpty && oldUser.no_hp.length > 9)) {
      Navigator.pop(context);
      genericErrorMessage("Invalid phone number!");
    }
    //TODO : Validation untuk tanggal dan gender, walau user tidak bisa pilih selain pilihan, mungkin bisa jadi vulnerability
    else {
      // Sign in validation
      try {
        UserModel newUser = UserModel(
            oldUser.email,
            namaController.text == '' ? oldUser.nama : namaController.text,
            selectedDate.toString(),
            selectedGender!,
            hpController.text == '' ? oldUser.no_hp : hpController.text,
            oldUser.tanggal_masuk_kost,
            selectedRole!,
            oldUser.status);

        //TODO : Figure out how to handle both auth and database exception so firebaseauth account is deleted if user data encounters exception
        final credential =
        await UserService().updateUser(id!, newUser);
        // Pop loading indicator if success
        Navigator.pop(context);
        Navigator.pop(context);
        //Refresh after update
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ViewProfilePage()));
      } on FirebaseException catch (e) {
        // Pop loading indicator before displaying error
        Navigator.pop(context);
        print(e.code);
        genericErrorMessage("Unknown error occurred!");
      }

      // If another type of error
      catch (e) {
        print(e);
      }
    }
  }

  Future<void> deleteUser() async{
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              "Are you sure",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            TextButton(onPressed: () {Navigator.pop(context);}, child: Text("No, i changed my mind.")),
            TextButton(onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              await widget.user.delete();
              FirebaseAuth.instance.signOut();
              UserService().deleteUser(id!);
              genericErrorMessage("User deleted");
            }, child: Text("Yes."))
          ],
        );
      },
    );
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
    final Stream<QuerySnapshot> userData =
    UserService().getUser(widget.user.email!);
    const placeholderText = "Placeholder";
    final tPrimaryColor = Theme
        .of(context)
        .colorScheme
        .onPrimary;
    const tFormHeight = 30.0;


    _selectDate(BuildContext context) async {
      DateTime? newSelectedDate = await showDatePicker(
          context: context,
          // Umur minimal 18 tahun
          initialDate: DateTime(DateTime
              .now()
              .year - 18, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day),
          firstDate: DateTime(1930),
          lastDate: DateTime(DateTime
              .now()
              .year - 18, DateTime
              .now()
              .month,
              DateTime
                  .now()
                  .day),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme
                      .of(context)
                      .colorScheme
                      .onPrimary,
                  onPrimary: Colors.white,
                  surface: Colors.white70,
                  onSurface: Theme
                      .of(context)
                      .colorScheme
                      .onSecondary,
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


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.chevron_left)),
        title: Text("Edit Profile",
            style: Theme
                .of(context)
                .textTheme
                .headlineLarge),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
          // -- IMAGE with ICON
          Stack(
          children: [
          SizedBox(
          width: 120,
            height: 120,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const Image(
                    image: NetworkImage(
                        'https://placehold.co/600x400/png'))),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: tPrimaryColor),
              child: const Icon(Icons.camera,
                  color: Colors.white, size: 20),
            ),
          ),
          ],
        ),
        const SizedBox(height: 50),

        // -- Form Fields
        Form(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: userData,
                  builder: (context, snapshot) {
                    // if has data, get all documents from collection
                    if (snapshot.hasData) {
                      Map<String, dynamic> data = snapshot.data!.docs[0]
                          .data() as Map<String, dynamic>;
                      id = snapshot.data!.docs[0].id;
                      oldUser = UserModel(
                          data['email'],
                          data['email'],
                          data['tanggal_lahir'],
                          data['jenis_kelamin'],
                          data['no_hp'],
                          data['tanggal_masuk_kost'],
                          data['role'],
                          data['status']);
                      // display as list
                      return Column(
                        children: [
                          //TODO : Add field controllers
                          TextField(
                            controller: namaController,
                            decoration: InputDecoration(
                                label: Text(data['nama']),
                                prefixIcon: Icon(Icons.account_circle),
                                hintText: "Nama Lengkap"),
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: tFormHeight - 20),
                          TextField(

                            readOnly: true,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: tPrimaryColor
                                ),
                                label: Text(data['email']),
                                prefixIcon: Icon(Icons.email),
                                hintText: "Email"),
                          ),
                          const SizedBox(height: tFormHeight - 20),
                          TextField(
                            controller: hpController,
                            decoration: InputDecoration(
                                label: Text(data['no_hp']),
                                prefixIcon: Icon(Icons.phone),
                                hintText: "Nomor HP"),
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: tFormHeight - 20),
                          DropdownButtonFormField(
                            autovalidateMode: AutovalidateMode.always,
                            dropdownColor: tPrimaryColor,
                            style: TextStyle(color: Colors.white),
                            hint: const Text("Pilih jenis kelamin (KTP)"),
                            items: widget.genderList,
                            onChanged: (int? value) {
                              selectedGender = value;
                              setState(() {});
                            },
                            value: data['jenis_kelamin'] as int,
                            validator: (int? value) {
                              return value == null
                                  ? "Pilih jenis kelamin"
                                  : null;
                            },
                          ),
                          const SizedBox(height: tFormHeight - 20),
                          TextField(
                              focusNode: AlwaysDisabledFocusNode(),
                              controller: dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: DateFormat.yMd().format(
                                    DateTime.parse(
                                        data['tanggal_lahir'])
                                        .toLocal()),
                                prefixIcon: Icon(Icons.calendar_month),),
                              onTap: () async {
                                _selectDate(context);
                              }),
                          const SizedBox(height: tFormHeight - 20),
                          DropdownButtonFormField(
                            autovalidateMode: AutovalidateMode.always,
                            dropdownColor: tPrimaryColor,
                            style: TextStyle(color: Colors.white),
                            hint: const Text(
                                "Apakah anda penghuni atau pemilik kost?"),
                            items: widget.roleList,
                            onChanged: (int? value) {
                              selectedRole = value;
                              setState(() {});
                            },
                            value: data['role'] as int,
                            validator: (int? value) {
                              return value == null
                                  ? "Pilih jenis kelamin"
                                  : null;
                            },
                          ),
                          // TextField(
                          //   obscureText: true,
                          //   decoration: InputDecoration(
                          //     label: const Text(placeholderText),
                          //     prefixIcon: const Icon(Icons.fingerprint),
                          //     suffixIcon:
                          //     IconButton(icon: const Icon(Icons.place), onPressed: () {}),
                          //   ),
                          // ),
                        ],
                      );
                    } else {
                      return const Text("No Notes");
                    }
                  }),
              const SizedBox(height: tFormHeight - 20),
              const SizedBox(height: tFormHeight - 20),
              // TextFormField(
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     label: const Text(placeholderText),
              //     prefixIcon: const Icon(Icons.fingerprint),
              //     suffixIcon:
              //     IconButton(icon: const Icon(Icons.place), onPressed: () {}),
              //   ),

              const SizedBox(height: tFormHeight),

              // -- Form Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //Validate and update data
                    updateData(oldUser!);

                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Edit Profile",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: tFormHeight),
              ElevatedButton(
                onPressed: () {deleteUser();},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    elevation: 0,
                    foregroundColor: Colors.red,
                    shape: const StadiumBorder(),
                    side: BorderSide.none),
                child: const Text("Delete User Account"),
              ),
            ],
          )

        ),

      ],
    ),)
    ,
    )
    ,
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
