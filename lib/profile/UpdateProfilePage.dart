import 'package:flutter/material.dart';

class UpdateProfilePage extends StatelessWidget {


  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeholderText = "Placeholder";
    final tPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    const tFormHeight = 30.0;
    final controller = null; //TODO : TEXT CONTROLLERS FOR SUBMITTING UPDATED DATA
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.chevron_left)),
        title: Text("Edit Profile", style: Theme.of(context).textTheme.headlineLarge),
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
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text(placeholderText), prefixIcon: Icon(Icons.account_circle)),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text(placeholderText), prefixIcon: Icon(Icons.email)),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text(placeholderText), prefixIcon: Icon(Icons.phone)),
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text(placeholderText),
                        prefixIcon: const Icon(Icons.fingerprint),
                        suffixIcon:
                        IconButton(icon: const Icon(Icons.place), onPressed: () {}),
                      ),
                    ),
                    const SizedBox(height: tFormHeight),

                    // -- Form Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute (
                          builder: (BuildContext context) => const UpdateProfilePage())),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: tPrimaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}