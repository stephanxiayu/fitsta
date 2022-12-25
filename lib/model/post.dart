

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String postUrl;
  final String profImage;
  final  datePublished;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.postUrl,
    required this.profImage,
    required this.datePublished,
     required this.likes,
  });

  Map<String, dynamic> toJason() => {
        "description": description,
        "uid": uid,
        "username": username,
             "postId": postId,
        "postUrl": postUrl,
        "profImage": profImage,
        "datePublished": datePublished,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      datePublished: snapshot['datePublished'],
       likes: snapshot['likes'],
    );
  }
}
