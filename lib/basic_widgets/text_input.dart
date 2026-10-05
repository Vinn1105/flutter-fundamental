import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  const InputTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      obscureText: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Nama",
      ),
    );
  }
}