import 'package:flutter/material.dart';
import '../state/like_state.dart';
import 'feed_page.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Likes")),
      body: ValueListenableBuilder<List<FeedItem>>(
        valueListenable: likedPostsNotifier,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(
              child: Text("Belum ada postingan disukai"),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(item.user.imageUrl),
                ),
                title: Text(item.user.fullName),
                subtitle: Text(item.content ?? ""),
                trailing: const Icon(Icons.favorite, color: Colors.red),
              );
            },
          );
        },
      ),
    );
  }
}
