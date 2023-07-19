import 'package:clicknext_test/model/repositories_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/users_model.dart';

part 'users.g.dart';

@RestApi()
abstract class UsersService {
  factory UsersService(Dio dio, {String baseUrl}) = _UsersService;

  @GET("/users")
  Future<HttpResponse<List<Users>>> getUsers();

  @GET("/users/{name}/repos")
  Future<HttpResponse<List<Repos>>> getRepos(@Path() String name);
}
