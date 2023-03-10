import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitsta/Widget/post_card.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) => PostCard(
            snap: snapshot.data!.docs[index].data(),
          ),
        );
      },
    ));
  }
}
