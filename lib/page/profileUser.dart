import 'dart:developer';
import 'dart:io';

import 'package:clicknext_test/model/repositories_model.dart';
import 'package:clicknext_test/model/users_model.dart';
import 'package:clicknext_test/widget/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retrofit/dio.dart';

import '../service/provider/appdata.dart';
import '../service/users.dart';

class ProfileUser extends StatefulWidget {
  Users user;
  ProfileUser({required this.user, super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  late UsersService usersService;
  List<Repos> repositories = [];

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
        backgroundColor: cBar,
        title: Text(
          'Profile User',
          style: GoogleFonts.roboto(fontWeight: Fw.semiBold),
        ),
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
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 160,
                                  height: 160,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        repositories[0].owner.avatarUrl),
                                    // maxRadius: 50,
                                  ),
                                ),
                              ],
                            ),
                            Gap(10),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    repositories[0].owner.login,
                                    style: GoogleFonts.roboto(
                                        fontSize: 24,
                                        fontWeight: Fw.regular,
                                        color: Colors.white),
                                  ),
                                  Gap(5),
                                  Text(
                                    repositories[0].owner.htmlUrl,
                                    style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: Fw.regular,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade100,
                        height: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Gap(10),
                      Text(
                        'Reponsitories',
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: Fw.regular,
                            fontSize: 24),
                      ),
                      for (int i = 0; i < repositories.length; i++) ...[
                        Column(
                          children: [
                            Divider(
                              color: Colors.grey.shade800,
                              height: 20,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ListTile(
                                title: Text(
                                  repositories[i].name,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: Fw.regular,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  'https://github.com/' +
                                      repositories[i].fullName,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: Fw.regular,
                                      fontSize: 12),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
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
    HttpResponse<List<Repos>> response =
        await usersService.getRepos(widget.user.login);
    repositories = response.data;
  }
}
