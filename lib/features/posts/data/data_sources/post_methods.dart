import 'dart:typed_data';

import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/storage_methods.dart';
import 'package:blackcoffer_test_assignment/features/posts/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v1.dart';

class PostMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> postImage(
      {required Uint8List post,
      required String title,
      required String uid,
      required String username,
      required String profileImage,
      required String location,
      required String category,
      required String description}) async {
    String res = "Some error occured";
    try {
      String postUrl = await StorageMethods().uploadItem('posts', post, true);
      User user = _auth.currentUser!;
      String postId = Uuid().v1();
      Posts posts = Posts(
          description: description,
          views: [],
          dislikes: [],
          shares: [],
          category: category,
          location: location,
          uid: user.uid,
          postUrl: postUrl,
          title: title,
          likes: [],
          datePublished: DateTime.now(),
          postId: postId,
          username: username,
          profileImage: profileImage);
      _firestore.collection('posts').doc(postId).set(posts.toJson());
      res = 'Post successfull';
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
          'dislikes': FieldValue.arrayRemove([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> dislikePost(String postId, String uid, List dislikes) async {
    try {
      if (dislikes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'dislikes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'dislikes': FieldValue.arrayUnion([uid]),
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> viewPost(String postId, String uid, List views) async {
    try {
      if (views.contains(uid)) {
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'views': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deletePosts(String postId) async {
    String res = 'Some Error Occured';
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'Post deleted Successfully';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
