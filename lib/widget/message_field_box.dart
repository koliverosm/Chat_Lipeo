import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  const MessageFieldBox({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final colors = Theme.of(context).colorScheme;

    final outlineInputBorder = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    return TextFormField(
      decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          filled: true,
          suffixIcon: IconButton(
              onPressed: () {}, icon: const Icon(Icons.send_outlined))),
    );
  }
}
