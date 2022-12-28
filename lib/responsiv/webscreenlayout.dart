import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsta/screen/add_post_screen.dart';
import 'package:fitsta/screen/feed_screen.dart';
import 'package:fitsta/screen/profil_screen.dart';
import 'package:fitsta/screen/search_screen.dart';
import 'package:fitsta/screen/training.dart';
import 'package:flutter/material.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  PageController page = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
                showTooltip: false,
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: Colors.white12,
                selectedColor: Colors.grey.shade900,
                selectedTitleTextStyle: const TextStyle(color: Colors.white),
                selectedIconColor: Colors.white,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: Colors.teal),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 350,
                  ),
                  child: Image.asset(
                    'assets/donat.jpg',
                  ),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'FitSta',
                style: TextStyle(fontSize: 15),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Home',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
                // badgeContent: const Text(
                //   '3',
                //   style: TextStyle(color: Colors.white),
                // ),
                // tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Search User',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.search),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Add Foto',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.add_a_photo),
                trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Trainingsdaten',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.sports_volleyball),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Profil',
                onTap: () {
                  page.jumpToPage(4);
                },
                icon: const Icon(Icons.person),
              ),
              // SideMenuItem(
              //   priority: 5,
              //   onTap: () {
              //     page.jumpToPage(5);
              //   },
              //   icon: const Icon(Icons.image_rounded),
              // ),
              // SideMenuItem(
              //   priority: 6,
              //   title: 'Only Title',
              //   onTap: () {
              //     page.jumpToPage(6);
              //   },
              // ),
              const SideMenuItem(
                priority: 7,
                title: 'Exit',
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                const FeedScreen(),
                const SearchScreen(),
                const AddPostScreen(),
                const Trainingspage(),
                ProfileScreen(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Download',
                      style: TextStyle(fontSize: 35, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Only Title',
                      style: TextStyle(fontSize: 35, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Only Icon',
                      style: TextStyle(fontSize: 35, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
