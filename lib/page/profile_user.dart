import 'package:clicknext_test/model/repositories_model.dart';
import 'package:clicknext_test/model/users_model.dart';
import 'package:clicknext_test/widget/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        repositories[0].owner.avatarUrl),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
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
                                  const Gap(5),
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
                      const Gap(10),
                      Container(
                        color: cBar,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Text(
                                'Reponsitories ',
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: Fw.regular,
                                    fontSize: 24),
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF3A3F47),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${repositories.length}',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: Fw.regular,
                                          fontSize: 24),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      for (int i = 0; i < repositories.length; i++) ...[
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    repositories[i].name,
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontWeight: Fw.regular,
                                        fontSize: 16),
                                  ),
                                ),
                                subtitle: Text(
                                  'https://github.com/${repositories[i].fullName}',
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: Fw.regular,
                                      fontSize: 12),
                                ),
                                trailing: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.star_border_outlined,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade800,
                              height: 20,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
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
            return const Center(
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