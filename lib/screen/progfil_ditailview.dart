import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsta/model/user.dart';
import 'package:fitsta/providers/user_provider.dart';
import 'package:fitsta/utilities/colors.dart';
import 'package:fitsta/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilDetailView extends StatefulWidget {
  final snap;
  final String? uid;
  const ProfilDetailView({super.key, this.uid, this.snap});

  @override
  State<ProfilDetailView> createState() => _ProfilDetailViewState();
}

class _ProfilDetailViewState extends State<ProfilDetailView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController textEditingController = TextEditingController();
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
    getData();
  }

  bool isLikeAnimating = false;
  int commentLen = 0;

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      print(
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Users user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];
                  return Container(
                    color: mobileBackgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      //header Section
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16)
                              .copyWith(right: 0),
                          child: Row(
                            children: [
                              // Container(
                              //   child: Image(
                              //     image: NetworkImage(snap['postUrl']),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              // CircleAvatar(
                              //   radius: 16,
                              //   backgroundImage:
                              //       NetworkImage(widget.snap['profImage']),
                              // ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snap['username'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                DateFormat.yMMMd()
                                    .format(snap['datePublished'].toDate()),
                                style: const TextStyle(
                                    fontSize: 16, color: secondaryColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    // Container(
                    //   child: Image(
                    //     image: NetworkImage(snap['postUrl']),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                  );
                });
          },
        ),
      ),
    );
  }
}
