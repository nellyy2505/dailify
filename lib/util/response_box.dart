import "package:flutter/material.dart";

class ResponseBox extends StatefulWidget {
  const ResponseBox({super.key});

  @override
  State<ResponseBox> createState() => _ResponseBoxState();
}

class _ResponseBoxState extends State<ResponseBox> {
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
          
          //TODO: Response function
          onPressed: () {

          },
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: 'Edit Response',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        )

      ),
      controller: _controller,
    );
  }
}
