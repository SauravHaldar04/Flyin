import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/features/home/presentation/pages/home_screen.dart';
import 'package:blackcoffer_test_assignment/features/posts/presentation/pages/record_video_screen.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
static const routeName = '/bottombar';
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  List<Widget> _children = [
    const HomeScreen(),
    const RecordVideo(),
    const Scaffold(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldbg,
      body: _children[_currentIndex],
      bottomNavigationBar: SizedBox(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            unselectedItemColor: tertiaryColor,
            selectedItemColor: Colors.white,
            elevation: 1,
            backgroundColor: Color.fromARGB(255, 37, 40, 54),
            iconSize: 30,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Library',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
