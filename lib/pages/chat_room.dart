import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  Message({required this.text, required this.isMe, required this.timestamp});
}

class ChatService {
  final StreamController<Message> _messageController =
      StreamController<Message>.broadcast();
  final StreamController<bool> _typingController =
      StreamController<bool>.broadcast();
  final Random _random = Random();

  Stream<Message> get messageStream => _messageController.stream;
  Stream<bool> get typingStream => _typingController.stream;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final message =
        Message(text: text, isMe: true, timestamp: DateTime.now());

    _messageController.add(message);
    _simulateResponse(text);
  }

  void _simulateResponse(String originalMessage) {
    final delay = _random.nextInt(3) + 1;
    _typingController.add(true);

    Future.delayed(Duration(seconds: delay), () {
      _typingController.add(false);

      final response = Message(
        text: "Balasan otomatis untuk: $originalMessage",
        isMe: false,
        timestamp: DateTime.now(),
      );

      _messageController.add(response);
    });
  }

  void dispose() {
    _messageController.close();
    _typingController.close();
  }
}

class SimpleChat extends StatefulWidget {
  final String userName;

  const SimpleChat({
    Key? key,
    this.userName = "Guest", // ✅ DEFAULT VALUE
  }) : super(key: key);

  @override
  State<SimpleChat> createState() => _SimpleChatState();
}

class _SimpleChatState extends State<SimpleChat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final List<Message> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    _chatService.messageStream.listen((message) {
      setState(() => _messages.add(message));
      _scrollToBottom();
    });

    _chatService.typingStream.listen((typing) {
      setState(() => _isTyping = typing);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _chatService.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    _chatService.sendMessage(text);
    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        "${widget.userName} sedang mengetik...",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat dengan @${widget.userName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _typingIndicator();
                }

                final message = _messages[index];
                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : const Color.fromARGB(255, 38, 120, 242),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
