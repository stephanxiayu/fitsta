import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String postUrl;
  final String photoUrl;
  final datePublished;
  final likes;
  final String profImage;

  const Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.postId,
      required this.postUrl,
      required this.photoUrl,
      required this.datePublished,
      required this.likes,
      required this.profImage});

  Map<String, dynamic> toJason() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "postUrl": postUrl,
        "photoUrl": photoUrl,
        "datePublished": datePublished,
        "likes": likes,
        "profImage": profImage
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot['description'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        postUrl: snapshot['postUrl'],
        photoUrl: snapshot['photoUrl'],
        datePublished: snapshot['datePublished'],
        likes: snapshot['likes'],
        profImage: snapshot['profImage']);
  }
}
