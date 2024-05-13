import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String uid;
  final String postUrl;
  final String description;
  final String title;
  final List likes;
  final List dislikes;
  final List shares;
  final List views;
  final String postId;
  final datePublished;
  final String username;
  final String profileImage;
  final String location;
  final String category;

  const Posts(
      {
        required this.dislikes,
        required this.shares,
        required this.description,
        required this.views,
        required this.category,
        required this.location,
      required this.postId,
      required this.datePublished,
      required this.username,
      required this.profileImage,
      required this.likes,
      required this.uid,
      required this.postUrl,
      required this.title});

  Map<String, dynamic> toJson() {
    return {
      'dislikes': dislikes,
      'shares': shares,
      'description': description,
      'views': views,
      'category': category,
      'location': location,
      'uid': uid,
      'postUrl': postUrl,
      'title': title,
      'likes': likes,
      'postId': postId,
      'username': username,
      'profileImage': profileImage,
      'datePublished': datePublished
    };
  }

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    print(snapshot.toString());
    return Posts(
      dislikes: snapshot['dislikes'],
      shares: snapshot['shares'],
        description: snapshot['description'],
      views: snapshot['views'],
        category: snapshot['category'],
      location: snapshot['location'],
        uid: snapshot['uid'],
        title: snapshot['title'],
        postUrl: snapshot['postUrl'],
        likes: snapshot['likes'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        profileImage: snapshot['profileImage']);
  }
}
