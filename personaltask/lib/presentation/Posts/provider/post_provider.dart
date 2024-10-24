import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personaltask/data/models/album_model.dart';
import 'package:personaltask/data/models/photomodel.dart';
import 'package:personaltask/data/repository/apihandler.dart';
import 'package:personaltask/data/models/post_model.dart';
import 'package:personaltask/data/models/comment_model.dart';

final apiServiceProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchPosts();
});

final commentsProvider =
    FutureProvider.family<List<Comment>, int>((ref, postId) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchComments(postId);
});

final userAlbumsProvider =
    FutureProvider.family<List<Album>, int>((ref, userId) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchUserAlbums(userId);
});

final albumPhotosProvider =
    FutureProvider.family<List<Photo>, int>((ref, albumId) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchAlbumPhotos(albumId);
});
