import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String username;
  final String uid;
  final String email;
  final String bio;
  final List followers;
  final List following;

  final String profImage;

  const Users(
      {required this.username,
      required this.uid,
      required this.email,
      required this.bio,
      required this.followers,
      required this.following,
      required this.profImage});

  Map<String, dynamic> toJason() => {
        "username": username,
        "uid": uid,
        "email": email,
        "bio": bio,
        "followers": followers,
        "following": following,
        "profImage": profImage,
      };

  static Users fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Users(
        username: snapshot['username'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        profImage: snapshot['profImage']);
  }
}
