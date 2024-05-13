import 'package:blackcoffer_test_assignment/config/utils/bottom_bar.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/pages/otp_screen.dart';
import 'package:blackcoffer_test_assignment/features/home/presentation/pages/home_screen.dart';
import 'package:blackcoffer_test_assignment/features/home/presentation/pages/search_screen.dart';
import 'package:blackcoffer_test_assignment/features/posts/presentation/pages/post_video_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case OTPScreen.routeName:
      {
        var verificationId = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OTPScreen(verificationId: verificationId),
        );
      }
    case PostVideoScreen.routeName:
      {
        var videoPath = routeSettings.arguments as String;
        var location = routeSettings.arguments as String;
        var file = routeSettings.arguments as XFile;
        return MaterialPageRoute(
            builder: (_) => PostVideoScreen(
                  file: file,
                  videoPath: videoPath,
                  location: location,
                ));
      }
    case HomeScreen.routeName:
      {
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      }
    case BottomBar.routeName:
      {
        return MaterialPageRoute(builder: (_) => const BottomBar());
      }
    case SearchScreen.routeName:
      {
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      }
    default:
      {
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Route Not found!")),
          ),
        );
      }
  }
}
