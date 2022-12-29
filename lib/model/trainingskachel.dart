import 'package:cloud_firestore/cloud_firestore.dart';

class Trainingskachel {
  final String description;
  final String uid;
  final String username;
  final String postId;

  final datePublished;

  const Trainingskachel({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
  });

  Map<String, dynamic> toJason() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
      };

  static Trainingskachel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Trainingskachel(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
    );
  }
}
