import 'dart:io';
import 'dart:typed_data';

import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/features/posts/data/data_sources/post_methods.dart';
import 'package:blackcoffer_test_assignment/features/posts/presentation/pages/post_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key, required this.snap});
  final snap;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  String? uint8list;
  getThumnbnail() async {
    try {
      uint8list = await VideoThumbnail.thumbnailFile(
        video: widget.snap['postUrl'],
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 1280,
        quality: 75,
      );
    } catch (error) {
      print("Error generating thumbnail: $error");
      // Handle the error (e.g., display a placeholder image)
    }
  }

  @override
  void initState() {
    getThumnbnail().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    uint8list = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PostMethods().viewPost(widget.snap['postId'],
            FirebaseAuth.instance.currentUser!.uid, widget.snap['views']);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => PostDetails(post: widget.snap)));
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: 700,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: secondaryColor,
          ),
          child: Column(
            children: [
              uint8list != null
                  ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        image: DecorationImage(
                            image: FileImage(File(uint8list!)),
                            fit: BoxFit.cover),
                      ))
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: tertiaryColor,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: tertiaryColor,
                        backgroundImage:
                            NetworkImage(widget.snap['profileImage'])),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.snap['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.snap['username'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: tertiaryColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.27,
                            ),
                            Text(
                              widget.snap['location'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: tertiaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: tertiaryColor,
                              size: MediaQuery.of(context).size.width * 0.04,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.snap['views'].length.toString(),
                              style: TextStyle(
                                  color: tertiaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              DateFormat.yMMM()
                                  .format(widget.snap['datePublished'].toDate())
                                  .toString(),
                              style: TextStyle(
                                  color: tertiaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.snap['category'],
                              style: TextStyle(
                                  color: tertiaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
