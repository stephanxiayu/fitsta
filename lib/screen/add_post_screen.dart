import 'package:fitsta/model/user.dart';
import 'package:fitsta/responsiv/mobile_screen_layout.dart';
import 'package:fitsta/responsiv/webscreenlayout.dart';
import 'package:fitsta/resurces/firestore_methodes.dart';
import 'package:fitsta/utilities/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          profImage);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });

        showSnackBar('Posted', context);
        clearImage();
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

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Card(
                        color: Colors.teal,
                        child: MaterialButton(
                            onPressed: () => postImage(
                                user.uid, user.username, user.profImage),
                            child: const Text(
                              "Post",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )),
                      ),
                    )
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _file == null
                          ? Center(
                              child: IconButton(
                                onPressed: () => _selectImage(context),
                                icon: const Icon(
                                  Icons.upload,
                                  size: 40,
                                ),
                              ),
                            )
                          : Center(
                              child: SizedBox(
                                height: 350,
                                width: 600,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: MemoryImage(_file!),
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ),
                            ),
                      // CircleAvatar(
                      //   backgroundImage: NetworkImage(user.photoUrl),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: TextField(
                            minLines: 1,
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                                hintText: "Schreibe etwas...",
                                border: InputBorder.none),
                            maxLines: 8,
                          ),
                        ),
                      ),

                      const Divider(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
