import 'dart:developer';

import 'package:clicknext_test/page/profile_user.dart';
import 'package:clicknext_test/service/provider/appdata.dart';
import 'package:clicknext_test/service/users.dart';
import 'package:clicknext_test/widget/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retrofit/dio.dart';
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

  @override
  void initState() {
    super.initState();
    usersService = UsersService(Dio(), baseUrl: AppData.baseurl);
  }

  @override
  Widget build(BuildContext context) {
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
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Get.to(() => ProfileUser(user: users[index]));
                    log(index.toString());
                  },
                  child: ListTile(
                    title: Text(
                      users[index].login,
                      style: GoogleFonts.roboto(fontSize: 20, fontWeight: Fw.regular, color: cText),
                    ),
                    subtitle: Text(users[index].htmlUrl, style: const TextStyle(fontSize: 12, fontWeight: Fw.regular, color: cSubText)),
                    leading: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(users[index].avatarUrl),
                      ),
                    ),
                  ),
                ),
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

  Future<void> loadData() async {
    HttpResponse<List<Users>> response = await usersService.getUsers();
    users = response.data;
  }
}
