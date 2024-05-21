import 'package:flutter/material.dart';
import 'package:fp_golekost/profile/UpdateProfilePage.dart';
import 'ProfileMenu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const tProfile = "Profile";
    const tProfileHeading = "ProfileH";
    const tProfileSubHeading = "ProfileSH";
    const tEditProfile = "Edit Profile";
    final tPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    const tDefaultSize = 10.0;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.chevron_left)),
        title: Text(tProfile, style: Theme.of(context).textTheme.headlineLarge),
        actions: [IconButton(onPressed: () {}, icon: Icon(isDark ? Icons.sunny : Icons.nightlight))],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [

              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100), child: const Image(image: NetworkImage('https://placehold.co/600x400/png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: tPrimaryColor),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(tProfileHeading, style: Theme.of(context).textTheme.headlineLarge),
              Text(tProfileSubHeading, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute (
                      builder: (BuildContext context) => UpdateProfilePage())),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor, side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text(tEditProfile, style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(title: "Settings", icon: Icons.settings, onPress: () {}),
              ProfileMenuWidget(title: "Billing Details", icon: Icons.wallet, onPress: () {}),
              ProfileMenuWidget(title: "User Management", icon: Icons.supervised_user_circle, onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "Information", icon: Icons.info, onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {//TODO : LOGOUT METHOD
                  }),
            ],
          ),
        ),
      ),
    );
  }
}