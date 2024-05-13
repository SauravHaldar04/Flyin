import 'dart:io';
import 'dart:typed_data';

import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/config/utils/appbar.dart';
import 'package:blackcoffer_test_assignment/config/utils/utils.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/auth_services.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/models/user_model.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/providers/user_provider.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/black_button.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/login_textfield.dart';
import 'package:blackcoffer_test_assignment/features/posts/data/data_sources/post_methods.dart';
import 'package:camera/camera.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostVideoScreen extends StatefulWidget {
  const PostVideoScreen(
      {super.key,
      required this.videoPath,
      required this.location,
      required this.file});
  static const routeName = '/post-video';
  final String videoPath;
  final String location;
  final XFile file;
  @override
  State<PostVideoScreen> createState() => _PostVideoScreenState();
}

class _PostVideoScreenState extends State<PostVideoScreen> {
  Uint8List? video;
  late FlickManager flickManager;
  AuthServices authServices = AuthServices();
  UserProvider userProvider = UserProvider();
  bool isLoading = false;
  @override
  void initState() {
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(
      File(widget.videoPath),
    ));
    convertToUint8List();
    setState(() {
      isLoading = true;
    });
    userProvider.refreshUser().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  convertToUint8List() async {
    video = await File(widget.videoPath).readAsBytes();
  }

  postVideo(String uid, String username, String profileImage) async {
    String res = await PostMethods().postImage(
        description: descriptionController.text,
        post: video!,
        title: titleController.text,
        uid: uid,
        username: username,
        profileImage: profileImage,
        location: widget.location,
        category: categoryController.text);
    showSnackBar(context, res);
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    User user = userProvider.getUser();
    return Scaffold(
      backgroundColor: scaffoldbg,
      appBar: buildAppBar(context),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
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
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Title :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        LoginTextField(
                            phoneController: titleController,
                            hintText: 'Enter title',
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 50),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Location :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        Text(
                          widget.location,
                          style: TextStyle(
                              color: tertiaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Category :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        LoginTextField(
                            phoneController: categoryController,
                            hintText: 'Enter Category',
                            width: MediaQuery.of(context).size.width * 0.55,
                            height: 50),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Description :',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.02,
                        ),
                        LoginTextField(
                            phoneController: descriptionController,
                            hintText: 'Description',
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 50),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlackButton(
                      onPressed: () {
                        postVideo(user.uid, user.username, user.profilepic);
                        Navigator.pushNamed(context, '/bottombar');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Post',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
