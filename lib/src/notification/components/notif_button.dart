import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/src/notification/screens/notification.dart';

class MyNotifButton extends StatelessWidget {
  const MyNotifButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationWidget()));
      },
      icon: const Icon(FontAwesomeIcons.bell),
      iconSize: 25,
      color: Colors.black87,
    );
  }
}
