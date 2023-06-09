import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/config/themes.dart';
import 'package:my_project/constants/contant_values.dart';
import 'package:my_project/constants/firebase_consts.dart';
import 'package:my_project/data/models/user_model/user_model.dart';
import 'package:my_project/src/settings/components/change_password/old_password.dart';
import 'package:my_project/src/notification/components/notif_button.dart';
import 'package:my_project/src/settings/screens/edit_profile.dart';
import 'package:my_project/src/settings/screens/manage_tags.dart';
import 'package:my_project/src/settings/webservices/settings_service.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? image, userName, email;

  String uid = FirebaseAuth.instance.currentUser!.uid;

  UserModel myData = UserModel();

  CollectionReference userRef =
      FirebaseFirestore.instance.collection(usersCollection);
  SettingsService service = SettingsService();
  void handleProfileUpdated() async {
    // Perform any necessary actions after profile update, such as fetching updated data
    myData = await service.getProfilePic(userRef: userRef, uid: uid);

    if (mounted) {
      setState(() {
        image = myData.profilePicture;
        userName = myData.username;
        email = myData.email;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    handleProfileUpdated();
  }

  bool light0 = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.black87, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          actions: const [
            MyNotifButton(),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 70,
                foregroundImage: NetworkImage(
                  image ?? avatarDefault,
                ),
                backgroundImage: const NetworkImage(avatarDefault),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                userName ?? '',
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                email ?? '',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EditProile(
                              onProfileUpdated: handleProfileUpdated)));
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0, backgroundColor: myBlue2),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Prefrences',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.bell,
                      size: 25,
                    ),
                    title: const Text(
                      'Notifications',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Switch(
                      value: light0,
                      activeColor: myBlue2,
                      onChanged: (bool value) {
                        setState(() {
                          light0 = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.tags,
                      size: 25,
                    ),
                    title: const Text(
                      'Manage Tags',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManageTags()));
                      },
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.globe,
                      size: 25,
                    ),
                    title: const Text(
                      'Language',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: RadioListTile(
                                    title: const Text('English'),
                                    value: 1,
                                    onChanged: (index) {},
                                    groupValue: 1,
                                  ),
                                ));
                      },
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.lock,
                      size: 25,
                    ),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => OldPassword());
                      },
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      FirebaseAuth.instance
                          .authStateChanges()
                          .listen((User? user) {});
                    },
                    child: const ListTile(
                      leading: Icon(
                        FontAwesomeIcons.rightFromBracket,
                        size: 25,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
