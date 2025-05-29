import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const BlogEditor({
    required this.hintText,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      controller: controller,
      maxLines: null,
    );
  }
}
