import 'package:http/http.dart' as http;
import 'package:personaltask/data/models/album_model.dart';
import 'package:personaltask/data/models/photomodel.dart';
import 'dart:convert';

import 'package:personaltask/data/models/post_model.dart';
import 'package:personaltask/data/models/comment_model.dart';

class PostRepository {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Comment>> fetchComments(int postId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/posts/$postId/comments'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<Album>> fetchUserAlbums(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId/albums'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Photo>> fetchAlbumPhotos(int albumId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/albums/$albumId/photos'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
