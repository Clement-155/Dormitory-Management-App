import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_golekost/model/user_model.dart';
import 'package:fp_golekost/service/user_service.dart';
import 'package:intl/intl.dart';

class ViewProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  Map<int, String> jenis_kelamin = {
    0: "Laki-laki",
    1: "Perempuan",
    2: "Tidak ingin menyebutkan"
  };
  Map<int, String> role = {
    0: "Penghuni",
    1: "Pemilik",
    2: "Debug"
  };
  Map<int, String> status = {
    -1: "Tidak ada (Pemilik)",
    0: "Bukan anggota kost",
    1: "Belum membayar",
    2: "Sudah membayar",
    3: "Telat membayar"
  };

  ViewProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot>  userData = UserService().getUser(user.email!);
    const placeholderText = "Placeholder";
    final tPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    const tFormHeight = 30.0;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.chevron_left)),
        title: Text("Profile", style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                    //TODO : Allow user to upload profile picture/link for profile picture
                    SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: NetworkImage('https://placehold.co/600x400/png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(100), color: tPrimaryColor),
                      child: const Icon(Icons.camera, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields

                Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(stream: userData,
                    builder: (context, snapshot) {
                      // if has data, get all documents from collection
                      if (snapshot.hasData) {
                        Map<String, dynamic> data = snapshot.data!.docs[0].data() as Map<String, dynamic>;

                        // display as list
                        return Column(
                          children: [
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['nama']), prefixIcon: Icon(Icons.account_circle), prefixText: "Nama Lengkap"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['email']), prefixIcon: Icon(Icons.email), prefixText: "Email"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['no_hp']), prefixIcon: Icon(Icons.phone), prefixText: "Nomor HP"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(jenis_kelamin[data['jenis_kelamin']]!), prefixIcon: Icon(Icons.person), prefixText: "Jenis Kelamin (KTP)"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(DateFormat.yMd().format(DateTime.parse(data['tanggal_lahir']).toLocal())), prefixIcon: Icon(Icons.calendar_month), prefixText: "Tanggal Lahir"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(role[data['role']]!), prefixIcon: Icon(Icons.account_box), prefixText: "Jenis Akun"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(status[data['status']]!), prefixIcon: Icon(Icons.payments), prefixText: "Status pembayaran kost (bulan ini)"),
                            ),
                            const SizedBox(height: tFormHeight - 20),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(data['tanggal_masuk_kost'] == '' ? "Belum masuk kost" : DateFormat.yMd().format(DateTime.parse(data['tanggal_masuk_kost']).toLocal())), prefixIcon: Icon(Icons.calendar_month), prefixText: "Tanggal Mulai Sewa Kost (Saat Ini)"),
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
                      }
                      else {
                        return const Text("No Notes");
                      }
                    }),

                    const SizedBox(height: tFormHeight),

                    // -- Form Submit Button
                    //TODO : Add account deletion confirmation by prompting user to submit their name.
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute (
                          builder: (BuildContext context) => ViewProfilePage())),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Delete Account", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),

                    // -- Created Date and Delete Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            text: placeholderText,
                            style: TextStyle(fontSize: 12),
                            children: [
                              TextSpan(
                                  text: "Date",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withOpacity(0.1),
                              elevation: 0,
                              foregroundColor: Colors.red,
                              shape: const StadiumBorder(),
                              side: BorderSide.none),
                          child: const Text("Delete"),
                        ),
                      ],
                    )
                  ],
                ),

            ],
          ),
        ),
      ),
    );
  }
}