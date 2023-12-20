import 'package:flutter/material.dart';

class MonumentsPage extends StatefulWidget {
  const MonumentsPage({super.key});

  @override
  State<MonumentsPage> createState() => _MonumentsPageState();
}

class _MonumentsPageState extends State<MonumentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monuments")),
      body: SafeArea(
          child: ListView(
              //TODO: añadir info
              )),
    );
  }
}
