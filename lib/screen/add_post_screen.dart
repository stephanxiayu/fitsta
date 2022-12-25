import 'package:fitsta/model/user.dart';
import 'package:fitsta/responsiv/mobile_screen_layout.dart';
import 'package:fitsta/resurces/firestore_methodes.dart';
import 'package:fitsta/utilities/utilities.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../providers/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });

        showSnackBar('Posted', context);
        clearImage();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MobileScreenLayout()));
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

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("creat a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a Photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Von Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Abbrechen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _descriptionController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return
        // _file == null
        //     ? Center(
        //         child: IconButton(
        //           onPressed: () => _selectImage(context),
        //           icon: const Icon(Icons.upload),
        //         ),
        //       )
        //     :
        Scaffold(
      // appBar: AppBar(
      //   backgroundColor: mobileBackgroundColor,
      //   leading: IconButton(
      //       icon: const Icon(Icons.arrow_back), onPressed: clearImage),
      //   title: const Text('posten jetzt'),
      //   centerTitle: false,
      //   actions: [
      //     TextButton(
      //         onPressed: () =>
      //             postImage(user.uid, user.username, user.photoUrl),
      //         child: const Text(
      //           "Post",
      //           style: TextStyle(
      //               color: Colors.blueAccent,
      //               fontWeight: FontWeight.bold,
      //               fontSize: 16),
      //         ))
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: clearImage),
                  const Text('posten jetzt'),
                  TextButton(
                      onPressed: () =>
                          postImage(user.uid, user.username, user.photoUrl),
                      child: const Text(
                        "Post",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              )),
          _isLoading
              ? const LinearProgressIndicator(
                  color: Colors.teal,
                )
              : const Padding(padding: EdgeInsets.only(top: 0)),
          const Divider(),
          Expanded(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        hintText: "Schreibe etwas...",
                        border: InputBorder.none),
                    maxLines: 8,
                  ),
                ),
                _file == null
                    ? IconButton(
                        onPressed: () => _selectImage(context),
                        icon: const Icon(Icons.upload),
                      )
                    : SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter)),
                          ),
                        ),
                      ),
                const Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
