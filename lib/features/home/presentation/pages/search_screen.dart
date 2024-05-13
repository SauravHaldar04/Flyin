import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/config/utils/appbar.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/login_textfield.dart';
import 'package:blackcoffer_test_assignment/features/home/presentation/widgets/posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
static const String routeName = '/search';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isPostSearch = false;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: scaffoldbg,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                LoginTextField(
                  phoneController: searchController,
                  hintText: "Search",
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50,
                  onFieldSubmitted: (value) {
                    setState(() {
                      isPostSearch = true;
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: Chip(
                    label: Text('Filter',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: tertiaryColor, fontSize: 10)),
                    backgroundColor: secondaryColor,
                  ),
                )
              ],
            ),
            isPostSearch
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('title',
                                isGreaterThanOrEqualTo: searchController.text)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No posts found!'));
                          }
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final post = snapshot.data!.docs[index];
                                return PostItem(
                                   
                                    snap: post);
                              });
                        }))
                : Container()
          ],
        ),
      ),
    );
  }
}
