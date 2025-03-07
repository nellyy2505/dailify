import "package:flutter/material.dart";

class ChatBox extends StatefulWidget {
  const ChatBox({super.key});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.send),

          //TODO: Chatbot function
          onPressed: () {

          },
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Send a message',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        )

      ),
      controller: _controller,
    );
  }
}
