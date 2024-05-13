import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/config/utils/appbar.dart';
import 'package:blackcoffer_test_assignment/features/posts/data/data_sources/post_methods.dart';
import 'package:blackcoffer_test_assignment/features/posts/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({super.key, required this.post});
  final post;

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PostMethods postMethods = PostMethods();
  FirebaseAuth auth = FirebaseAuth.instance;
  late FlickManager flickManager;
  bool isLoading = false;
  bool isLiked = false;
  bool isDisliked = false;
  // getPosts() async {
  //   post = Posts.fromSnap(
  //       await firestore.collection('posts').doc(widget.post).get());
  //   setState(() {});
  // }

  @override
  void initState() {
    {
      setState(() {
        isLoading = true;
        flickManager = FlickManager(
            videoPlayerController: VideoPlayerController.networkUrl(
                Uri.parse(widget.post['postUrl'])));
        isLoading = false;
      });
    }
    // if (post!.likes.contains(auth.currentUser!.uid)) {
    //   setState(() {
    //     isLiked = true;
    //   });
    // }
    // if (post!.dislikes.contains(auth.currentUser!.uid)) {
    //   setState(() {
    //     isDisliked = true;
    //   });
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: scaffoldbg,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: FlickVideoPlayer(
                          flickVideoWithControls: FlickVideoWithControls(
                            videoFit: BoxFit.contain,
                            controls: FlickPortraitControls(
                              progressBarSettings: FlickProgressBarSettings(
                                  playedColor: Colors.blue),
                            ),
                          ),
                          flickManager: flickManager,
                        ),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.post['profileImage']),
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post['title'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.post['username'],
                            style: TextStyle(
                              color: tertiaryColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.post['description'],
                style: TextStyle(
                    color: tertiaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: tertiaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.post['views'].length.toString(),
                        style: TextStyle(
                          color: tertiaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Text(
                    DateFormat.yMMMd()
                        .format(widget.post['datePublished'].toDate()),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.post['category'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await postMethods
                              .likePost(widget.post['postId'],
                                  auth.currentUser!.uid, widget.post['likes'])
                              .then((value) {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          });
                        },
                        icon: Icon(
                          Icons.thumb_up,
                          color: tertiaryColor,
                          size: 16,
                        ),
                      ),
                      Text(
                        '${widget.post['likes'].length} likes',
                        style: TextStyle(
                          color: tertiaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await postMethods
                              .dislikePost(
                                  widget.post['postId'],
                                  auth.currentUser!.uid,
                                  widget.post['dislikes'])
                              .then((value) {
                            setState(() {
                              isDisliked = !isDisliked;
                            });
                          });
                        },
                        icon: Icon(
                          Icons.thumb_down,
                          color: tertiaryColor,
                          size: 16,
                        ),
                      ),
                      Text(
                        '${widget.post['dislikes'].length} dislikes',
                        style: TextStyle(
                          color: tertiaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                          color: tertiaryColor,
                          size: 16,
                        ),
                      ),
                      Text(
                        '${widget.post['shares'].length} shares',
                        style: TextStyle(
                          color: tertiaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
