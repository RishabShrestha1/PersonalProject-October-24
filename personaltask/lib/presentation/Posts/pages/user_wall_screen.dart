import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personaltask/data/models/post_model.dart';
import 'package:personaltask/data/models/album_model.dart';
import 'package:personaltask/presentation/Posts/pages/album_details_screen.dart';
import 'package:personaltask/presentation/Posts/pages/commentscreen.dart';
import 'package:personaltask/presentation/Posts/provider/post_provider.dart';

class UserContentScreen extends ConsumerStatefulWidget {
  final int userId;
  final List<Post> allPosts;

  const UserContentScreen({
    Key? key,
    required this.userId,
    required this.allPosts,
  }) : super(key: key);

  @override
  _UserContentScreenState createState() => _UserContentScreenState();
}

class _UserContentScreenState extends ConsumerState<UserContentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPosts =
        widget.allPosts.where((post) => post.userId == widget.userId).toList();
    final userAlbums = ref.watch(userAlbumsProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(
        title: Text('User ${widget.userId}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'POSTS',
              icon: Icon(Icons.article_outlined),
            ),
            Tab(
              text: 'ALBUMS',
              icon: Icon(Icons.photo_album_outlined),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Posts Tab
          userPosts.isEmpty
              ? const Center(child: Text('No posts found for this user'))
              : ListView.builder(
                  itemCount: userPosts.length,
                  itemBuilder: (context, index) {
                    final post = userPosts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              post.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              post.body,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CommentScreen(post: post),
                                  ),
                                );
                              },
                              child: const Text(
                                'View Comments',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

          userAlbums.when(
            data: (albums) {
              return albums.isEmpty
                  ? const Center(child: Text('No albums found for this user'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        return Card(
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AlbumDetailsScreen(album: album),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.photo_album_outlined,
                                  size: 32,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    album.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                Center(child: Text('Error loading albums: $error')),
          ),
        ],
      ),
    );
  }
}
