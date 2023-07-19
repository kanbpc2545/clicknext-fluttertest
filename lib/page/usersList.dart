import 'dart:developer';

import 'package:clicknext_test/page/profileUser.dart';
import 'package:clicknext_test/service/provider/appdata.dart';
import 'package:clicknext_test/service/users.dart';
import 'package:clicknext_test/widget/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retrofit/dio.dart';

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
    Size size = context.mediaQuerySize;
    return Scaffold(
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      for (int i = 0; i < users.length; i++) ...[
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ProfileUser(user: users[i]));
                          },
                          child: ListTile(
                            title: Text(
                              users[i].login,
                              style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: Fw.regular,
                                  color: Colors.white),
                            ),
                            subtitle: Text(users[i].htmlUrl,
                                style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: Fw.regular,
                                    color: Colors.white)),
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(users[i].avatarUrl),
                                // maxRadius: 60,
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<void> loadData() async {
    HttpResponse<List<Users>> response = await usersService.getUsers();
    users = response.data;
  }
}
