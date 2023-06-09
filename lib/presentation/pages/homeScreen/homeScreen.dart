import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/presentation/widgets/homeScreenWidgets/homeScreenWidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //add the user info to firestore : image and phone number and birthday date
    final user = FirebaseAuth.instance.currentUser;
    return const HomeScreenWidget();
  }
}