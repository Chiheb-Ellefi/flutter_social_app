import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_project/src/follow/screens/follow_screen.dart';
import 'package:my_project/src/profile/screens/profile.dart';
import 'package:my_project/src/settings/screens/settings_screen.dart';
import 'package:my_project/src/topics/screens/topics_screen.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  int index = 0;
  final screens = [
    const TopicsWidget(),
    MyProfile(),
    const Followers(),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade100,

        body: screens[index],

        //Floating Action Button

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addtopic');
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          child: const Icon(FontAwesomeIcons.plus),
        ),

        //Navigation bar

        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.grey.shade200,
              iconTheme: MaterialStateProperty.all(
                  const IconThemeData(color: Colors.black87)),
              backgroundColor: Colors.white,
              labelTextStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          child: NavigationBar(
            height: 70,
            selectedIndex: index,
            onDestinationSelected: (index) => setState(() {
              this.index = index;
            }),
            destinations: const [
              NavigationDestination(
                  icon: Icon(
                    Icons.newspaper_outlined,
                    size: 30,
                  ),
                  label: 'Topics'),
              NavigationDestination(
                  icon: Icon(
                    Icons.person_outlined,
                    size: 30,
                  ),
                  label: 'Profile'),
              NavigationDestination(
                  icon: Icon(
                    Icons.group_outlined,
                    size: 30,
                  ),
                  label: 'Followers'),
              NavigationDestination(
                  icon: Icon(
                    Icons.settings_outlined,
                    size: 30,
                  ),
                  label: 'Settings')
            ],
          ),
        ),
      ),
    );
  }
}
