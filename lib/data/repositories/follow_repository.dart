import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class FollowRepository {
  Future<List<Following>> getFollowing() async {
    try {
      final response = await DioClient().dio.get('/follow/following');
      final data = BaseResponse.fromJson(response.data).data;
      final followings =
          List<Following>.from(data.map((x) => Following.fromJson(x)));
      return followings;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<Follower>> getFollower() async {
    try {
      final response = await DioClient().dio.get('/follow/followers');
      final data = BaseResponse.fromJson(response.data).data;
      final followers =
          List<Follower>.from(data.map((x) => Follower.fromJson(x)));
      return followers;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<Following> follow({required int userId}) async {
    try {
      final response = await DioClient().dio.post('/follow/$userId');
      final data = BaseResponse.fromJson(response.data).data;
      final following = Following.fromJson(data);
      return following;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<Following> unFollow({required int userId}) async {
    try {
      final response = await DioClient().dio.delete('/follow/unFollow/$userId');
      final data = BaseResponse.fromJson(response.data).data;
      final following = Following.fromJson(data);
      return following;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
