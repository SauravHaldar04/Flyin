import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String profilepic;

  User({
    required this.uid,
    required this.email,
    required this.username,
    required this.profilepic,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'profilepic': profilepic
    };
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot.toString());
    return User(
      uid: snapshot['uid'],
      email: snapshot['email'],
      username: snapshot['username'],
      profilepic: snapshot['profilepic'],
    );
  }
}
