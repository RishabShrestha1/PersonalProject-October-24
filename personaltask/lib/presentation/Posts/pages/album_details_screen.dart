import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:personaltask/data/models/album_model.dart';
import 'package:personaltask/presentation/Posts/provider/post_provider.dart';
import 'package:personaltask/presentation/Posts/widgets/photo_grid.dart';

class AlbumDetailsScreen extends ConsumerWidget {
  final Album album;

  const AlbumDetailsScreen({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosAsync = ref.watch(albumPhotosProvider(album.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(album.title),
      ),
      body: photosAsync.when(
        data: (photos) => PhotoGrid(photos: photos),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading photos: $error')),
      ),
    );
  }
}
