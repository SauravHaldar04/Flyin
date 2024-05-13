import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/config/utils/appbar.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/black_button.dart';
import 'package:blackcoffer_test_assignment/features/posts/presentation/pages/post_video_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});

  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo> {
  CameraController? cameraController;

  List<CameraDescription> cameras = [];
  bool _isRecording = false;
  bool isFront = false;
  XFile? videoFile;
  String? videoPath;
  Position? position;
  List<Placemark> placemarks = [];
  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  @override
  dispose() {
    cameraController!.dispose();
    videoFile = null;
    videoPath = null;
    super.dispose();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      if (isFront) {
        cameraController = CameraController(cameras![1], ResolutionPreset.max);
      } else {
        cameraController = CameraController(cameras![0], ResolutionPreset.max);
      }

      cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  recordVideo() async {
    if (!_isRecording) {
      await cameraController!.prepareForVideoRecording();
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } else {
      videoFile = await cameraController!.stopVideoRecording();
      videoPath = videoFile!.path;

      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showAboutDialog(
          context: context,
          applicationName: 'Location services are disabled.',
          applicationVersion: 'Please enable location services to continue.',
          children: [Text('Please enable location services to continue.')]);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: scaffoldbg,
      body: cameraController == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                CameraPreview(cameraController!),
                Positioned(
                    child: IconButton(
                        onPressed: () {
                          isFront = !isFront;
                          loadCamera();
                        },
                        icon: Icon(
                          Icons.rotate_left,
                          size: 40,
                        )),
                    top: 10,
                    right: 10),
                Positioned(
                  bottom: 0,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          recordVideo();
                        },
                        icon: Icon(
                          _isRecording ? Icons.stop : Icons.fiber_manual_record,
                          color: _isRecording ? Colors.red : Colors.white,
                          size: 70,
                        ),
                      ),
                      BlackButton(
                          width: 100,
                          height: 30,
                          child: Text('Post', style: TextStyle(fontSize: 20)),
                          onPressed: () async {
                            position = await _determinePosition();
                            print(
                                'Latitude:${position!.latitude}, Longitude:${position!.longitude}');
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                    position!.latitude, position!.longitude);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PostVideoScreen(
                                    file: videoFile!,
                                    videoPath: videoPath!,
                                    location:
                                        '${placemarks[0].locality},\n${placemarks[0].country}'),
                              ),
                            );
                            print(placemarks);
                            if (videoPath != null) {
                              print(videoPath!);
                            } else {
                              print('Video not recorded');
                            }
                          })
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
