import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fitsta/Widget/trainings_card.dart';
import 'package:fitsta/model/user.dart';
import 'package:fitsta/providers/user_provider.dart';
import 'package:fitsta/responsiv/mobile_screen_layout.dart';
import 'package:fitsta/responsiv/webscreenlayout.dart';
import 'package:fitsta/resurces/firestore_methodes.dart';
import 'package:fitsta/utilities/colors.dart';
import 'package:fitsta/utilities/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Trainingspage extends StatefulWidget {
  final String? uid;
  const Trainingspage({super.key, this.uid});

  @override
  State<Trainingspage> createState() => _TrainingspageState();
}

class _TrainingspageState extends State<Trainingspage> {
  bool _isLoading = false;

  late final TextEditingController descriptionController =
      TextEditingController();
  void postTrainng(
    String uid,
    String username,
    var datePublished,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadTraining(
        descriptionController.text,
        uid,
        username,
        uid,
        username,
      );
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });

        showSnackBar('Posted', context);
        if (kIsWeb) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const WebScreenLayout()));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MobileScreenLayout()));
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  Future<void> showMyDialog() async {
    //
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: mobileBackgroundColor,
          title: const Text(
            'Bio bearbeiten',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: descriptionController,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'jetzt Ändern',
                style: TextStyle(color: Colors.teal),
              ),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            flex: 3,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showMyDialog();
                      },
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Card(child: Text(descriptionController.text)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          postTrainng(user.uid, user.username,
                              DateTime.now().toString());
                        },
                        icon: const Icon(
                          Icons.upload_file,
                          size: 30,
                        ))
                  ],
                )),
                const Expanded(
                    child: TrainingsCard(
                  text: "gagga",
                ))
              ],
            ))),
        Expanded(
          flex: 7,
          child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('training')
                .where('uid', isEqualTo: widget.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("test"),
                );
              }

              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1,
                      mainAxisSpacing: 1.5),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap =
                        (snapshot.data! as dynamic).docs[index];
                    return Container(
                      child: Card(
                        child: Text(snap['description'],
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                      ),
                    );
                  });
            },
          ),
        )
      ],
    ));
  }
}
