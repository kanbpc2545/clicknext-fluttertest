import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../model/users_model.dart';

part 'followers.g.dart';

@RestApi()
abstract class FollowerService {
  factory FollowerService(Dio dio, {String baseUrl}) = _FollowerService;

  @GET("/users/{name}/followers")
  Future<HttpResponse<List<Users>>> getFollower(@Path() String name);

  @GET("/users/{name}/following")
  Future<HttpResponse<List<Users>>> getFollowing(@Path() String name);
}
