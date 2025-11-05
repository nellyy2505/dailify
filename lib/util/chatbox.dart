import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatBox extends StatefulWidget {
  final Function(String, bool) onSendMessage; // Callback to send messages
  final String text;

  const ChatBox({super.key, required this.onSendMessage, required this.text});

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  late TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    OpenAI.apiKey = "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"; // Use environment variable instead of hardcoding
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty || _isLoading) return;

    String userMessage = _controller.text;
    widget.onSendMessage(userMessage, true); // Display user message
    _controller.clear();

    setState(() => _isLoading = true);

    try {
      // OpenAI Chat Completion API call
      final response = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(userMessage)],
          ),
        ],
      );

      String botReply = response.choices.first.message.content?.first.text ?? "Error: no response";

      widget.onSendMessage(botReply, false); // Display bot response
    } catch (e) {
      widget.onSendMessage("Error: Unable to fetch response.", false);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        suffixIcon: _isLoading
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        )
            : IconButton(
          icon: const Icon(Icons.send),
          onPressed: _sendMessage,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.text,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
