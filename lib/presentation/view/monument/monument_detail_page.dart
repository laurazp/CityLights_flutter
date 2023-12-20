import 'package:flutter/material.dart';

class MonumentDetailPage extends StatelessWidget {
  const MonumentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monument title here"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          //TODO: añadir info
        ],
      )),
    );
  }
}
