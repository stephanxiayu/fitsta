import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsta/screen/add_post_screen.dart';
import 'package:fitsta/screen/feed_screen.dart';
import 'package:fitsta/screen/profil_screen.dart';
import 'package:fitsta/screen/search_screen.dart';
import 'package:fitsta/screen/training.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedIndex = 0;
  static Container optionStyle = Container();

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return const FeedScreen();

      case 1:
        return const SearchScreen();

      case 2:
        return const AddPostScreen();

      case 3:
        return const Trainingspage();
      case 4:
        return ProfileScreen(
          uid: FirebaseAuth.instance.currentUser!.uid,
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Bar Page"),
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPostScreen()));
              }),
              icon: const Icon(Icons.add_a_photo))
        ],
      ),
      body: getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 9,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.teal,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.teal,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'School',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_volleyball_sharp),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: onItemTapped,
      ),
    );
  }
}
