import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../state/like_state.dart';
import 'chat_room.dart';

/// ================== NEWS FEED ==================
class NewsFeedPage1 extends StatelessWidget {
  const NewsFeedPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: _feedItems.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = _feedItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AvatarImage(item.user.imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.user.fullName} @${item.user.userName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (item.content != null) Text(item.content!),

                      /// ===== FIX IMAGE FEED =====
                      if (item.imageUrl != null)
                        Container(
                          height: 180,
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: item.imageUrl!.startsWith('http')
                                  ? NetworkImage(item.imageUrl!)
                                  : AssetImage(item.imageUrl!)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      _ActionsRow(item: item),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ================== AVATAR ==================
class _AvatarImage extends StatelessWidget {
  final String url;
  const _AvatarImage(this.url);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundImage: url.startsWith('http')
          ? NetworkImage(url)
          : AssetImage(url) as ImageProvider,
    );
  }
}

/// ================== ACTION BUTTONS ==================
class _ActionsRow extends StatefulWidget {
  final FeedItem item;
  const _ActionsRow({required this.item});

  @override
  State<_ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends State<_ActionsRow> {
  void _toggleLike() {
    setState(() {
      widget.item.isLiked = !widget.item.isLiked;

      if (widget.item.isLiked) {
        widget.item.likesCount++;
        likedPostsNotifier.value = [
          ...likedPostsNotifier.value,
          widget.item
        ];
      } else {
        widget.item.likesCount--;
        likedPostsNotifier.value = likedPostsNotifier.value
            .where((e) => e != widget.item)
            .toList();
      }
    });
  }

  void _showShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Share"),
          ),
          ListTile(
            leading: Icon(Icons.link),
            title: Text("Copy Link"),
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: Text("Send to Chat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.mode_comment_outlined),
          label: Text(widget.item.commentsCount.toString()),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SimpleChat(userName: widget.item.user.userName),
              ),
            );
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.repeat),
          label: Text(widget.item.retweetsCount.toString()),
          onPressed: () {},
        ),
        TextButton.icon(
          icon: Icon(
            widget.item.isLiked
                ? Icons.favorite
                : Icons.favorite_border,
            color: widget.item.isLiked ? Colors.red : null,
          ),
          label: Text(widget.item.likesCount.toString()),
          onPressed: _toggleLike,
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.share),
          onPressed: () => _showShare(context),
        ),
      ],
    );
  }
}

/// ================== LIKES PAGE (FIX AVATAR) ==================
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Likes")),
    body: ValueListenableBuilder<List<FeedItem>>(
      valueListenable: likedPostsNotifier,
      builder: (context, items, _) {
        if (items.isEmpty) {
          return const Center(child: Text("Belum ada postingan disukai"));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: item.user.imageUrl.startsWith('http')
                    ? NetworkImage(item.user.imageUrl)
                    : AssetImage(item.user.imageUrl) as ImageProvider,
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

/// ================== MODEL ==================
class FeedItem {
  final String? content;
  final String? imageUrl;
  final User user;
  final int commentsCount;
  int likesCount;
  final int retweetsCount;
  bool isLiked;

  FeedItem({
    this.content,
    this.imageUrl,
    required this.user,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.retweetsCount = 0,
    this.isLiked = false,
  });
}

class User {
  final String fullName;
  final String userName;
  final String imageUrl;

  User(this.fullName, this.userName, this.imageUrl);
}

/// ================== DUMMY DATA ==================
/// ================== DUMMY DATA ==================
final List<User> _users = [
  User("Saif Ali", "ipzonex", "assets/images/saif.jpeg"),
  User("Mushaddiq", "mushaddiq_x", "https://picsum.photos/81"),
  User("Elon Musk", "elon_musk", "https://picsum.photos/82"),
  User("Bills Gates", "bills_gates", "https://picsum.photos/83"),
  User("Mark Zuckerberg", "zuck", "https://picsum.photos/84"),
  User("Jeff Bezos", "jeffbezos", "https://picsum.photos/85"),
  User("Steve Jobs", "stevejobs", "https://picsum.photos/86"),
  User("Mbud", "mbud_134", "https://picsum.photos/87"),
  User("Cristiano Ronaldo", "cr7", "https://picsum.photos/88"),
  User("Lionel Messi", "leomessi", "https://picsum.photos/89"),
  User("Taylor Swift", "taylorswift", "https://picsum.photos/90"),
  User("Rihanna", "rihanna", "https://picsum.photos/91"),
  User("Oprah Winfrey", "oprah", "https://picsum.photos/92"),
  User("Jack Ma", "jackma", "https://picsum.photos/93"),
];

final List<FeedItem> _feedItems = [
  FeedItem(
    user: _users[0],
    content: "Testing !",
    imageUrl: "https://picsum.photos/500/300",
    commentsCount: 8086,
    retweetsCount: 5400,
    likesCount: 17000,
  ),
  FeedItem(
    user: _users[1],
    content: "Halo semuanya apa kabar ? tes ",
    commentsCount: 5,
    retweetsCount: 6,
    likesCount: 22,
  ),
  FeedItem(
    user: _users[2],
    content: "Info Ketoprak ",
    retweetsCount: 57,
    commentsCount: 10,
    likesCount: 307,
  ),
  FeedItem(
    user: _users[3],
    content: "Alhamdulillah akhirnya microsoft bisa kolaborasi dengan ipzonex ",
    commentsCount: 84,
    retweetsCount: 69,
    likesCount: 478,
  ),

  FeedItem(
    user: _users[4],
    content: "Meta sangat terbuka untuk bekerja sama dengan mu saif ali",
    imageUrl: "https://picsum.photos/600/400",
    commentsCount: 1200,
    retweetsCount: 980,
    likesCount: 15000,
  ),
  FeedItem(
    user: _users[5],
    content: "Wkwkwk keren broo ",
    commentsCount: 890,
    retweetsCount: 760,
    likesCount: 13400,
  ),
  FeedItem(
    user: _users[6],
    content: "Gabut euyy",
    imageUrl: "https://picsum.photos/700/500",
    commentsCount: 5400,
    retweetsCount: 4200,
    likesCount: 32000,
  ),
  FeedItem(
    user: _users[7],
    content: "Atas nama mbud, bagi saya udud",
    imageUrl: "https://picsum.photos/800/600",
    commentsCount: 2300,
    retweetsCount: 2100,
    likesCount: 18900,
  ),
  FeedItem(
    user: _users[8],
    content: "Messi mana nihh?",
    commentsCount: 7600,
    retweetsCount: 6900,
    likesCount: 50000,
  ),
  FeedItem(
    user: _users[9],
    content: "Info futsal",
    commentsCount: 8800,
    retweetsCount: 7900,
    likesCount: 61000,
  ),
  FeedItem(
    user: _users[10],
    content: "Pengen karaoke sama ayu ting ting nihh",
    commentsCount: 4500,
    retweetsCount: 3800,
    likesCount: 42000,
  ),
  FeedItem(
    user: _users[11],
    content: "Music connects people across the world.",
    commentsCount: 3900,
    retweetsCount: 3200,
    likesCount: 36000,
  ),
  FeedItem(
    user: _users[12],
    content: "Your story matters.",
    commentsCount: 2700,
    retweetsCount: 2100,
    likesCount: 29800,
  ),
  FeedItem(
    user: _users[13],
    content: "Never give up on your dreams.",
    commentsCount: 4100,
    retweetsCount: 3500,
    likesCount: 44000,
  ),
];

