import 'package:clicknext_test/page/profile_user.dart';
import 'package:clicknext_test/service/provider/appdata.dart';
import 'package:clicknext_test/service/users.dart';
import 'package:clicknext_test/widget/constant.dart';
import 'package:dio/dio.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retrofit/dio.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:skeletons/skeletons.dart';

import '../model/users_model.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<Users> users = [];
  late UsersService usersService;
  List<Users> result = [];
  late Future<void> loadDataMethod;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    usersService = UsersService(Dio(), baseUrl: AppData.baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    final words = nouns.take(50).toList();
    return RefreshIndicator(
      onRefresh: () async {
        loadData();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: cBody,
        appBar: AppBar(
          title: Center(
            child: Text(
              'Github User',
              style: GoogleFonts.roboto(fontWeight: Fw.semiBold),
            ),
          ),
          backgroundColor: cBar,
        ),
        body: FutureBuilder(
          future: loadDataMethod,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (searchText) {
                        this.searchText = searchText;
                        if (searchText.isEmpty) {
                          loadDataMethod;
                        }
                        search(searchText);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: cBar,
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: cSubText),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          suffixIcon: const Icon(Icons.search),
                          suffixIconColor: cSubText),
                      style: const TextStyle(color: cText),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: result.length,
                      itemBuilder: (context, index) => ListTile(
                        title: SearchTextInheritedWidget(
                          searchText: searchText,
                          child: SearchHighlightText(
                            highlightStyle: GoogleFonts.roboto(fontSize: 20, fontWeight: Fw.regular, color: Colors.yellowAccent),
                            result[index].login,
                            style: GoogleFonts.roboto(fontSize: 20, fontWeight: Fw.regular, color: cText),
                          ),
                        ),
                        subtitle: Text(result[index].htmlUrl, style: const TextStyle(fontSize: 12, fontWeight: Fw.regular, color: cSubText)),
                        leading: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(result[index].avatarUrl),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await share(result[index].htmlUrl);
                              },
                              icon: const Icon(Icons.share_sharp),
                              color: Colors.blueAccent,
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(() => ProfileUser(user: result[index]));
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SkeletonListView(
                item: SkeletonListTile(
                  verticalSpacing: 12,
                  leadingStyle: const SkeletonAvatarStyle(width: 60, height: 60, shape: BoxShape.circle),
                  titleStyle: SkeletonLineStyle(height: 20, minLength: 100, randomLength: true, borderRadius: BorderRadius.circular(12)),
                  subtitleStyle: SkeletonLineStyle(height: 12, minLength: 200, randomLength: true, borderRadius: BorderRadius.circular(12)),
                  hasSubtitle: true,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  search(String username) {
    List<Users> result = [];
    result = users.where((user) => user.login.toLowerCase().contains(username.toLowerCase())).toList();
    this.result = result;
  }

  Future<void> share(String url) async {
    await FlutterShare.share(title: url, linkUrl: url);
  }

  Future<void> loadData() async {
    HttpResponse<List<Users>> response = await usersService.getUsers();
    users = response.data;
    result = users;
  }
}
