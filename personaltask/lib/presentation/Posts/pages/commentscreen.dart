import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personaltask/data/models/post_model.dart';
import 'package:personaltask/presentation/Posts/provider/post_provider.dart';

class CommentScreen extends ConsumerWidget {
  final Post post;

  const CommentScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsyncValue = ref.watch(commentsProvider(post.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          //Main post eTA HALNA
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius: 35,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flexible(
                              child: Text('UserID  ${post.userId.toString()}',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                  overflow: TextOverflow.ellipsis)),
                        )),
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Text(post.body),
                  ],
                ),
              ),
            ),
          ),
          //Comments ETA
          Text('Comments', style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: commentsAsyncValue.when(
              data: (comments) {
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              comment.email,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(comment.body),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
