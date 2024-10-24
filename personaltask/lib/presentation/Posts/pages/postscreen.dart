import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personaltask/presentation/Posts/pages/commentscreen.dart';
import 'package:personaltask/presentation/Posts/provider/post_provider.dart';

class PostsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: postsAsyncValue.when(
        data: (posts) {
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(post.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          )),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(post: post),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
