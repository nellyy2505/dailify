import "package:flutter/material.dart";

class ChatBox extends StatefulWidget {
  final void Function()? onPressed;
  final String text;
  const ChatBox({
    super.key, 
    required this.onPressed, 
    required this.text,
    }
  );

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
          onPressed: widget.onPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.text,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        )

      ),
      controller: _controller,
    );
  }
}
