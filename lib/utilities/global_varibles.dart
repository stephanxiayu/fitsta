import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsta/screen/add_post_screen.dart';
import 'package:fitsta/screen/feed_screen.dart';
import 'package:fitsta/screen/profil_screen.dart';
import 'package:fitsta/screen/search_screen.dart';
import 'package:flutter/material.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text("1"),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
