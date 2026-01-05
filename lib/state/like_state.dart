import 'package:flutter/foundation.dart';
import '../pages/feed_page.dart';

// Global notifier untuk liked posts
final ValueNotifier<List<FeedItem>> likedPostsNotifier =
    ValueNotifier<List<FeedItem>>([]);

class LikesState {
  static List<FeedItem> get likedPosts => likedPostsNotifier.value;

  static bool isLiked(FeedItem item) {
    return likedPostsNotifier.value.contains(item);
  }

  static void toggleLike(FeedItem item) {
    if (isLiked(item)) {
      likedPostsNotifier.value = likedPostsNotifier.value
          .where((e) => e != item)
          .toList();
    } else {
      likedPostsNotifier.value = [
        ...likedPostsNotifier.value,
        item
      ];
    }
  }
}