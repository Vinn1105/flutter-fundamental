import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(image: AssetImage("assets/stimata.jpg"),
    );
  }
}