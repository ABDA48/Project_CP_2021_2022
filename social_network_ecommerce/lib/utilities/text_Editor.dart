import 'package:flutter/material.dart';
class MyTextEditor extends StatelessWidget {
  const MyTextEditor({
    Key? key,
    required TextEditingController textController,
    required String hintText,
  }) : _textController = textController,hint=hintText, super(key: key);

  final TextEditingController _textController;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: TextFormField(controller: _textController,
          decoration: InputDecoration(
            hintText:hint,
          ),
        ),
      ),
    );
  }
}